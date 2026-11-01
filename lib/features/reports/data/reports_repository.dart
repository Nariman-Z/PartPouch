import 'package:drift/drift.dart' hide Component;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

class DashboardSummary {
  final int totalComponents;
  final int totalUnits;
  final int lowStockCount;
  final int outOfStockCount;
  final int totalValuationCents;

  const DashboardSummary({
    required this.totalComponents,
    required this.totalUnits,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.totalValuationCents,
  });
}

class CategoryBreakdownItem {
  final String category;
  final int componentCount;
  final int totalUnits;
  final int totalValuationCents;
  final double percentage;

  const CategoryBreakdownItem({
    required this.category,
    required this.componentCount,
    required this.totalUnits,
    required this.totalValuationCents,
    required this.percentage,
  });
}

class TopUsedComponentItem {
  final Component component;
  final int unitsUsed;

  const TopUsedComponentItem({
    required this.component,
    required this.unitsUsed,
  });
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.watch(databaseProvider));
});

class ReportsRepository {
  final AppDatabase _db;

  ReportsRepository(this._db);

  Stream<DashboardSummary> watchDashboardSummary() {
    return _db.select(_db.components).watch().asyncMap((components) async {
      final active = components.where((c) => c.archivedAt == null).toList();
      final allBalances = await _db.select(_db.inventoryBalances).get();

      int totalUnits = 0;
      int lowStockCount = 0;
      int outOfStockCount = 0;
      int totalValuationCents = 0;

      for (final comp in active) {
        final balances = allBalances.where((b) => b.componentId == comp.id);
        final stock = balances.fold<int>(0, (sum, b) => sum + b.quantity);

        totalUnits += stock;
        if (stock == 0) {
          outOfStockCount++;
        } else if (stock <= comp.minStockThreshold) {
          lowStockCount++;
        }

        if (comp.unitCostCents != null) {
          totalValuationCents += stock * comp.unitCostCents!;
        }
      }

      return DashboardSummary(
        totalComponents: active.length,
        totalUnits: totalUnits,
        lowStockCount: lowStockCount,
        outOfStockCount: outOfStockCount,
        totalValuationCents: totalValuationCents,
      );
    });
  }

  Stream<List<CategoryBreakdownItem>> watchCategoryBreakdown() {
    return _db.select(_db.components).watch().asyncMap((components) async {
      final active = components.where((c) => c.archivedAt == null).toList();
      final allBalances = await _db.select(_db.inventoryBalances).get();

      final Map<String, (int count, int units, int valuation)> catMap = {};
      int grandTotalUnits = 0;

      for (final comp in active) {
        final balances = allBalances.where((b) => b.componentId == comp.id);
        final stock = balances.fold<int>(0, (sum, b) => sum + b.quantity);
        final val = (comp.unitCostCents ?? 0) * stock;

        final current = catMap[comp.category] ?? (0, 0, 0);
        catMap[comp.category] = (
          current.$1 + 1,
          current.$2 + stock,
          current.$3 + val,
        );
        grandTotalUnits += stock;
      }

      final List<CategoryBreakdownItem> items = [];
      catMap.forEach((category, tuple) {
        final percentage = grandTotalUnits > 0
            ? (tuple.$2 / grandTotalUnits) * 100.0
            : 0.0;
        items.add(
          CategoryBreakdownItem(
            category: category,
            componentCount: tuple.$1,
            totalUnits: tuple.$2,
            totalValuationCents: tuple.$3,
            percentage: percentage,
          ),
        );
      });

      items.sort((a, b) => b.totalUnits.compareTo(a.totalUnits));
      return items;
    });
  }

  Stream<List<TopUsedComponentItem>> watchTopUsedComponents({
    int days = 30,
    int limit = 10,
  }) {
    DateTime? sinceDate;
    if (days > 0) {
      sinceDate = DateTime.now().subtract(Duration(days: days));
    }

    final query = _db.select(_db.stockMovements)
      ..where((tbl) => tbl.movementType.equals('issued'));
    if (sinceDate != null) {
      query.where((tbl) => tbl.createdAt.isBiggerOrEqualValue(sinceDate!));
    }

    return query.watch().asyncMap((movements) async {
      final Map<String, int> usedMap = {};
      for (final m in movements) {
        final qty = m.quantityDelta.abs();
        usedMap[m.componentId] = (usedMap[m.componentId] ?? 0) + qty;
      }

      final List<TopUsedComponentItem> items = [];
      for (final entry in usedMap.entries) {
        final comp = await (_db.select(
          _db.components,
        )..where((tbl) => tbl.id.equals(entry.key))).getSingleOrNull();
        if (comp != null) {
          items.add(
            TopUsedComponentItem(component: comp, unitsUsed: entry.value),
          );
        }
      }

      items.sort((a, b) => b.unitsUsed.compareTo(a.unitsUsed));
      return items.take(limit).toList();
    });
  }
}
