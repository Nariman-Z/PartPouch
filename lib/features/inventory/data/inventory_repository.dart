import 'package:drift/drift.dart' hide Component;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/errors/exceptions.dart';

class ComponentWithStock {
  final Component component;
  final int totalStock;
  final int locationCount;
  final String locationDisplay;

  const ComponentWithStock({
    required this.component,
    required this.totalStock,
    required this.locationCount,
    this.locationDisplay = '',
  });

  bool get isOutOfStock => totalStock <= 0;
  bool get isLowStock =>
      totalStock > 0 && totalStock <= component.minStockThreshold;
  bool get isInStock => totalStock > component.minStockThreshold;
}

class LocationBalanceItem {
  final Location location;
  final int quantity;

  const LocationBalanceItem({required this.location, required this.quantity});
}

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(ref.watch(databaseProvider));
});

class InventoryRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  InventoryRepository(this._db);

  Stream<List<ComponentWithStock>> watchComponentsWithStock({
    String? query,
    String? category,
    bool? inStockOnly,
    bool? lowStockOnly,
    bool? outOfStockOnly,
    String? locationId,
    String sortBy =
        'name_asc', // name_asc, name_desc, stock_asc, stock_desc, updated_desc
  }) {
    // 1. Fetch active components
    final compQuery = _db.select(_db.components)
      ..where((tbl) => tbl.archivedAt.isNull());

    if (query != null && query.trim().isNotEmpty) {
      final term = '%${query.trim().toLowerCase()}%';
      compQuery.where(
        (tbl) =>
            tbl.name.lower().like(term) |
            tbl.internalSku.lower().like(term) |
            tbl.manufacturer.lower().like(term) |
            tbl.manufacturerPartNumber.lower().like(term) |
            tbl.packageFootprint.lower().like(term) |
            tbl.tags.lower().like(term),
      );
    }

    if (category != null && category.isNotEmpty && category != 'All') {
      compQuery.where((tbl) => tbl.category.equals(category));
    }

    // 2. Watch components and balances
    return compQuery.watch().asyncMap((components) async {
      final allBalances = await _db.select(_db.inventoryBalances).get();
      final allLocations = await _db.select(_db.locations).get();
      final locationMap = {for (final l in allLocations) l.id: l.name};

      // Filter by locationId if specified
      final Map<String, List<InventoryBalance>> compBalancesMap = {};
      for (final bal in allBalances) {
        if (locationId != null && bal.locationId != locationId) continue;
        compBalancesMap.putIfAbsent(bal.componentId, () => []).add(bal);
      }

      List<ComponentWithStock> result = [];

      for (final comp in components) {
        final balances = compBalancesMap[comp.id] ?? [];
        final totalStock = balances.fold<int>(0, (sum, b) => sum + b.quantity);
        final nonZeroBalances = balances.where((b) => b.quantity > 0).toList();
        final locationCount = nonZeroBalances.length;
        final locNames = nonZeroBalances
            .map((b) => locationMap[b.locationId])
            .whereType<String>()
            .map((name) {
              // Extract concise location code/identifier (e.g. "Box 02 - OLED & LCD Displays" -> "Box 02")
              final parts = name.split(RegExp(r'\s*[-–—]\s*'));
              return parts.isNotEmpty && parts.first.trim().isNotEmpty
                  ? parts.first.trim()
                  : name;
            })
            .toList();
        final locationDisplay = locNames.join(', ');

        // If filtering by location and item not present in location, skip
        if (locationId != null && totalStock == 0 && balances.isEmpty) {
          continue;
        }

        final item = ComponentWithStock(
          component: comp,
          totalStock: totalStock,
          locationCount: locationCount,
          locationDisplay: locationDisplay,
        );

        if (inStockOnly == true && !item.isInStock) continue;
        if (lowStockOnly == true && !item.isLowStock) continue;
        if (outOfStockOnly == true && !item.isOutOfStock) continue;

        result.add(item);
      }

      // Sort
      switch (sortBy) {
        case 'name_desc':
          result.sort(
            (a, b) => b.component.name.toLowerCase().compareTo(
              a.component.name.toLowerCase(),
            ),
          );
          break;
        case 'stock_asc':
          result.sort((a, b) => a.totalStock.compareTo(b.totalStock));
          break;
        case 'stock_desc':
          result.sort((a, b) => b.totalStock.compareTo(a.totalStock));
          break;
        case 'updated_desc':
          result.sort(
            (a, b) => b.component.updatedAt.compareTo(a.component.updatedAt),
          );
          break;
        case 'name_asc':
        default:
          result.sort(
            (a, b) => a.component.name.toLowerCase().compareTo(
              b.component.name.toLowerCase(),
            ),
          );
          break;
      }

      return result;
    });
  }

  Future<Component?> getComponentById(String id) {
    return (_db.select(
      _db.components,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Stream<Component?> watchComponentById(String id) {
    return (_db.select(
      _db.components,
    )..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();
  }

  Stream<int> watchComponentTotalStock(String componentId) {
    return (_db.select(_db.inventoryBalances)
          ..where((tbl) => tbl.componentId.equals(componentId)))
        .watch()
        .map((balances) => balances.fold<int>(0, (sum, b) => sum + b.quantity));
  }

  Stream<List<LocationBalanceItem>> watchBalancesForComponent(
    String componentId,
  ) {
    final query =
        _db.select(_db.inventoryBalances).join([
            innerJoin(
              _db.locations,
              _db.locations.id.equalsExp(_db.inventoryBalances.locationId),
            ),
          ])
          ..where(
            _db.inventoryBalances.componentId.equals(componentId) &
                _db.inventoryBalances.quantity.isBiggerThanValue(0),
          )
          ..orderBy([OrderingTerm.asc(_db.locations.name)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return LocationBalanceItem(
          location: row.readTable(_db.locations),
          quantity: row.readTable(_db.inventoryBalances).quantity,
        );
      }).toList();
    });
  }

  Stream<List<String>> watchAllCategories() {
    return (_db.selectOnly(_db.components, distinct: true)
          ..addColumns([_db.components.category])
          ..where(_db.components.archivedAt.isNull())
          ..orderBy([OrderingTerm.asc(_db.components.category)]))
        .watch()
        .map(
          (rows) => rows.map((r) => r.read(_db.components.category)!).toList(),
        );
  }

  /// Create a new component record, with optional initial stock committed atomically
  Future<String> createComponent({
    required String name,
    required String category,
    String? manufacturer,
    String? manufacturerPartNumber,
    String? internalSku,
    String? description,
    String? packageFootprint,
    String? datasheetUrl,
    String? tags,
    int minStockThreshold = 0,
    int? targetStockQuantity,
    String? defaultSupplierId,
    String unitOfMeasure = 'pcs',
    int? unitCostCents,
    int initialStock = 0,
    String? initialLocationId,
    String? initialNotes,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const PartPouchException('Component name cannot be empty.');
    }
    if (category.trim().isEmpty) {
      throw const PartPouchException('Component category cannot be empty.');
    }
    if (initialStock > 0 && initialLocationId == null) {
      throw const PartPouchException(
        'An initial storage location is required when adding initial stock.',
      );
    }

    final id = _uuid.v4();
    final now = DateTime.now();

    await _db.transaction(() async {
      await _db
          .into(_db.components)
          .insert(
            ComponentsCompanion.insert(
              id: id,
              name: trimmedName,
              category: category.trim(),
              manufacturer: Value(manufacturer?.trim()),
              manufacturerPartNumber: Value(manufacturerPartNumber?.trim()),
              internalSku: Value(internalSku?.trim()),
              description: Value(description?.trim()),
              packageFootprint: Value(packageFootprint?.trim()),
              datasheetUrl: Value(datasheetUrl?.trim()),
              tags: Value(tags?.trim()),
              minStockThreshold: Value(minStockThreshold),
              targetStockQuantity: Value(targetStockQuantity),
              defaultSupplierId: Value(defaultSupplierId),
              unitOfMeasure: Value(
                unitOfMeasure.trim().isEmpty ? 'pcs' : unitOfMeasure.trim(),
              ),
              unitCostCents: Value(unitCostCents),
              createdAt: now,
              updatedAt: now,
            ),
          );

      if (initialStock > 0 && initialLocationId != null) {
        // Upsert balance
        await _db
            .into(_db.inventoryBalances)
            .insert(
              InventoryBalancesCompanion.insert(
                id: _uuid.v4(),
                componentId: id,
                locationId: initialLocationId,
                quantity: Value(initialStock),
              ),
            );

        // Record initialStock in movement ledger
        await _db
            .into(_db.stockMovements)
            .insert(
              StockMovementsCompanion.insert(
                id: _uuid.v4(),
                componentId: id,
                movementType: 'initialStock',
                quantityDelta: initialStock,
                destinationLocationId: Value(initialLocationId),
                unitCostCents: Value(unitCostCents),
                notes: Value(initialNotes ?? 'Initial inventory setup'),
                createdAt: now,
              ),
            );
      }
    });

    return id;
  }

  Future<void> updateComponent({
    required String id,
    required String name,
    required String category,
    String? manufacturer,
    String? manufacturerPartNumber,
    String? internalSku,
    String? description,
    String? packageFootprint,
    String? datasheetUrl,
    String? tags,
    required int minStockThreshold,
    int? targetStockQuantity,
    String? defaultSupplierId,
    required String unitOfMeasure,
    int? unitCostCents,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const PartPouchException('Component name cannot be empty.');
    }

    await (_db.update(_db.components)..where((tbl) => tbl.id.equals(id))).write(
      ComponentsCompanion(
        name: Value(trimmedName),
        category: Value(category.trim()),
        manufacturer: Value(manufacturer?.trim()),
        manufacturerPartNumber: Value(manufacturerPartNumber?.trim()),
        internalSku: Value(internalSku?.trim()),
        description: Value(description?.trim()),
        packageFootprint: Value(packageFootprint?.trim()),
        datasheetUrl: Value(datasheetUrl?.trim()),
        tags: Value(tags?.trim()),
        minStockThreshold: Value(minStockThreshold),
        targetStockQuantity: Value(targetStockQuantity),
        defaultSupplierId: Value(defaultSupplierId),
        unitOfMeasure: Value(
          unitOfMeasure.trim().isEmpty ? 'pcs' : unitOfMeasure.trim(),
        ),
        unitCostCents: Value(unitCostCents),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> archiveComponent(String id) async {
    await (_db.update(_db.components)..where((tbl) => tbl.id.equals(id))).write(
      ComponentsCompanion(
        archivedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
