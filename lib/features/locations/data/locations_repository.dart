import 'package:drift/drift.dart' hide Component;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/errors/exceptions.dart';

class LocationStockStats {
  final int componentCount;
  final int totalUnits;
  final int totalValueCents;

  const LocationStockStats({
    required this.componentCount,
    required this.totalUnits,
    required this.totalValueCents,
  });
}

class LocationComponentItem {
  final Component component;
  final int quantity;

  const LocationComponentItem({
    required this.component,
    required this.quantity,
  });
}

final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  return LocationsRepository(ref.watch(databaseProvider));
});

class LocationsRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  LocationsRepository(this._db);

  Stream<List<Location>> watchAllLocations({bool includeArchived = false}) {
    final query = _db.select(_db.locations);
    if (!includeArchived) {
      query.where((tbl) => tbl.archivedAt.isNull());
    }
    query.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return query.watch();
  }

  Future<List<Location>> getAllActiveLocations() {
    return (_db.select(_db.locations)
          ..where((tbl) => tbl.archivedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<Location?> getLocationById(String id) {
    return (_db.select(
      _db.locations,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Stream<Location?> watchLocationById(String id) {
    return (_db.select(
      _db.locations,
    )..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();
  }

  Future<String> createLocation({
    required String name,
    String? parentId,
    String? code,
    String? description,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const PartPouchException('Location name cannot be empty.');
    }

    if (parentId != null) {
      final parent = await getLocationById(parentId);
      if (parent == null) {
        throw const PartPouchException(
          'Selected parent location does not exist.',
        );
      }
    }

    final id = _uuid.v4();
    final now = DateTime.now();

    await _db
        .into(_db.locations)
        .insert(
          LocationsCompanion.insert(
            id: id,
            name: trimmedName,
            parentId: Value(parentId),
            code: Value(code?.trim()),
            description: Value(description?.trim()),
            createdAt: now,
            updatedAt: now,
          ),
        );

    return id;
  }

  Future<void> updateLocation({
    required String id,
    required String name,
    String? parentId,
    String? code,
    String? description,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const PartPouchException('Location name cannot be empty.');
    }

    // Validate hierarchy to prevent cycles
    await _validateHierarchy(id, parentId);

    await (_db.update(_db.locations)..where((tbl) => tbl.id.equals(id))).write(
      LocationsCompanion(
        name: Value(trimmedName),
        parentId: Value(parentId),
        code: Value(code?.trim()),
        description: Value(description?.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _validateHierarchy(
    String locationId,
    String? proposedParentId,
  ) async {
    if (proposedParentId == null) return;
    if (locationId == proposedParentId) {
      throw const InvalidLocationHierarchyException(
        'A location cannot be its own parent.',
      );
    }

    // Check if proposedParentId is a descendant of locationId
    final allLocations = await (_db.select(
      _db.locations,
    )..where((tbl) => tbl.archivedAt.isNull())).get();
    final Map<String, List<String>> childrenMap = {};
    for (final loc in allLocations) {
      if (loc.parentId != null) {
        childrenMap.putIfAbsent(loc.parentId!, () => []).add(loc.id);
      }
    }

    final Set<String> descendants = {};
    void collectDescendants(String currentId) {
      final children = childrenMap[currentId] ?? [];
      for (final child in children) {
        if (descendants.add(child)) {
          collectDescendants(child);
        }
      }
    }

    collectDescendants(locationId);

    if (descendants.contains(proposedParentId)) {
      throw const InvalidLocationHierarchyException(
        'Cannot move a location into one of its sub-locations.',
      );
    }
  }

  Future<void> archiveLocation(String id) async {
    // 1. Check if location has stock
    final balances =
        await (_db.select(_db.inventoryBalances)..where(
              (tbl) =>
                  tbl.locationId.equals(id) & tbl.quantity.isBiggerThanValue(0),
            ))
            .get();

    final totalStock = balances.fold<int>(0, (sum, b) => sum + b.quantity);
    if (totalStock > 0) {
      throw LocationNotEmptyException(totalStock);
    }

    // 2. Check if active child locations exist
    final children = await (_db.select(
      _db.locations,
    )..where((tbl) => tbl.parentId.equals(id) & tbl.archivedAt.isNull())).get();

    if (children.isNotEmpty) {
      throw const PartPouchException(
        'Cannot archive location with active sub-locations. Move or archive sub-locations first.',
      );
    }

    await (_db.update(_db.locations)..where((tbl) => tbl.id.equals(id))).write(
      LocationsCompanion(
        archivedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<LocationStockStats> watchLocationStockStats(String locationId) {
    final query =
        _db.select(_db.inventoryBalances).join([
          innerJoin(
            _db.components,
            _db.components.id.equalsExp(_db.inventoryBalances.componentId),
          ),
        ])..where(
          _db.inventoryBalances.locationId.equals(locationId) &
              _db.inventoryBalances.quantity.isBiggerThanValue(0),
        );

    return query.watch().map((rows) {
      int count = 0;
      int units = 0;
      int totalVal = 0;

      for (final row in rows) {
        final balance = row.readTable(_db.inventoryBalances);
        final component = row.readTable(_db.components);
        count++;
        units += balance.quantity;
        if (component.unitCostCents != null) {
          totalVal += balance.quantity * component.unitCostCents!;
        }
      }

      return LocationStockStats(
        componentCount: count,
        totalUnits: units,
        totalValueCents: totalVal,
      );
    });
  }

  /// Watches aggregated direct stock stats for all locations in a single reactive stream
  Stream<Map<String, LocationStockStats>> watchAllLocationStockStats() {
    final query = _db.select(_db.inventoryBalances).join([
      innerJoin(
        _db.components,
        _db.components.id.equalsExp(_db.inventoryBalances.componentId),
      ),
    ])..where(_db.inventoryBalances.quantity.isBiggerThanValue(0));

    return query.watch().map((rows) {
      final Map<String, int> counts = {};
      final Map<String, int> units = {};
      final Map<String, int> values = {};

      for (final row in rows) {
        final balance = row.readTable(_db.inventoryBalances);
        final component = row.readTable(_db.components);
        final locId = balance.locationId;
        counts[locId] = (counts[locId] ?? 0) + 1;
        units[locId] = (units[locId] ?? 0) + balance.quantity;
        if (component.unitCostCents != null) {
          values[locId] =
              (values[locId] ?? 0) +
              (balance.quantity * component.unitCostCents!);
        }
      }

      final Map<String, LocationStockStats> result = {};
      for (final locId in units.keys) {
        result[locId] = LocationStockStats(
          componentCount: counts[locId] ?? 0,
          totalUnits: units[locId] ?? 0,
          totalValueCents: values[locId] ?? 0,
        );
      }
      return result;
    });
  }

  /// Watches immediate sub-locations for a given parent
  Stream<List<Location>> watchSubLocations(String parentId) {
    return (_db.select(_db.locations)
          ..where(
            (tbl) => tbl.parentId.equals(parentId) & tbl.archivedAt.isNull(),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .watch();
  }

  /// Watches the direct parent location for breadcrumb and context
  Stream<Location?> watchParentLocation(String? parentId) {
    if (parentId == null) return Stream.value(null);
    return watchLocationById(parentId);
  }

  Stream<List<LocationComponentItem>> watchComponentsInLocation(
    String locationId,
  ) {
    final query =
        _db.select(_db.inventoryBalances).join([
            innerJoin(
              _db.components,
              _db.components.id.equalsExp(_db.inventoryBalances.componentId),
            ),
          ])
          ..where(
            _db.inventoryBalances.locationId.equals(locationId) &
                _db.inventoryBalances.quantity.isBiggerThanValue(0),
          )
          ..orderBy([OrderingTerm.asc(_db.components.name)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return LocationComponentItem(
          component: row.readTable(_db.components),
          quantity: row.readTable(_db.inventoryBalances).quantity,
        );
      }).toList();
    });
  }
}
