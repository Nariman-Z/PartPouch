import 'dart:convert';
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

  /// Removes a supplier safely. If purchase orders are linked, archives to preserve history;
  /// otherwise clears component defaultSupplierId references and removes the record.
  Future<void> deleteSupplier(String id) async {
    final poCount = await (_db.select(_db.purchaseOrders)
          ..where((tbl) => tbl.supplierId.equals(id)))
        .get();

    if (poCount.isNotEmpty) {
      await archiveSupplier(id);
      return;
    }

    await (_db.update(_db.components)
          ..where((tbl) => tbl.defaultSupplierId.equals(id)))
        .write(const ComponentsCompanion(defaultSupplierId: Value(null)));

    await (_db.delete(_db.suppliers)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Default demo electronics distributors and shops
  static const List<Map<String, String?>> defaultDemoVendors = [
    {
      'name': 'Mouser Electronics',
      'website': 'https://www.mouser.com',
      'email': 'sales@mouser.com',
      'phone': '+1 800 346 6873',
      'notes': 'Preferred distributor for ICs and passives',
    },
    {
      'name': 'Digi-Key',
      'website': 'https://www.digikey.com',
      'email': 'sales@digikey.com',
      'phone': '+1 800 344 4539',
      'notes': 'Fast overnight delivery',
    },
    {
      'name': 'LCSC Electronics',
      'website': 'https://www.lcsc.com',
      'email': 'service@lcsc.com',
      'phone': '+86 400 830 2050',
      'notes': 'High-volume SMD passives and JLCPCB sourcing',
    },
    {
      'name': 'Octopart',
      'website': 'https://octopart.com/',
      'notes':
          'Electronic component search engine, distributor inventory & pricing aggregator',
    },
    {
      'name': 'Zagros Electronics',
      'website': 'https://www.zagroselec.ir/',
      'phone': '+98 21 6675 4321',
      'notes':
          'Electronic components, semiconductors, ICs, and prototyping modules',
    },
    {
      'name': 'Javan Electronic',
      'website': 'https://www.javanelec.com/',
      'phone': '+98 21 6672 0000',
      'notes':
          'Industrial electronics parts, SMD components, connectors, and passives',
    },
    {
      'name': 'Cafe Robot',
      'website': 'https://thecaferobot.com/',
      'phone': '+98 21 7724 0000',
      'notes':
          'Robotics, development boards, IoT sensors, and maker electronics',
    },
    {
      'name': 'Volta Tech',
      'website': 'https://voltatech.ir/',
      'phone': '+98 21 8890 0000',
      'notes':
          'Electronics lab tools, test equipment, power supplies, and engineering supplies',
    },
  ];

  /// Inserts default demo shops, skipping any that already exist
  Future<int> seedDefaultSuppliers() async {
    final existing = await (_db.select(_db.suppliers)
          ..where((tbl) => tbl.archivedAt.isNull()))
        .get();

    final existingNames = {
      for (final s in existing) s.name.trim().toLowerCase(),
    };
    final existingWebsites = {
      for (final s in existing)
        if (s.website != null && s.website!.trim().isNotEmpty)
          s.website!.trim().toLowerCase(),
    };

    int addedCount = 0;
    final now = DateTime.now();

    for (final vendor in defaultDemoVendors) {
      final name = vendor['name']?.trim() ?? '';
      final website = vendor['website']?.trim();
      final lowerName = name.toLowerCase();
      final lowerWeb = website?.toLowerCase();

      if (existingNames.contains(lowerName) ||
          (lowerWeb != null &&
              lowerWeb.isNotEmpty &&
              existingWebsites.contains(lowerWeb))) {
        continue;
      }

      await _db.into(_db.suppliers).insert(
        SuppliersCompanion.insert(
          id: _uuid.v4(),
          name: name,
          website: Value(website),
          email: Value(vendor['email']),
          phone: Value(vendor['phone']),
          notes: Value(vendor['notes']),
          createdAt: now,
        ),
      );

      existingNames.add(lowerName);
      if (lowerWeb != null && lowerWeb.isNotEmpty) {
        existingWebsites.add(lowerWeb);
      }
      addedCount++;
    }

    return addedCount;
  }

  /// Exports all active suppliers to formatted JSON
  Future<String> exportSuppliersToJson() async {
    final suppliers = await (_db.select(_db.suppliers)
          ..where((tbl) => tbl.archivedAt.isNull())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();

    final data = {
      'app': 'PartPouch',
      'type': 'vendors_list',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'count': suppliers.length,
      'suppliers': suppliers
          .map(
            (s) => {
              'name': s.name,
              'website': s.website,
              'email': s.email,
              'phone': s.phone,
              'notes': s.notes,
            },
          )
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Parses JSON and imports suppliers, skipping duplicates
  Future<int> importSuppliersFromJson(String jsonString) async {
    final dynamic decoded = jsonDecode(jsonString);
    final List<dynamic> list;

    if (decoded is List) {
      list = decoded;
    } else if (decoded is Map<String, dynamic>) {
      if (decoded['suppliers'] is List) {
        list = decoded['suppliers'] as List;
      } else if (decoded['vendors'] is List) {
        list = decoded['vendors'] as List;
      } else {
        throw const PartPouchException(
          'Invalid vendors JSON: missing "suppliers" array.',
        );
      }
    } else {
      throw const PartPouchException('Expected a valid JSON object or list.');
    }

    final existing = await (_db.select(_db.suppliers)
          ..where((tbl) => tbl.archivedAt.isNull()))
        .get();

    final existingNames = {
      for (final s in existing) s.name.trim().toLowerCase(),
    };
    final existingWebsites = {
      for (final s in existing)
        if (s.website != null && s.website!.trim().isNotEmpty)
          s.website!.trim().toLowerCase(),
    };

    int addedCount = 0;
    final now = DateTime.now();

    for (final item in list) {
      if (item is! Map) continue;
      final name = item['name']?.toString().trim();
      if (name == null || name.isEmpty) continue;

      final website = item['website']?.toString().trim();
      final email = item['email']?.toString().trim();
      final phone = item['phone']?.toString().trim();
      final notes = item['notes']?.toString().trim();

      final lowerName = name.toLowerCase();
      final lowerWeb = website?.toLowerCase();

      if (existingNames.contains(lowerName) ||
          (lowerWeb != null &&
              lowerWeb.isNotEmpty &&
              existingWebsites.contains(lowerWeb))) {
        continue;
      }

      await _db.into(_db.suppliers).insert(
        SuppliersCompanion.insert(
          id: _uuid.v4(),
          name: name,
          website: Value(website?.isEmpty ?? true ? null : website),
          email: Value(email?.isEmpty ?? true ? null : email),
          phone: Value(phone?.isEmpty ?? true ? null : phone),
          notes: Value(notes?.isEmpty ?? true ? null : notes),
          createdAt: now,
        ),
      );

      existingNames.add(lowerName);
      if (lowerWeb != null && lowerWeb.isNotEmpty) {
        existingWebsites.add(lowerWeb);
      }
      addedCount++;
    }

    return addedCount;
  }
}
