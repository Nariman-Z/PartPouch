import 'package:drift/drift.dart' hide Component;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/errors/exceptions.dart';

final stockMovementsRepositoryProvider = Provider<StockMovementsRepository>((
  ref,
) {
  return StockMovementsRepository(ref.watch(databaseProvider));
});

class StockMovementsRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  StockMovementsRepository(this._db);

  /// Atomic stock receipt
  Future<void> receiveStock({
    required String componentId,
    required String destinationLocationId,
    required int quantity,
    int? unitCostCents,
    String? supplierId,
    String? purchaseOrderId,
    String? notes,
  }) async {
    if (quantity <= 0) {
      throw const PartPouchException(
        'Received quantity must be greater than zero.',
      );
    }

    await _db.transaction(() async {
      // 1. Get current component to calculate moving weighted-average cost
      final component = await (_db.select(
        _db.components,
      )..where((tbl) => tbl.id.equals(componentId))).getSingle();

      // Get current total stock across all locations
      final balances = await (_db.select(
        _db.inventoryBalances,
      )..where((tbl) => tbl.componentId.equals(componentId))).get();
      final currentTotalQty = balances.fold<int>(
        0,
        (sum, b) => sum + b.quantity,
      );

      int? updatedCost = component.unitCostCents;
      if (unitCostCents != null && unitCostCents >= 0) {
        if (currentTotalQty <= 0 || component.unitCostCents == null) {
          updatedCost = unitCostCents;
        } else {
          final totalOldVal = currentTotalQty * component.unitCostCents!;
          final totalNewVal = quantity * unitCostCents;
          updatedCost =
              ((totalOldVal + totalNewVal) / (currentTotalQty + quantity))
                  .round();
        }
      }

      // Update component cost and timestamp
      await (_db.update(
        _db.components,
      )..where((tbl) => tbl.id.equals(componentId))).write(
        ComponentsCompanion(
          unitCostCents: Value(updatedCost),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 2. Upsert Inventory Balance
      final existingBalance =
          await (_db.select(_db.inventoryBalances)..where(
                (tbl) =>
                    tbl.componentId.equals(componentId) &
                    tbl.locationId.equals(destinationLocationId),
              ))
              .getSingleOrNull();

      if (existingBalance != null) {
        await (_db.update(
          _db.inventoryBalances,
        )..where((tbl) => tbl.id.equals(existingBalance.id))).write(
          InventoryBalancesCompanion(
            quantity: Value(existingBalance.quantity + quantity),
          ),
        );
      } else {
        await _db
            .into(_db.inventoryBalances)
            .insert(
              InventoryBalancesCompanion.insert(
                id: _uuid.v4(),
                componentId: componentId,
                locationId: destinationLocationId,
                quantity: Value(quantity),
              ),
            );
      }

      // 3. Record in Stock Movement Ledger
      await _db
          .into(_db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: _uuid.v4(),
              componentId: componentId,
              movementType: 'received',
              quantityDelta: quantity,
              destinationLocationId: Value(destinationLocationId),
              unitCostCents: Value(unitCostCents),
              supplierId: Value(supplierId),
              purchaseOrderId: Value(purchaseOrderId),
              notes: Value(notes),
              createdAt: DateTime.now(),
            ),
          );
    });
  }

  /// Atomic stock issue / use
  Future<void> issueStock({
    required String componentId,
    required String sourceLocationId,
    required int quantity,
    String? projectId,
    String? notes,
  }) async {
    if (quantity <= 0) {
      throw const PartPouchException(
        'Quantity to issue must be greater than zero.',
      );
    }

    await _db.transaction(() async {
      // 1. Check current source balance
      final existingBalance =
          await (_db.select(_db.inventoryBalances)..where(
                (tbl) =>
                    tbl.componentId.equals(componentId) &
                    tbl.locationId.equals(sourceLocationId),
              ))
              .getSingleOrNull();

      final available = existingBalance?.quantity ?? 0;
      if (available < quantity) {
        throw InsufficientStockException(
          available: available,
          requested: quantity,
        );
      }

      // 2. Deduct from balance
      await (_db.update(
        _db.inventoryBalances,
      )..where((tbl) => tbl.id.equals(existingBalance!.id))).write(
        InventoryBalancesCompanion(quantity: Value(available - quantity)),
      );

      // 3. Fetch component unit cost for historical valuation
      final component = await (_db.select(
        _db.components,
      )..where((tbl) => tbl.id.equals(componentId))).getSingle();

      // 4. Record in Stock Movement Ledger
      await _db
          .into(_db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: _uuid.v4(),
              componentId: componentId,
              movementType: 'issued',
              quantityDelta: -quantity,
              sourceLocationId: Value(sourceLocationId),
              unitCostCents: Value(component.unitCostCents),
              projectId: Value(projectId),
              notes: Value(notes),
              createdAt: DateTime.now(),
            ),
          );

      // Update component timestamp
      await (_db.update(_db.components)
            ..where((tbl) => tbl.id.equals(componentId)))
          .write(ComponentsCompanion(updatedAt: Value(DateTime.now())));
    });
  }

  /// Atomic stock transfer between two distinct locations
  Future<void> transferStock({
    required String componentId,
    required String sourceLocationId,
    required String destinationLocationId,
    required int quantity,
    String? notes,
  }) async {
    if (quantity <= 0) {
      throw const PartPouchException(
        'Transfer quantity must be greater than zero.',
      );
    }
    if (sourceLocationId == destinationLocationId) {
      throw const PartPouchException(
        'Source and destination locations must be different.',
      );
    }

    await _db.transaction(() async {
      // 1. Check source balance
      final sourceBalance =
          await (_db.select(_db.inventoryBalances)..where(
                (tbl) =>
                    tbl.componentId.equals(componentId) &
                    tbl.locationId.equals(sourceLocationId),
              ))
              .getSingleOrNull();

      final available = sourceBalance?.quantity ?? 0;
      if (available < quantity) {
        throw InsufficientStockException(
          available: available,
          requested: quantity,
          message:
              'Insufficient stock in source location ($available available, $quantity requested).',
        );
      }

      // Deduct from source
      await (_db.update(
        _db.inventoryBalances,
      )..where((tbl) => tbl.id.equals(sourceBalance!.id))).write(
        InventoryBalancesCompanion(quantity: Value(available - quantity)),
      );

      // 2. Add to destination balance
      final destBalance =
          await (_db.select(_db.inventoryBalances)..where(
                (tbl) =>
                    tbl.componentId.equals(componentId) &
                    tbl.locationId.equals(destinationLocationId),
              ))
              .getSingleOrNull();

      if (destBalance != null) {
        await (_db.update(
          _db.inventoryBalances,
        )..where((tbl) => tbl.id.equals(destBalance.id))).write(
          InventoryBalancesCompanion(
            quantity: Value(destBalance.quantity + quantity),
          ),
        );
      } else {
        await _db
            .into(_db.inventoryBalances)
            .insert(
              InventoryBalancesCompanion.insert(
                id: _uuid.v4(),
                componentId: componentId,
                locationId: destinationLocationId,
                quantity: Value(quantity),
              ),
            );
      }

      // 3. Record in Stock Movement Ledger
      await _db
          .into(_db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: _uuid.v4(),
              componentId: componentId,
              movementType: 'transfer',
              quantityDelta: quantity,
              sourceLocationId: Value(sourceLocationId),
              destinationLocationId: Value(destinationLocationId),
              notes: Value(notes),
              createdAt: DateTime.now(),
            ),
          );

      // Update component timestamp
      await (_db.update(_db.components)
            ..where((tbl) => tbl.id.equals(componentId)))
          .write(ComponentsCompanion(updatedAt: Value(DateTime.now())));
    });
  }

  /// Atomic stock adjustment (physical count discrepancy or calibration)
  Future<void> adjustStock({
    required String componentId,
    required String locationId,
    required int newQuantity,
    required String reason,
  }) async {
    if (newQuantity < 0) {
      throw const PartPouchException('Stock quantity cannot be negative.');
    }
    if (reason.trim().isEmpty) {
      throw const PartPouchException(
        'A reason is required for manual stock adjustments.',
      );
    }

    await _db.transaction(() async {
      final existingBalance =
          await (_db.select(_db.inventoryBalances)..where(
                (tbl) =>
                    tbl.componentId.equals(componentId) &
                    tbl.locationId.equals(locationId),
              ))
              .getSingleOrNull();

      final currentQty = existingBalance?.quantity ?? 0;
      final delta = newQuantity - currentQty;

      if (delta == 0) return; // No change

      if (existingBalance != null) {
        await (_db.update(_db.inventoryBalances)
              ..where((tbl) => tbl.id.equals(existingBalance.id)))
            .write(InventoryBalancesCompanion(quantity: Value(newQuantity)));
      } else {
        await _db
            .into(_db.inventoryBalances)
            .insert(
              InventoryBalancesCompanion.insert(
                id: _uuid.v4(),
                componentId: componentId,
                locationId: locationId,
                quantity: Value(newQuantity),
              ),
            );
      }

      final movementType = delta > 0
          ? 'positiveAdjustment'
          : 'negativeAdjustment';

      await _db
          .into(_db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: _uuid.v4(),
              componentId: componentId,
              movementType: movementType,
              quantityDelta: delta,
              sourceLocationId: delta < 0
                  ? Value(locationId)
                  : const Value.absent(),
              destinationLocationId: delta > 0
                  ? Value(locationId)
                  : const Value.absent(),
              notes: Value(reason),
              createdAt: DateTime.now(),
            ),
          );

      await (_db.update(_db.components)
            ..where((tbl) => tbl.id.equals(componentId)))
          .write(ComponentsCompanion(updatedAt: Value(DateTime.now())));
    });
  }

  /// Watch recent movements for a component
  Stream<List<StockMovement>> watchMovementsForComponent(String componentId) {
    return (_db.select(_db.stockMovements)
          ..where((tbl) => tbl.componentId.equals(componentId))
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.createdAt),
            (tbl) => OrderingTerm.desc(tbl.rowId),
          ]))
        .watch();
  }

  /// Watch all recent stock movements across the workshop
  Stream<List<StockMovement>> watchRecentMovements({int limit = 50}) {
    return (_db.select(_db.stockMovements)
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.createdAt),
            (tbl) => OrderingTerm.desc(tbl.rowId),
          ])
          ..limit(limit))
        .watch();
  }
}
