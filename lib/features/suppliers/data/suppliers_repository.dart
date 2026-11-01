import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/errors/exceptions.dart';

final suppliersRepositoryProvider = Provider<SuppliersRepository>((ref) {
  return SuppliersRepository(ref.watch(databaseProvider));
});

class SuppliersRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  SuppliersRepository(this._db);

  Stream<List<Supplier>> watchAllSuppliers({
    String? query,
    bool includeArchived = false,
  }) {
    final q = _db.select(_db.suppliers);
    if (!includeArchived) {
      q.where((tbl) => tbl.archivedAt.isNull());
    }
    if (query != null && query.trim().isNotEmpty) {
      final term = '%${query.trim().toLowerCase()}%';
      q.where(
        (tbl) =>
            tbl.name.lower().like(term) |
            tbl.email.lower().like(term) |
            tbl.website.lower().like(term) |
            tbl.notes.lower().like(term),
      );
    }
    q.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return q.watch();
  }

  Future<Supplier?> getSupplierById(String id) {
    return (_db.select(
      _db.suppliers,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Stream<Supplier?> watchSupplierById(String id) {
    return (_db.select(
      _db.suppliers,
    )..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();
  }

  Future<String> createSupplier({
    required String name,
    String? website,
    String? email,
    String? phone,
    String? notes,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const PartPouchException('Supplier name cannot be empty.');
    }

    final id = _uuid.v4();
    final now = DateTime.now();

    await _db
        .into(_db.suppliers)
        .insert(
          SuppliersCompanion.insert(
            id: id,
            name: trimmedName,
            website: Value(website?.trim()),
            email: Value(email?.trim()),
            phone: Value(phone?.trim()),
            notes: Value(notes?.trim()),
            createdAt: now,
          ),
        );

    return id;
  }

  Future<void> updateSupplier({
    required String id,
    required String name,
    String? website,
    String? email,
    String? phone,
    String? notes,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const PartPouchException('Supplier name cannot be empty.');
    }

    await (_db.update(_db.suppliers)..where((tbl) => tbl.id.equals(id))).write(
      SuppliersCompanion(
        name: Value(trimmedName),
        website: Value(website?.trim()),
        email: Value(email?.trim()),
        phone: Value(phone?.trim()),
        notes: Value(notes?.trim()),
      ),
    );
  }

  Future<void> archiveSupplier(String id) async {
    await (_db.update(_db.suppliers)..where((tbl) => tbl.id.equals(id))).write(
      SuppliersCompanion(archivedAt: Value(DateTime.now())),
    );
  }
}
