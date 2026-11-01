import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/theme/theme_provider.dart';

final exportImportServiceProvider = Provider<ExportImportService>((ref) {
  return ExportImportService(ref.watch(databaseProvider));
});

class ExportImportService {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  ExportImportService(this._db);

  /// Export complete workshop inventory database to versioned JSON string
  Future<String> exportToJson() async {
    final components = await _db.select(_db.components).get();
    final locations = await _db.select(_db.locations).get();
    final balances = await _db.select(_db.inventoryBalances).get();
    final movements = await _db.select(_db.stockMovements).get();
    final suppliers = await _db.select(_db.suppliers).get();
    final purchaseOrders = await _db.select(_db.purchaseOrders).get();
    final purchaseOrderItems = await _db.select(_db.purchaseOrderItems).get();
    final projects = await _db.select(_db.projects).get();
    final projectBoms = await _db.select(_db.projectBoms).get();
    final stocktakeSessions = await _db.select(_db.stocktakeSessions).get();
    final stocktakeEntries = await _db.select(_db.stocktakeEntries).get();
    final appSettings = await _db.select(_db.appSettings).get();

    final exportData = {
      'app': 'PartPouch',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'components': components
          .map(
            (c) => {
              'id': c.id,
              'name': c.name,
              'category': c.category,
              'manufacturer': c.manufacturer,
              'manufacturerPartNumber': c.manufacturerPartNumber,
              'internalSku': c.internalSku,
              'description': c.description,
              'packageFootprint': c.packageFootprint,
              'datasheetUrl': c.datasheetUrl,
              'tags': c.tags,
              'minStockThreshold': c.minStockThreshold,
              'targetStockQuantity': c.targetStockQuantity,
              'defaultSupplierId': c.defaultSupplierId,
              'unitOfMeasure': c.unitOfMeasure,
              'unitCostCents': c.unitCostCents,
              'createdAt': c.createdAt.toIso8601String(),
              'updatedAt': c.updatedAt.toIso8601String(),
              'archivedAt': c.archivedAt?.toIso8601String(),
            },
          )
          .toList(),
      'locations': locations
          .map(
            (l) => {
              'id': l.id,
              'name': l.name,
              'parentId': l.parentId,
              'code': l.code,
              'description': l.description,
              'createdAt': l.createdAt.toIso8601String(),
              'updatedAt': l.updatedAt.toIso8601String(),
              'archivedAt': l.archivedAt?.toIso8601String(),
            },
          )
          .toList(),
      'inventoryBalances': balances
          .map(
            (b) => {
              'id': b.id,
              'componentId': b.componentId,
              'locationId': b.locationId,
              'quantity': b.quantity,
            },
          )
          .toList(),
      'stockMovements': movements
          .map(
            (m) => {
              'id': m.id,
              'componentId': m.componentId,
              'movementType': m.movementType,
              'quantityDelta': m.quantityDelta,
              'sourceLocationId': m.sourceLocationId,
              'destinationLocationId': m.destinationLocationId,
              'unitCostCents': m.unitCostCents,
              'projectId': m.projectId,
              'supplierId': m.supplierId,
              'purchaseOrderId': m.purchaseOrderId,
              'notes': m.notes,
              'createdAt': m.createdAt.toIso8601String(),
            },
          )
          .toList(),
      'suppliers': suppliers
          .map(
            (s) => {
              'id': s.id,
              'name': s.name,
              'website': s.website,
              'email': s.email,
              'phone': s.phone,
              'notes': s.notes,
              'createdAt': s.createdAt.toIso8601String(),
              'archivedAt': s.archivedAt?.toIso8601String(),
            },
          )
          .toList(),
      'purchaseOrders': purchaseOrders
          .map(
            (po) => {
              'id': po.id,
              'orderNumber': po.orderNumber,
              'supplierId': po.supplierId,
              'orderDate': po.orderDate.toIso8601String(),
              'expectedArrivalDate': po.expectedArrivalDate?.toIso8601String(),
              'status': po.status,
              'currency': po.currency,
              'notes': po.notes,
              'createdAt': po.createdAt.toIso8601String(),
              'updatedAt': po.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'purchaseOrderItems': purchaseOrderItems
          .map(
            (poi) => {
              'id': poi.id,
              'purchaseOrderId': poi.purchaseOrderId,
              'componentId': poi.componentId,
              'orderedQuantity': poi.orderedQuantity,
              'receivedQuantity': poi.receivedQuantity,
              'unitCostCents': poi.unitCostCents,
              'supplierPartNumber': poi.supplierPartNumber,
            },
          )
          .toList(),
      'projects': projects
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'description': p.description,
              'status': p.status,
              'targetDate': p.targetDate?.toIso8601String(),
              'createdAt': p.createdAt.toIso8601String(),
              'updatedAt': p.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'projectBoms': projectBoms
          .map(
            (pb) => {
              'id': pb.id,
              'projectId': pb.projectId,
              'componentId': pb.componentId,
              'quantityRequired': pb.quantityRequired,
              'notes': pb.notes,
            },
          )
          .toList(),
      'stocktakeSessions': stocktakeSessions
          .map(
            (ss) => {
              'id': ss.id,
              'locationId': ss.locationId,
              'status': ss.status,
              'startedAt': ss.startedAt.toIso8601String(),
              'completedAt': ss.completedAt?.toIso8601String(),
              'notes': ss.notes,
            },
          )
          .toList(),
      'stocktakeEntries': stocktakeEntries
          .map(
            (se) => {
              'id': se.id,
              'sessionId': se.sessionId,
              'componentId': se.componentId,
              'expectedQuantity': se.expectedQuantity,
              'countedQuantity': se.countedQuantity,
              'reconciled': se.reconciled,
            },
          )
          .toList(),
      'appSettings': appSettings
          .map(
            (s) => {
              'key': s.key,
              'value': s.value,
            },
          )
          .toList(),
      'preferences': {
        'language': ThemeProvider().currentLanguage,
        'currency': ThemeProvider().currency,
        'usdToTomanRate': ThemeProvider().usdToTomanRate,
        'themeMode': ThemeProvider().themeMode.name,
        'activeColor': ThemeProvider().activeColor.toARGB32(),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  /// Atomically validate and restore inventory from JSON backup
  Future<void> importFromJson(String jsonString) async {
    final Map<String, dynamic> data;
    try {
      data = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw const PartPouchException('Invalid backup file: Not valid JSON.');
    }

    if (data['app'] != 'PartPouch' || data['version'] == null) {
      throw const PartPouchException(
        'Unrecognized backup format. Must be a valid PartPouch backup file.',
      );
    }

    await _db.transaction(() async {
      // Clear existing records in reverse dependency order
      await _db.delete(_db.appSettings).go();
      await _db.delete(_db.stocktakeEntries).go();
      await _db.delete(_db.stocktakeSessions).go();
      await _db.delete(_db.projectBoms).go();
      await _db.delete(_db.projects).go();
      await _db.delete(_db.purchaseOrderItems).go();
      await _db.delete(_db.purchaseOrders).go();
      await _db.delete(_db.stockMovements).go();
      await _db.delete(_db.inventoryBalances).go();
      await _db.delete(_db.suppliers).go();
      await _db.delete(_db.locations).go();
      await _db.delete(_db.components).go();

      // Restore components
      final rawComponents = (data['components'] as List?) ?? [];
      for (final raw in rawComponents) {
        final c = raw as Map<String, dynamic>;
        await _db
            .into(_db.components)
            .insert(
              ComponentsCompanion.insert(
                id: c['id'] as String,
                name: c['name'] as String,
                category: c['category'] as String,
                manufacturer: Value(c['manufacturer'] as String?),
                manufacturerPartNumber: Value(
                  c['manufacturerPartNumber'] as String?,
                ),
                internalSku: Value(c['internalSku'] as String?),
                description: Value(c['description'] as String?),
                packageFootprint: Value(c['packageFootprint'] as String?),
                datasheetUrl: Value(c['datasheetUrl'] as String?),
                tags: Value(c['tags'] as String?),
                minStockThreshold: Value(c['minStockThreshold'] as int? ?? 0),
                targetStockQuantity: Value(c['targetStockQuantity'] as int?),
                defaultSupplierId: Value(c['defaultSupplierId'] as String?),
                unitOfMeasure: Value(c['unitOfMeasure'] as String? ?? 'pcs'),
                unitCostCents: Value(c['unitCostCents'] as int?),
                createdAt: DateTime.parse(c['createdAt'] as String),
                updatedAt: DateTime.parse(c['updatedAt'] as String),
                archivedAt: Value(
                  c['archivedAt'] != null
                      ? DateTime.parse(c['archivedAt'] as String)
                      : null,
                ),
              ),
            );
      }

      // Restore locations
      final rawLocations = (data['locations'] as List?) ?? [];
      for (final raw in rawLocations) {
        final l = raw as Map<String, dynamic>;
        await _db
            .into(_db.locations)
            .insert(
              LocationsCompanion.insert(
                id: l['id'] as String,
                name: l['name'] as String,
                parentId: Value(l['parentId'] as String?),
                code: Value(l['code'] as String?),
                description: Value(l['description'] as String?),
                createdAt: DateTime.parse(l['createdAt'] as String),
                updatedAt: DateTime.parse(l['updatedAt'] as String),
                archivedAt: Value(
                  l['archivedAt'] != null
                      ? DateTime.parse(l['archivedAt'] as String)
                      : null,
                ),
              ),
            );
      }

      // Restore suppliers
      final rawSuppliers = (data['suppliers'] as List?) ?? [];
      for (final raw in rawSuppliers) {
        final s = raw as Map<String, dynamic>;
        await _db
            .into(_db.suppliers)
            .insert(
              SuppliersCompanion.insert(
                id: s['id'] as String,
                name: s['name'] as String,
                website: Value(s['website'] as String?),
                email: Value(s['email'] as String?),
                phone: Value(s['phone'] as String?),
                notes: Value(s['notes'] as String?),
                createdAt: DateTime.parse(s['createdAt'] as String),
                archivedAt: Value(
                  s['archivedAt'] != null
                      ? DateTime.parse(s['archivedAt'] as String)
                      : null,
                ),
              ),
            );
      }

      // Restore inventoryBalances
      final rawBalances = (data['inventoryBalances'] as List?) ?? [];
      for (final raw in rawBalances) {
        final b = raw as Map<String, dynamic>;
        await _db
            .into(_db.inventoryBalances)
            .insert(
              InventoryBalancesCompanion.insert(
                id: b['id'] as String,
                componentId: b['componentId'] as String,
                locationId: b['locationId'] as String,
                quantity: Value(b['quantity'] as int),
              ),
            );
      }

      // Restore purchaseOrders
      final rawPOs = (data['purchaseOrders'] as List?) ?? [];
      for (final raw in rawPOs) {
        final po = raw as Map<String, dynamic>;
        await _db
            .into(_db.purchaseOrders)
            .insert(
              PurchaseOrdersCompanion.insert(
                id: po['id'] as String,
                orderNumber: (po['orderNumber'] ??
                        po['poNumber'] ??
                        'PO-${DateTime.now().millisecondsSinceEpoch}')
                    as String,
                supplierId: Value(po['supplierId'] as String?),
                orderDate: DateTime.parse(po['orderDate'] as String),
                expectedArrivalDate: Value(
                  po['expectedArrivalDate'] != null
                      ? DateTime.parse(po['expectedArrivalDate'] as String)
                      : null,
                ),
                status: po['status'] as String,
                currency: Value(po['currency'] as String? ?? 'USD'),
                notes: Value(po['notes'] as String?),
                createdAt: DateTime.parse(po['createdAt'] as String),
                updatedAt: DateTime.parse(po['updatedAt'] as String),
              ),
            );
      }

      // Restore purchaseOrderItems
      final rawPOItems = (data['purchaseOrderItems'] as List?) ?? [];
      for (final raw in rawPOItems) {
        final poi = raw as Map<String, dynamic>;
        await _db
            .into(_db.purchaseOrderItems)
            .insert(
              PurchaseOrderItemsCompanion.insert(
                id: poi['id'] as String,
                purchaseOrderId: poi['purchaseOrderId'] as String,
                componentId: poi['componentId'] as String,
                orderedQuantity: poi['orderedQuantity'] as int,
                receivedQuantity: Value(poi['receivedQuantity'] as int? ?? 0),
                unitCostCents: Value(poi['unitCostCents'] as int? ?? 0),
                supplierPartNumber: Value(poi['supplierPartNumber'] as String?),
              ),
            );
      }

      // Restore projects
      final rawProjects = (data['projects'] as List?) ?? [];
      for (final raw in rawProjects) {
        final p = raw as Map<String, dynamic>;
        await _db
            .into(_db.projects)
            .insert(
              ProjectsCompanion.insert(
                id: p['id'] as String,
                name: p['name'] as String,
                description: Value(p['description'] as String?),
                status: Value(p['status'] as String? ?? 'inProgress'),
                targetDate: Value(
                  p['targetDate'] != null
                      ? DateTime.parse(p['targetDate'] as String)
                      : null,
                ),
                createdAt: DateTime.parse(p['createdAt'] as String),
                updatedAt: DateTime.parse(p['updatedAt'] as String),
              ),
            );
      }

      // Restore projectBoms
      final rawBoms = (data['projectBoms'] as List?) ?? [];
      for (final raw in rawBoms) {
        final pb = raw as Map<String, dynamic>;
        await _db
            .into(_db.projectBoms)
            .insert(
              ProjectBomsCompanion.insert(
                id: pb['id'] as String,
                projectId: pb['projectId'] as String,
                componentId: pb['componentId'] as String,
                quantityRequired: pb['quantityRequired'] as int,
                notes: Value(pb['notes'] as String?),
              ),
            );
      }

      // Restore stockMovements
      final rawMovements = (data['stockMovements'] as List?) ?? [];
      for (final raw in rawMovements) {
        final m = raw as Map<String, dynamic>;
        await _db
            .into(_db.stockMovements)
            .insert(
              StockMovementsCompanion.insert(
                id: m['id'] as String,
                componentId: m['componentId'] as String,
                movementType: m['movementType'] as String,
                quantityDelta: m['quantityDelta'] as int,
                sourceLocationId: Value(m['sourceLocationId'] as String?),
                destinationLocationId: Value(
                  m['destinationLocationId'] as String?,
                ),
                unitCostCents: Value(m['unitCostCents'] as int?),
                projectId: Value(m['projectId'] as String?),
                supplierId: Value(m['supplierId'] as String?),
                purchaseOrderId: Value(m['purchaseOrderId'] as String?),
                notes: Value(m['notes'] as String?),
                createdAt: DateTime.parse(m['createdAt'] as String),
              ),
            );
      }

      // Restore stocktakeSessions
      final rawSessions = (data['stocktakeSessions'] as List?) ?? [];
      for (final raw in rawSessions) {
        final ss = raw as Map<String, dynamic>;
        await _db
            .into(_db.stocktakeSessions)
            .insert(
              StocktakeSessionsCompanion.insert(
                id: ss['id'] as String,
                locationId: Value(ss['locationId'] as String?),
                status: ss['status'] as String? ?? 'inProgress',
                startedAt: DateTime.parse(ss['startedAt'] as String),
                completedAt: Value(
                  ss['completedAt'] != null
                      ? DateTime.parse(ss['completedAt'] as String)
                      : null,
                ),
                notes: Value(ss['notes'] as String?),
              ),
            );
      }

      // Restore stocktakeEntries
      final rawEntries = (data['stocktakeEntries'] as List?) ?? [];
      for (final raw in rawEntries) {
        final se = raw as Map<String, dynamic>;
        await _db
            .into(_db.stocktakeEntries)
            .insert(
              StocktakeEntriesCompanion.insert(
                id: se['id'] as String,
                sessionId: se['sessionId'] as String,
                componentId: se['componentId'] as String,
                expectedQuantity: se['expectedQuantity'] as int? ?? 0,
                countedQuantity: se['countedQuantity'] as int? ?? 0,
                reconciled: Value(se['reconciled'] as bool? ?? false),
              ),
            );
      }

      // Restore appSettings
      final rawSettings = (data['appSettings'] as List?) ?? [];
      for (final raw in rawSettings) {
        final s = raw as Map<String, dynamic>;
        await _db
            .into(_db.appSettings)
            .insert(
              AppSettingsCompanion.insert(
                key: s['key'] as String,
                value: s['value'] as String,
              ),
            );
      }
    });

    // Restore user preferences if present
    if (data['preferences'] != null &&
        data['preferences'] is Map<String, dynamic>) {
      final prefs = data['preferences'] as Map<String, dynamic>;
      final tp = ThemeProvider();
      if (prefs['language'] != null &&
          (prefs['language'] == 'English' || prefs['language'] == 'Persian')) {
        await tp.setLanguage(prefs['language'] as String);
      }
      if (prefs['currency'] != null &&
          (prefs['currency'] == 'USD' || prefs['currency'] == 'TOMAN')) {
        await tp.setCurrency(prefs['currency'] as String);
      }
      if (prefs['usdToTomanRate'] != null) {
        final rate = (prefs['usdToTomanRate'] as num).toDouble();
        await tp.setUsdToTomanRate(rate);
      }
      if (prefs['themeMode'] != null) {
        final modeStr = prefs['themeMode'] as String;
        final mode = ThemeMode.values.firstWhere(
          (m) => m.name == modeStr,
          orElse: () => ThemeMode.dark,
        );
        await tp.setThemeMode(mode);
      }
      if (prefs['activeColor'] != null) {
        final colorVal = prefs['activeColor'] as int;
        await tp.setActiveColor(Color(colorVal));
      }
    }
  }

  /// Reset all data completely
  Future<void> resetAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.appSettings).go();
      await _db.delete(_db.stocktakeEntries).go();
      await _db.delete(_db.stocktakeSessions).go();
      await _db.delete(_db.projectBoms).go();
      await _db.delete(_db.projects).go();
      await _db.delete(_db.purchaseOrderItems).go();
      await _db.delete(_db.purchaseOrders).go();
      await _db.delete(_db.stockMovements).go();
      await _db.delete(_db.inventoryBalances).go();
      await _db.delete(_db.suppliers).go();
      await _db.delete(_db.locations).go();
      await _db.delete(_db.components).go();
    });
  }

  /// Seed realistic electronics workshop demonstration data matching the screen catalog
  Future<void> seedDemoWorkshopData() async {
    await resetAllData();

    await _db.transaction(() async {
      final now = DateTime.now();

      // 1. Locations
      final locWorkshop = _uuid.v4();
      final locShelfA = _uuid.v4();
      final locShelfB = _uuid.v4();
      final locDrawer01 = _uuid.v4();
      final locDrawer02 = _uuid.v4();
      final locDrawer03 = _uuid.v4();
      final locStorageRoom = _uuid.v4();
      final locBin01 = _uuid.v4();
      final locBin02 = _uuid.v4();

      await _db
          .into(_db.locations)
          .insert(
            LocationsCompanion.insert(
              id: locWorkshop,
              name: 'Workshop',
              code: const Value('WS-MAIN'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.locations)
          .insert(
            LocationsCompanion.insert(
              id: locShelfA,
              name: 'Shelf A',
              parentId: Value(locWorkshop),
              code: const Value('SH-A'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.locations)
          .insert(
            LocationsCompanion.insert(
              id: locShelfB,
              name: 'Shelf B',
              parentId: Value(locWorkshop),
              code: const Value('SH-B'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.locations)
          .insert(
            LocationsCompanion.insert(
              id: locDrawer01,
              name: 'Drawer 01',
              parentId: Value(locShelfA),
              code: const Value('LOC-001-01'),
              description: const Value('Precision ICs & MCUs'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.locations)
          .insert(
            LocationsCompanion.insert(
              id: locDrawer02,
              name: 'Drawer 02',
              parentId: Value(locShelfA),
              code: const Value('LOC-001-02'),
              description: const Value('Passives & Diodes'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.locations)
          .insert(
            LocationsCompanion.insert(
              id: locDrawer03,
              name: 'Drawer 03',
              parentId: Value(locShelfA),
              code: const Value('LOC-001-03'),
              description: const Value('Sensors & Displays'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.locations)
          .insert(
            LocationsCompanion.insert(
              id: locStorageRoom,
              name: 'Storage Room',
              code: const Value('STOR-01'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.locations)
          .insert(
            LocationsCompanion.insert(
              id: locBin01,
              name: 'Bin 01',
              parentId: Value(locStorageRoom),
              code: const Value('BIN-01'),
              description: const Value('Bulk Cables & Headers'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.locations)
          .insert(
            LocationsCompanion.insert(
              id: locBin02,
              name: 'Bin 02',
              parentId: Value(locStorageRoom),
              code: const Value('BIN-02'),
              description: const Value('Transformers & Modules'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      // 2. Suppliers
      final supMouser = _uuid.v4();
      final supDigikey = _uuid.v4();
      final supLcsc = _uuid.v4();

      await _db
          .into(_db.suppliers)
          .insert(
            SuppliersCompanion.insert(
              id: supMouser,
              name: 'Mouser Electronics',
              email: const Value('sales@mouser.com'),
              website: const Value('https://www.mouser.com'),
              phone: const Value('+1 800 346 6873'),
              notes: const Value('Preferred distributor for ICs and passives'),
              createdAt: now,
            ),
          );
      await _db
          .into(_db.suppliers)
          .insert(
            SuppliersCompanion.insert(
              id: supDigikey,
              name: 'Digi-Key',
              email: const Value('sales@digikey.com'),
              website: const Value('https://www.digikey.com'),
              phone: const Value('+1 800 344 4539'),
              notes: const Value('Fast overnight delivery'),
              createdAt: now,
            ),
          );
      await _db
          .into(_db.suppliers)
          .insert(
            SuppliersCompanion.insert(
              id: supLcsc,
              name: 'LCSC Electronics',
              email: const Value('service@lcsc.com'),
              website: const Value('https://www.lcsc.com'),
              phone: const Value('+86 400 830 2050'),
              notes: const Value(
                'High-volume SMD passives and JLCPCB sourcing',
              ),
              createdAt: now,
            ),
          );

      // 3. Components
      final cEsp32 = _uuid.v4();
      final cRes10k = _uuid.v4();
      final cCap100u = _uuid.v4();
      final cDiode = _uuid.v4();
      final cDht22 = _uuid.v4();
      final cLed5mm = _uuid.v4();

      await _db
          .into(_db.components)
          .insert(
            ComponentsCompanion.insert(
              id: cEsp32,
              name: 'ESP32-C3 Dev Board',
              category: 'Microcontroller',
              manufacturer: const Value('Espressif'),
              manufacturerPartNumber: const Value('ESP32-C3-WROOM-02'),
              internalSku: const Value('ESP32-001'),
              packageFootprint: const Value('Module 18x20mm'),
              description: const Value(
                'RISC-V single-core microcontroller with 2.4 GHz Wi-Fi and Bluetooth 5',
              ),
              minStockThreshold: const Value(5),
              targetStockQuantity: const Value(20),
              defaultSupplierId: Value(supMouser),
              unitCostCents: const Value(420),
              createdAt: now.subtract(const Duration(days: 30)),
              updatedAt: now,
            ),
          );

      await _db
          .into(_db.components)
          .insert(
            ComponentsCompanion.insert(
              id: cRes10k,
              name: '10kΩ Resistor 1%',
              category: 'Resistors',
              manufacturer: const Value('Yageo'),
              manufacturerPartNumber: const Value('RC0805FR-0710KL'),
              internalSku: const Value('RES-10K-0805'),
              packageFootprint: const Value('0805 SMD'),
              description: const Value(
                'Thick film chip resistor, 10 kOhms, 125 mW, 1% tolerance',
              ),
              minStockThreshold: const Value(50),
              targetStockQuantity: const Value(500),
              defaultSupplierId: Value(supLcsc),
              unitCostCents: const Value(2),
              createdAt: now.subtract(const Duration(days: 45)),
              updatedAt: now,
            ),
          );

      await _db
          .into(_db.components)
          .insert(
            ComponentsCompanion.insert(
              id: cCap100u,
              name: '100µF Capacitor 25V',
              category: 'Capacitors',
              manufacturer: const Value('Nichicon'),
              manufacturerPartNumber: const Value('UVR1E101MDD'),
              internalSku: const Value('CAP-100U-25V'),
              packageFootprint: const Value('Radial 6.3x11mm'),
              description: const Value(
                'Aluminum electrolytic capacitor 100uF 25V 20% tolerance',
              ),
              minStockThreshold: const Value(20),
              targetStockQuantity: const Value(100),
              defaultSupplierId: Value(supDigikey),
              unitCostCents: const Value(15),
              createdAt: now.subtract(const Duration(days: 20)),
              updatedAt: now,
            ),
          );

      await _db
          .into(_db.components)
          .insert(
            ComponentsCompanion.insert(
              id: cDiode,
              name: '1N4148 Diode',
              category: 'Diodes',
              manufacturer: const Value('Diodes Inc.'),
              manufacturerPartNumber: const Value('1N4148WS-7-F'),
              internalSku: const Value('DIO-1N4148'),
              packageFootprint: const Value('SOD-323'),
              description: const Value('High-speed switching diode 75V 150mA'),
              minStockThreshold: const Value(20),
              targetStockQuantity: const Value(100),
              defaultSupplierId: Value(supLcsc),
              unitCostCents: const Value(5),
              createdAt: now.subtract(const Duration(days: 15)),
              updatedAt: now,
            ),
          );

      await _db
          .into(_db.components)
          .insert(
            ComponentsCompanion.insert(
              id: cDht22,
              name: 'DHT22 Sensor Module',
              category: 'Sensors',
              manufacturer: const Value('Aosong'),
              manufacturerPartNumber: const Value('AM2302'),
              internalSku: const Value('SENS-DHT22'),
              packageFootprint: const Value('Module 4-pin'),
              description: const Value(
                'Digital temperature and humidity sensor module with calibrated output',
              ),
              minStockThreshold: const Value(2),
              targetStockQuantity: const Value(10),
              defaultSupplierId: Value(supMouser),
              unitCostCents: const Value(350),
              createdAt: now.subtract(const Duration(days: 25)),
              updatedAt: now,
            ),
          );

      await _db
          .into(_db.components)
          .insert(
            ComponentsCompanion.insert(
              id: cLed5mm,
              name: 'LED 5mm Red',
              category: 'Optoelectronics',
              manufacturer: const Value('Kingbright'),
              manufacturerPartNumber: const Value('WP7113ID'),
              internalSku: const Value('OPT-LED5-RED'),
              packageFootprint: const Value('T-1 3/4 (5mm)'),
              description: const Value(
                'High efficiency red diffused through-hole LED',
              ),
              minStockThreshold: const Value(15),
              targetStockQuantity: const Value(50),
              defaultSupplierId: Value(supLcsc),
              unitCostCents: const Value(8),
              createdAt: now.subtract(const Duration(days: 10)),
              updatedAt: now,
            ),
          );

      // 4. Balances
      await _db
          .into(_db.inventoryBalances)
          .insert(
            InventoryBalancesCompanion.insert(
              id: _uuid.v4(),
              componentId: cEsp32,
              locationId: locDrawer01,
              quantity: const Value(12),
            ),
          );
      await _db
          .into(_db.inventoryBalances)
          .insert(
            InventoryBalancesCompanion.insert(
              id: _uuid.v4(),
              componentId: cRes10k,
              locationId: locDrawer02,
              quantity: const Value(520),
            ),
          );
      await _db
          .into(_db.inventoryBalances)
          .insert(
            InventoryBalancesCompanion.insert(
              id: _uuid.v4(),
              componentId: cCap100u,
              locationId: locDrawer02,
              quantity: const Value(18),
            ), // Low stock
          );
      await _db
          .into(_db.inventoryBalances)
          .insert(
            InventoryBalancesCompanion.insert(
              id: _uuid.v4(),
              componentId: cDiode,
              locationId: locDrawer02,
              quantity: const Value(0),
            ), // Out of stock
          );
      await _db
          .into(_db.inventoryBalances)
          .insert(
            InventoryBalancesCompanion.insert(
              id: _uuid.v4(),
              componentId: cDht22,
              locationId: locDrawer03,
              quantity: const Value(4),
            ),
          );
      await _db
          .into(_db.inventoryBalances)
          .insert(
            InventoryBalancesCompanion.insert(
              id: _uuid.v4(),
              componentId: cLed5mm,
              locationId: locDrawer02,
              quantity: const Value(35),
            ),
          );

      // 5. Stock Movements
      await _db
          .into(_db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: _uuid.v4(),
              componentId: cRes10k,
              movementType: 'received',
              quantityDelta: 500,
              destinationLocationId: Value(locDrawer02),
              unitCostCents: const Value(2),
              supplierId: Value(supLcsc),
              notes: const Value('Restock tape of 500 pcs'),
              createdAt: now.subtract(const Duration(hours: 3)),
            ),
          );
      await _db
          .into(_db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: _uuid.v4(),
              componentId: cEsp32,
              movementType: 'issued',
              quantityDelta: -1,
              sourceLocationId: Value(locDrawer01),
              unitCostCents: const Value(420),
              notes: const Value('Used for prototyping IoT gateway'),
              createdAt: now.subtract(const Duration(hours: 4)),
            ),
          );
      await _db
          .into(_db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: _uuid.v4(),
              componentId: cCap100u,
              movementType: 'transfer',
              quantityDelta: 6,
              sourceLocationId: Value(locBin02),
              destinationLocationId: Value(locDrawer02),
              notes: const Value('Transferred from bulk bin to bench drawer'),
              createdAt: now.subtract(const Duration(hours: 6)),
            ),
          );

      // 6. Projects & BOM
      final pSensor = _uuid.v4();
      final pMatrix = _uuid.v4();
      final pWeather = _uuid.v4();

      await _db
          .into(_db.projects)
          .insert(
            ProjectsCompanion.insert(
              id: pSensor,
              name: 'Smart Sensor Node',
              description: const Value(
                'Low power environmental sensor node with Wi-Fi telemetry',
              ),
              status: const Value('inProgress'),
              targetDate: Value(now.add(const Duration(days: 14))),
              createdAt: now.subtract(const Duration(days: 12)),
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.projects)
          .insert(
            ProjectsCompanion.insert(
              id: pMatrix,
              name: 'LED Matrix Clock',
              description: const Value(
                'Retro desktop matrix display with NTP sync',
              ),
              status: const Value('planning'),
              targetDate: Value(now.add(const Duration(days: 30))),
              createdAt: now.subtract(const Duration(days: 5)),
              updatedAt: now,
            ),
          );
      await _db
          .into(_db.projects)
          .insert(
            ProjectsCompanion.insert(
              id: pWeather,
              name: 'Weather Station',
              description: const Value(
                'Outdoor solar powered solar-radiation station',
              ),
              status: const Value('completed'),
              targetDate: Value(now.subtract(const Duration(days: 2))),
              createdAt: now.subtract(const Duration(days: 40)),
              updatedAt: now,
            ),
          );

      // BOM for Smart Sensor Node
      await _db
          .into(_db.projectBoms)
          .insert(
            ProjectBomsCompanion.insert(
              id: _uuid.v4(),
              projectId: pSensor,
              componentId: cEsp32,
              quantityRequired: 1,
            ),
          );
      await _db
          .into(_db.projectBoms)
          .insert(
            ProjectBomsCompanion.insert(
              id: _uuid.v4(),
              projectId: pSensor,
              componentId: cDht22,
              quantityRequired: 1,
            ),
          );
      await _db
          .into(_db.projectBoms)
          .insert(
            ProjectBomsCompanion.insert(
              id: _uuid.v4(),
              projectId: pSensor,
              componentId: cRes10k,
              quantityRequired: 4,
            ),
          );
      await _db
          .into(_db.projectBoms)
          .insert(
            ProjectBomsCompanion.insert(
              id: _uuid.v4(),
              projectId: pSensor,
              componentId: cCap100u,
              quantityRequired: 2,
            ),
          );

      // 7. Purchase Order
      final poId = _uuid.v4();
      await _db
          .into(_db.purchaseOrders)
          .insert(
            PurchaseOrdersCompanion.insert(
              id: poId,
              orderNumber: 'PO-2026-001',
              supplierId: Value(supMouser),
              orderDate: now.subtract(const Duration(days: 3)),
              expectedArrivalDate: Value(now.add(const Duration(days: 4))),
              status: 'ordered',
              notes: const Value('Quarterly workshop restock'),
              createdAt: now.subtract(const Duration(days: 3)),
              updatedAt: now.subtract(const Duration(days: 3)),
            ),
          );

      await _db
          .into(_db.purchaseOrderItems)
          .insert(
            PurchaseOrderItemsCompanion.insert(
              id: _uuid.v4(),
              purchaseOrderId: poId,
              componentId: cEsp32,
              orderedQuantity: 10,
              receivedQuantity: const Value(0),
              unitCostCents: const Value(400),
            ),
          );
      await _db
          .into(_db.purchaseOrderItems)
          .insert(
            PurchaseOrderItemsCompanion.insert(
              id: _uuid.v4(),
              purchaseOrderId: poId,
              componentId: cDiode,
              orderedQuantity: 100,
              receivedQuantity: const Value(0),
              unitCostCents: const Value(4),
            ),
          );
    });
  }
}
