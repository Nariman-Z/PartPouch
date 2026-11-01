import 'package:drift/drift.dart' hide Component;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/errors/exceptions.dart';

class StocktakeSessionWithDetails {
  final StocktakeSession session;
  final Location? location;
  final int totalEntries;
  final int discrepancyCount;

  const StocktakeSessionWithDetails({
    required this.session,
    required this.location,
    required this.totalEntries,
    required this.discrepancyCount,
  });
}

class StocktakeEntryDetail {
  final StocktakeEntry entry;
  final Component component;

  const StocktakeEntryDetail({required this.entry, required this.component});

  int get discrepancy => entry.countedQuantity - entry.expectedQuantity;
  bool get hasDiscrepancy => discrepancy != 0;
}

final stocktakeRepositoryProvider = Provider<StocktakeRepository>((ref) {
  return StocktakeRepository(ref.watch(databaseProvider));
});

class StocktakeRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  StocktakeRepository(this._db);

  Stream<List<StocktakeSessionWithDetails>> watchAllSessions() {
    return (_db.select(_db.stocktakeSessions)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)]))
        .watch()
        .asyncMap((sessions) async {
          final List<StocktakeSessionWithDetails> results = [];

          for (final session in sessions) {
            Location? location;
            if (session.locationId != null) {
              location =
                  await (_db.select(_db.locations)
                        ..where((tbl) => tbl.id.equals(session.locationId!)))
                      .getSingleOrNull();
            }

            final entries = await (_db.select(
              _db.stocktakeEntries,
            )..where((tbl) => tbl.sessionId.equals(session.id))).get();
            final discrepancies = entries
                .where((e) => e.expectedQuantity != e.countedQuantity)
                .length;

            results.add(
              StocktakeSessionWithDetails(
                session: session,
                location: location,
                totalEntries: entries.length,
                discrepancyCount: discrepancies,
              ),
            );
          }

          return results;
        });
  }

  Stream<StocktakeSessionWithDetails?> watchSessionById(String sessionId) {
    return (_db.select(_db.stocktakeSessions)
          ..where((tbl) => tbl.id.equals(sessionId)))
        .watchSingleOrNull()
        .asyncMap((session) async {
          if (session == null) return null;

          Location? location;
          if (session.locationId != null) {
            location =
                await (_db.select(_db.locations)
                      ..where((tbl) => tbl.id.equals(session.locationId!)))
                    .getSingleOrNull();
          }

          final entries = await (_db.select(
            _db.stocktakeEntries,
          )..where((tbl) => tbl.sessionId.equals(session.id))).get();
          final discrepancies = entries
              .where((e) => e.expectedQuantity != e.countedQuantity)
              .length;

          return StocktakeSessionWithDetails(
            session: session,
            location: location,
            totalEntries: entries.length,
            discrepancyCount: discrepancies,
          );
        });
  }

  Stream<List<StocktakeEntryDetail>> watchSessionEntries(String sessionId) {
    final query =
        _db.select(_db.stocktakeEntries).join([
            innerJoin(
              _db.components,
              _db.components.id.equalsExp(_db.stocktakeEntries.componentId),
            ),
          ])
          ..where(_db.stocktakeEntries.sessionId.equals(sessionId))
          ..orderBy([OrderingTerm.asc(_db.components.name)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return StocktakeEntryDetail(
          entry: row.readTable(_db.stocktakeEntries),
          component: row.readTable(_db.components),
        );
      }).toList();
    });
  }

  /// Start a new stocktake session and snapshot current balances as expected quantities
  Future<String> startSession({String? locationId, String? notes}) async {
    final sessionId = _uuid.v4();
    final now = DateTime.now();

    await _db.transaction(() async {
      await _db
          .into(_db.stocktakeSessions)
          .insert(
            StocktakeSessionsCompanion.insert(
              id: sessionId,
              locationId: Value(locationId),
              status: 'inProgress',
              startedAt: now,
              notes: Value(notes?.trim()),
            ),
          );

      // Fetch components to count
      if (locationId != null) {
        // Balances in this location
        final rows =
            await (_db.select(_db.inventoryBalances).join([
                  innerJoin(
                    _db.components,
                    _db.components.id.equalsExp(
                      _db.inventoryBalances.componentId,
                    ),
                  ),
                ])..where(
                  _db.inventoryBalances.locationId.equals(locationId) &
                      _db.components.archivedAt.isNull(),
                ))
                .get();

        for (final row in rows) {
          final balance = row.readTable(_db.inventoryBalances);
          await _db
              .into(_db.stocktakeEntries)
              .insert(
                StocktakeEntriesCompanion.insert(
                  id: _uuid.v4(),
                  sessionId: sessionId,
                  componentId: balance.componentId,
                  expectedQuantity: balance.quantity,
                  countedQuantity:
                      balance.quantity, // Default to expected for convenience
                ),
              );
        }
      } else {
        // All active components workshop-wide
        final components = await (_db.select(
          _db.components,
        )..where((tbl) => tbl.archivedAt.isNull())).get();
        final allBalances = await _db.select(_db.inventoryBalances).get();

        for (final comp in components) {
          final total = allBalances
              .where((b) => b.componentId == comp.id)
              .fold<int>(0, (sum, b) => sum + b.quantity);
          await _db
              .into(_db.stocktakeEntries)
              .insert(
                StocktakeEntriesCompanion.insert(
                  id: _uuid.v4(),
                  sessionId: sessionId,
                  componentId: comp.id,
                  expectedQuantity: total,
                  countedQuantity: total,
                ),
              );
        }
      }
    });

    return sessionId;
  }

  Future<void> updateCountedQuantity(
    String entryId,
    int countedQuantity,
  ) async {
    if (countedQuantity < 0) {
      throw const PartPouchException('Counted quantity cannot be negative.');
    }

    await (_db.update(
      _db.stocktakeEntries,
    )..where((tbl) => tbl.id.equals(entryId))).write(
      StocktakeEntriesCompanion(countedQuantity: Value(countedQuantity)),
    );
  }

  /// Finalize and reconcile stocktake: updates balances and logs auditable movements
  Future<void> reconcileSession(String sessionId) async {
    await _db.transaction(() async {
      final session = await (_db.select(
        _db.stocktakeSessions,
      )..where((tbl) => tbl.id.equals(sessionId))).getSingle();
      if (session.status == 'completed') {
        throw const PartPouchException(
          'This stocktake session has already been reconciled.',
        );
      }

      final entries = await (_db.select(
        _db.stocktakeEntries,
      )..where((tbl) => tbl.sessionId.equals(sessionId))).get();

      for (final entry in entries) {
        final delta = entry.countedQuantity - entry.expectedQuantity;
        if (delta != 0) {
          if (session.locationId != null) {
            // Update location balance
            final balance =
                await (_db.select(_db.inventoryBalances)..where(
                      (tbl) =>
                          tbl.componentId.equals(entry.componentId) &
                          tbl.locationId.equals(session.locationId!),
                    ))
                    .getSingleOrNull();

            if (balance != null) {
              await (_db.update(
                _db.inventoryBalances,
              )..where((tbl) => tbl.id.equals(balance.id))).write(
                InventoryBalancesCompanion(
                  quantity: Value(entry.countedQuantity),
                ),
              );
            } else {
              await _db
                  .into(_db.inventoryBalances)
                  .insert(
                    InventoryBalancesCompanion.insert(
                      id: _uuid.v4(),
                      componentId: entry.componentId,
                      locationId: session.locationId!,
                      quantity: Value(entry.countedQuantity),
                    ),
                  );
            }
          }

          // Record stock movement
          await _db
              .into(_db.stockMovements)
              .insert(
                StockMovementsCompanion.insert(
                  id: _uuid.v4(),
                  componentId: entry.componentId,
                  movementType: 'stocktakeReconciliation',
                  quantityDelta: delta,
                  destinationLocationId: delta > 0
                      ? Value(session.locationId)
                      : const Value.absent(),
                  sourceLocationId: delta < 0
                      ? Value(session.locationId)
                      : const Value.absent(),
                  notes: Value(
                    'Stocktake reconciliation (expected: ${entry.expectedQuantity}, counted: ${entry.countedQuantity})',
                  ),
                  createdAt: DateTime.now(),
                ),
              );

          await (_db.update(_db.components)
                ..where((tbl) => tbl.id.equals(entry.componentId)))
              .write(ComponentsCompanion(updatedAt: Value(DateTime.now())));
        }

        await (_db.update(_db.stocktakeEntries)
              ..where((tbl) => tbl.id.equals(entry.id)))
            .write(const StocktakeEntriesCompanion(reconciled: Value(true)));
      }

      // Mark session completed
      await (_db.update(
        _db.stocktakeSessions,
      )..where((tbl) => tbl.id.equals(sessionId))).write(
        StocktakeSessionsCompanion(
          status: const Value('completed'),
          completedAt: Value(DateTime.now()),
        ),
      );
    });
  }
}
