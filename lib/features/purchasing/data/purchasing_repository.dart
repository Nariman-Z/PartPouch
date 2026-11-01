import 'package:drift/drift.dart' hide Component;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/errors/exceptions.dart';

class PurchaseOrderWithDetails {
  final PurchaseOrder order;
  final Supplier? supplier;
  final List<PurchaseOrderItemDetail> items;

  const PurchaseOrderWithDetails({
    required this.order,
    required this.supplier,
    required this.items,
  });

  int get totalCostCents => items.fold<int>(
    0,
    (sum, item) => sum + (item.item.orderedQuantity * item.item.unitCostCents),
  );
  int get totalOrderedUnits =>
      items.fold<int>(0, (sum, item) => sum + item.item.orderedQuantity);
  int get totalReceivedUnits =>
      items.fold<int>(0, (sum, item) => sum + item.item.receivedQuantity);
}

class PurchaseOrderItemDetail {
  final PurchaseOrderItem item;
  final Component component;

  const PurchaseOrderItemDetail({required this.item, required this.component});

  int get remainingQuantity => item.orderedQuantity - item.receivedQuantity;
  bool get isFullyReceived => item.receivedQuantity >= item.orderedQuantity;
}

class NewPurchaseOrderItem {
  final String componentId;
  final int orderedQuantity;
  final int unitCostCents;
  final String? supplierPartNumber;

  const NewPurchaseOrderItem({
    required this.componentId,
    required this.orderedQuantity,
    required this.unitCostCents,
    this.supplierPartNumber,
  });
}

final purchasingRepositoryProvider = Provider<PurchasingRepository>((ref) {
  return PurchasingRepository(ref.watch(databaseProvider));
});

class PurchasingRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  PurchasingRepository(this._db);

  Stream<List<PurchaseOrderWithDetails>> watchAllPurchaseOrders({
    String? statusFilter,
  }) {
    final query = _db.select(_db.purchaseOrders);
    if (statusFilter != null &&
        statusFilter.isNotEmpty &&
        statusFilter != 'All') {
      query.where((tbl) => tbl.status.equals(statusFilter));
    }
    query.orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);

    return query.watch().asyncMap((orders) async {
      final List<PurchaseOrderWithDetails> results = [];

      for (final order in orders) {
        Supplier? supplier;
        if (order.supplierId != null) {
          supplier =
              await (_db.select(_db.suppliers)
                    ..where((tbl) => tbl.id.equals(order.supplierId!)))
                  .getSingleOrNull();
        }

        final itemRows =
            await (_db.select(_db.purchaseOrderItems).join([
                  innerJoin(
                    _db.components,
                    _db.components.id.equalsExp(
                      _db.purchaseOrderItems.componentId,
                    ),
                  ),
                ])..where(
                  _db.purchaseOrderItems.purchaseOrderId.equals(order.id),
                ))
                .get();

        final items = itemRows.map((row) {
          return PurchaseOrderItemDetail(
            item: row.readTable(_db.purchaseOrderItems),
            component: row.readTable(_db.components),
          );
        }).toList();

        results.add(
          PurchaseOrderWithDetails(
            order: order,
            supplier: supplier,
            items: items,
          ),
        );
      }

      return results;
    });
  }

  Stream<PurchaseOrderWithDetails?> watchPurchaseOrder(String id) {
    return (_db.select(
      _db.purchaseOrders,
    )..where((tbl) => tbl.id.equals(id))).watchSingleOrNull().asyncMap((
      order,
    ) async {
      if (order == null) return null;

      Supplier? supplier;
      if (order.supplierId != null) {
        supplier = await (_db.select(
          _db.suppliers,
        )..where((tbl) => tbl.id.equals(order.supplierId!))).getSingleOrNull();
      }

      final itemRows = await (_db.select(_db.purchaseOrderItems).join([
        innerJoin(
          _db.components,
          _db.components.id.equalsExp(_db.purchaseOrderItems.componentId),
        ),
      ])..where(_db.purchaseOrderItems.purchaseOrderId.equals(order.id))).get();

      final items = itemRows.map((row) {
        return PurchaseOrderItemDetail(
          item: row.readTable(_db.purchaseOrderItems),
          component: row.readTable(_db.components),
        );
      }).toList();

      return PurchaseOrderWithDetails(
        order: order,
        supplier: supplier,
        items: items,
      );
    });
  }

  Future<String> createPurchaseOrder({
    required String orderNumber,
    String? supplierId,
    required DateTime orderDate,
    DateTime? expectedArrivalDate,
    String? notes,
    required List<NewPurchaseOrderItem> items,
  }) async {
    final trimmedNumber = orderNumber.trim();
    if (trimmedNumber.isEmpty) {
      throw const PartPouchException('Purchase order number cannot be empty.');
    }
    if (items.isEmpty) {
      throw const PartPouchException(
        'Purchase order must contain at least one line item.',
      );
    }

    final id = _uuid.v4();
    final now = DateTime.now();

    await _db.transaction(() async {
      await _db
          .into(_db.purchaseOrders)
          .insert(
            PurchaseOrdersCompanion.insert(
              id: id,
              orderNumber: trimmedNumber,
              supplierId: Value(supplierId),
              orderDate: orderDate,
              expectedArrivalDate: Value(expectedArrivalDate),
              status: 'ordered',
              notes: Value(notes?.trim()),
              createdAt: now,
              updatedAt: now,
            ),
          );

      for (final item in items) {
        if (item.orderedQuantity <= 0) {
          throw const PartPouchException(
            'Ordered quantity must be greater than zero.',
          );
        }

        await _db
            .into(_db.purchaseOrderItems)
            .insert(
              PurchaseOrderItemsCompanion.insert(
                id: _uuid.v4(),
                purchaseOrderId: id,
                componentId: item.componentId,
                orderedQuantity: item.orderedQuantity,
                unitCostCents: Value(item.unitCostCents),
                supplierPartNumber: Value(item.supplierPartNumber?.trim()),
              ),
            );
      }
    });

    return id;
  }

  /// Receive stock for a purchase order item atomically into inventory
  Future<void> receivePurchaseOrderItem({
    required String purchaseOrderId,
    required String itemId,
    required String destinationLocationId,
    required int quantityToReceive,
    String? notes,
  }) async {
    if (quantityToReceive <= 0) {
      throw const PartPouchException(
        'Quantity to receive must be greater than zero.',
      );
    }

    await _db.transaction(() async {
      final po = await (_db.select(
        _db.purchaseOrders,
      )..where((tbl) => tbl.id.equals(purchaseOrderId))).getSingle();
      final item = await (_db.select(
        _db.purchaseOrderItems,
      )..where((tbl) => tbl.id.equals(itemId))).getSingle();

      final remaining = item.orderedQuantity - item.receivedQuantity;
      if (quantityToReceive > remaining) {
        throw OverReceiptException(
          'Cannot receive $quantityToReceive units. Only $remaining units remaining on order.',
        );
      }

      final newReceived = item.receivedQuantity + quantityToReceive;

      // 1. Update PO item received quantity
      await (_db.update(
        _db.purchaseOrderItems,
      )..where((tbl) => tbl.id.equals(itemId))).write(
        PurchaseOrderItemsCompanion(receivedQuantity: Value(newReceived)),
      );

      // 2. Fetch component to update weighted-average cost
      final component = await (_db.select(
        _db.components,
      )..where((tbl) => tbl.id.equals(item.componentId))).getSingle();
      final allBalances = await (_db.select(
        _db.inventoryBalances,
      )..where((tbl) => tbl.componentId.equals(item.componentId))).get();
      final currentTotalStock = allBalances.fold<int>(
        0,
        (sum, b) => sum + b.quantity,
      );

      int? newCost = component.unitCostCents;
      if (item.unitCostCents > 0) {
        if (currentTotalStock <= 0 || component.unitCostCents == null) {
          newCost = item.unitCostCents;
        } else {
          final totalOldVal = currentTotalStock * component.unitCostCents!;
          final totalNewVal = quantityToReceive * item.unitCostCents;
          newCost =
              ((totalOldVal + totalNewVal) /
                      (currentTotalStock + quantityToReceive))
                  .round();
        }
      }

      await (_db.update(
        _db.components,
      )..where((tbl) => tbl.id.equals(item.componentId))).write(
        ComponentsCompanion(
          unitCostCents: Value(newCost),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 3. Upsert destination inventory balance
      final destBal =
          await (_db.select(_db.inventoryBalances)..where(
                (tbl) =>
                    tbl.componentId.equals(item.componentId) &
                    tbl.locationId.equals(destinationLocationId),
              ))
              .getSingleOrNull();

      if (destBal != null) {
        await (_db.update(
          _db.inventoryBalances,
        )..where((tbl) => tbl.id.equals(destBal.id))).write(
          InventoryBalancesCompanion(
            quantity: Value(destBal.quantity + quantityToReceive),
          ),
        );
      } else {
        await _db
            .into(_db.inventoryBalances)
            .insert(
              InventoryBalancesCompanion.insert(
                id: _uuid.v4(),
                componentId: item.componentId,
                locationId: destinationLocationId,
                quantity: Value(quantityToReceive),
              ),
            );
      }

      // 4. Record in Stock Movement Ledger
      await _db
          .into(_db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: _uuid.v4(),
              componentId: item.componentId,
              movementType: 'purchaseOrderReceipt',
              quantityDelta: quantityToReceive,
              destinationLocationId: Value(destinationLocationId),
              unitCostCents: Value(item.unitCostCents),
              purchaseOrderId: Value(purchaseOrderId),
              supplierId: Value(po.supplierId),
              notes: Value(notes ?? 'Received from ${po.orderNumber}'),
              createdAt: DateTime.now(),
            ),
          );

      // 5. Update overall PO status
      final allPoItems = await (_db.select(
        _db.purchaseOrderItems,
      )..where((tbl) => tbl.purchaseOrderId.equals(purchaseOrderId))).get();
      final allReceived = allPoItems.every(
        (i) => i.receivedQuantity >= i.orderedQuantity,
      );

      final newStatus = allReceived ? 'received' : 'partiallyReceived';

      await (_db.update(
        _db.purchaseOrders,
      )..where((tbl) => tbl.id.equals(purchaseOrderId))).write(
        PurchaseOrdersCompanion(
          status: Value(newStatus),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<void> updateOrderStatus(String id, String status) async {
    await (_db.update(
      _db.purchaseOrders,
    )..where((tbl) => tbl.id.equals(id))).write(
      PurchaseOrdersCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
