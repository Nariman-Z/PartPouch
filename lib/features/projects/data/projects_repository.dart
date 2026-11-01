import 'package:drift/drift.dart' hide Component;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/errors/exceptions.dart';

class ProjectWithBomSummary {
  final Project project;
  final int totalBomItems;
  final int completedBomItems;
  final int totalEstimatedCostCents;

  const ProjectWithBomSummary({
    required this.project,
    required this.totalBomItems,
    required this.completedBomItems,
    required this.totalEstimatedCostCents,
  });

  bool get isFullyStocked =>
      totalBomItems > 0 && completedBomItems >= totalBomItems;
}

class ProjectBomItemDetail {
  final ProjectBom bom;
  final Component component;
  final int availableStock;

  const ProjectBomItemDetail({
    required this.bom,
    required this.component,
    required this.availableStock,
  });

  int get shortage => (bom.quantityRequired > availableStock)
      ? bom.quantityRequired - availableStock
      : 0;
  bool get isSatisfied => availableStock >= bom.quantityRequired;
  int get estimatedCostCents =>
      bom.quantityRequired * (component.unitCostCents ?? 0);
}

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  return ProjectsRepository(ref.watch(databaseProvider));
});

class ProjectsRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  ProjectsRepository(this._db);

  Stream<List<ProjectWithBomSummary>> watchAllProjects({String? statusFilter}) {
    final query = _db.select(_db.projects);
    if (statusFilter != null &&
        statusFilter.isNotEmpty &&
        statusFilter != 'All') {
      query.where((tbl) => tbl.status.equals(statusFilter));
    }
    query.orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);

    return query.watch().asyncMap((projects) async {
      final List<ProjectWithBomSummary> results = [];

      for (final project in projects) {
        final boms = await (_db.select(_db.projectBoms).join([
          innerJoin(
            _db.components,
            _db.components.id.equalsExp(_db.projectBoms.componentId),
          ),
        ])..where(_db.projectBoms.projectId.equals(project.id))).get();

        int completed = 0;
        int cost = 0;

        for (final row in boms) {
          final bom = row.readTable(_db.projectBoms);
          final comp = row.readTable(_db.components);

          final balances = await (_db.select(
            _db.inventoryBalances,
          )..where((tbl) => tbl.componentId.equals(comp.id))).get();
          final totalStock = balances.fold<int>(
            0,
            (sum, b) => sum + b.quantity,
          );

          if (totalStock >= bom.quantityRequired) {
            completed++;
          }
          if (comp.unitCostCents != null) {
            cost += bom.quantityRequired * comp.unitCostCents!;
          }
        }

        results.add(
          ProjectWithBomSummary(
            project: project,
            totalBomItems: boms.length,
            completedBomItems: completed,
            totalEstimatedCostCents: cost,
          ),
        );
      }

      return results;
    });
  }

  Stream<Project?> watchProjectById(String id) {
    return (_db.select(
      _db.projects,
    )..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();
  }

  Stream<List<ProjectBomItemDetail>> watchProjectBoms(String projectId) {
    final query = _db.select(_db.projectBoms).join([
      innerJoin(
        _db.components,
        _db.components.id.equalsExp(_db.projectBoms.componentId),
      ),
    ])..where(_db.projectBoms.projectId.equals(projectId));

    return query.watch().asyncMap((rows) async {
      final List<ProjectBomItemDetail> results = [];

      for (final row in rows) {
        final bom = row.readTable(_db.projectBoms);
        final comp = row.readTable(_db.components);

        final balances = await (_db.select(
          _db.inventoryBalances,
        )..where((tbl) => tbl.componentId.equals(comp.id))).get();
        final totalStock = balances.fold<int>(0, (sum, b) => sum + b.quantity);

        results.add(
          ProjectBomItemDetail(
            bom: bom,
            component: comp,
            availableStock: totalStock,
          ),
        );
      }

      return results;
    });
  }

  Future<String> createProject({
    required String name,
    String? description,
    String status = 'inProgress',
    DateTime? targetDate,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const PartPouchException('Project name cannot be empty.');
    }

    final id = _uuid.v4();
    final now = DateTime.now();

    await _db
        .into(_db.projects)
        .insert(
          ProjectsCompanion.insert(
            id: id,
            name: trimmedName,
            description: Value(description?.trim()),
            status: Value(status),
            targetDate: Value(targetDate),
            createdAt: now,
            updatedAt: now,
          ),
        );

    return id;
  }

  Future<void> updateProject({
    required String id,
    required String name,
    String? description,
    required String status,
    DateTime? targetDate,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const PartPouchException('Project name cannot be empty.');
    }

    await (_db.update(_db.projects)..where((tbl) => tbl.id.equals(id))).write(
      ProjectsCompanion(
        name: Value(trimmedName),
        description: Value(description?.trim()),
        status: Value(status),
        targetDate: Value(targetDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> addBomItem({
    required String projectId,
    required String componentId,
    required int quantityRequired,
    String? notes,
  }) async {
    if (quantityRequired <= 0) {
      throw const PartPouchException(
        'Required quantity must be greater than zero.',
      );
    }

    final existing =
        await (_db.select(_db.projectBoms)..where(
              (tbl) =>
                  tbl.projectId.equals(projectId) &
                  tbl.componentId.equals(componentId),
            ))
            .getSingleOrNull();

    if (existing != null) {
      // Update existing requirement
      await (_db.update(
        _db.projectBoms,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        ProjectBomsCompanion(
          quantityRequired: Value(existing.quantityRequired + quantityRequired),
          notes: Value(notes?.trim() ?? existing.notes),
        ),
      );
    } else {
      await _db
          .into(_db.projectBoms)
          .insert(
            ProjectBomsCompanion.insert(
              id: _uuid.v4(),
              projectId: projectId,
              componentId: componentId,
              quantityRequired: quantityRequired,
              notes: Value(notes?.trim()),
            ),
          );
    }

    // Update project timestamp
    await (_db.update(_db.projects)..where((tbl) => tbl.id.equals(projectId)))
        .write(ProjectsCompanion(updatedAt: Value(DateTime.now())));
  }

  Future<void> removeBomItem(String bomId) async {
    await (_db.delete(
      _db.projectBoms,
    )..where((tbl) => tbl.id.equals(bomId))).go();
  }

  /// Issue required stock for a BOM item atomically
  Future<void> issueBomItemStock({
    required String projectId,
    required String componentId,
    required String sourceLocationId,
    required int quantity,
    String? notes,
  }) async {
    if (quantity <= 0) {
      throw const PartPouchException('Quantity must be greater than zero.');
    }

    await _db.transaction(() async {
      final balance =
          await (_db.select(_db.inventoryBalances)..where(
                (tbl) =>
                    tbl.componentId.equals(componentId) &
                    tbl.locationId.equals(sourceLocationId),
              ))
              .getSingleOrNull();

      final available = balance?.quantity ?? 0;
      if (available < quantity) {
        throw InsufficientStockException(
          available: available,
          requested: quantity,
        );
      }

      // Deduct balance
      await (_db.update(
        _db.inventoryBalances,
      )..where((tbl) => tbl.id.equals(balance!.id))).write(
        InventoryBalancesCompanion(quantity: Value(available - quantity)),
      );

      // Log movement
      final project = await (_db.select(
        _db.projects,
      )..where((tbl) => tbl.id.equals(projectId))).getSingle();
      final comp = await (_db.select(
        _db.components,
      )..where((tbl) => tbl.id.equals(componentId))).getSingle();

      await _db
          .into(_db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: _uuid.v4(),
              componentId: componentId,
              movementType: 'issued',
              quantityDelta: -quantity,
              sourceLocationId: Value(sourceLocationId),
              unitCostCents: Value(comp.unitCostCents),
              projectId: Value(projectId),
              notes: Value(notes ?? 'Issued to project ${project.name}'),
              createdAt: DateTime.now(),
            ),
          );

      await (_db.update(_db.projects)..where((tbl) => tbl.id.equals(projectId)))
          .write(ProjectsCompanion(updatedAt: Value(DateTime.now())));
    });
  }
}
