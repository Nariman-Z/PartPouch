import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partpouch/core/database/database.dart';
import 'package:partpouch/core/errors/exceptions.dart';
import 'package:partpouch/features/inventory/data/inventory_repository.dart';
import 'package:partpouch/features/locations/data/locations_repository.dart';
import 'package:partpouch/features/projects/data/projects_repository.dart';
import 'package:partpouch/features/purchasing/data/purchasing_repository.dart';
import 'package:partpouch/features/settings/data/export_import_service.dart';
import 'package:partpouch/features/stock_movements/data/stock_movements_repository.dart';
import 'package:partpouch/features/stocktake/data/stocktake_repository.dart';
import 'package:partpouch/features/suppliers/data/suppliers_repository.dart';

void main() {
  late AppDatabase db;
  late InventoryRepository inventoryRepo;
  late LocationsRepository locationsRepo;
  late StockMovementsRepository movementsRepo;
  late SuppliersRepository suppliersRepo;
  late PurchasingRepository purchasingRepo;
  late ProjectsRepository projectsRepo;
  late StocktakeRepository stocktakeRepo;
  late ExportImportService exportImportService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    inventoryRepo = InventoryRepository(db);
    locationsRepo = LocationsRepository(db);
    movementsRepo = StockMovementsRepository(db);
    suppliersRepo = SuppliersRepository(db);
    purchasingRepo = PurchasingRepository(db);
    projectsRepo = ProjectsRepository(db);
    stocktakeRepo = StocktakeRepository(db);
    exportImportService = ExportImportService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Inventory & Stock Ledger Invariants', () {
    test(
      'Creating a component with initial stock creates balance and initialStock movement',
      () async {
        final locId = await locationsRepo.createLocation(
          name: 'Drawer 01',
          code: 'D-01',
        );

        final compId = await inventoryRepo.createComponent(
          name: 'ESP32-S3',
          category: 'Microcontroller',
          internalSku: 'ESP32-S3-001',
          initialStock: 15,
          initialLocationId: locId,
          unitCostCents: 500, // $5.00
        );

        final totalStock = await inventoryRepo
            .watchComponentTotalStock(compId)
            .first;
        expect(totalStock, equals(15));

        final movements = await movementsRepo
            .watchMovementsForComponent(compId)
            .first;
        expect(movements.length, equals(1));
        expect(movements.first.movementType, equals('initialStock'));
        expect(movements.first.quantityDelta, equals(15));
        expect(movements.first.destinationLocationId, equals(locId));
        expect(movements.first.unitCostCents, equals(500));
      },
    );

    test(
      'Receiving stock updates balance, movement ledger, and moving-average cost',
      () async {
        final locId = await locationsRepo.createLocation(name: 'Shelf B');
        final compId = await inventoryRepo.createComponent(
          name: '100uF Cap',
          category: 'Capacitor',
          initialStock: 10,
          initialLocationId: locId,
          unitCostCents: 100, // $1.00
        );

        // Receive 10 more at $2.00 (200 cents). Moving average should become: (10*100 + 10*200) / 20 = 150 cents ($1.50)
        await movementsRepo.receiveStock(
          componentId: compId,
          destinationLocationId: locId,
          quantity: 10,
          unitCostCents: 200,
        );

        final comp = await inventoryRepo.getComponentById(compId);
        expect(comp?.unitCostCents, equals(150));

        final totalStock = await inventoryRepo
            .watchComponentTotalStock(compId)
            .first;
        expect(totalStock, equals(20));

        final movements = await movementsRepo
            .watchMovementsForComponent(compId)
            .first;
        expect(movements.length, equals(2));
        expect(movements.first.movementType, equals('received'));
        expect(movements.first.quantityDelta, equals(10));
      },
    );

    test(
      'Issuing stock deducts balance and records negative movement delta',
      () async {
        final locId = await locationsRepo.createLocation(name: 'Bench Bin');
        final compId = await inventoryRepo.createComponent(
          name: '10k Resistor',
          category: 'Resistor',
          initialStock: 50,
          initialLocationId: locId,
        );

        await movementsRepo.issueStock(
          componentId: compId,
          sourceLocationId: locId,
          quantity: 20,
          notes: 'Built 5 prototypes',
        );

        final totalStock = await inventoryRepo
            .watchComponentTotalStock(compId)
            .first;
        expect(totalStock, equals(30));

        final movements = await movementsRepo
            .watchMovementsForComponent(compId)
            .first;
        expect(movements.first.movementType, equals('issued'));
        expect(movements.first.quantityDelta, equals(-20));
        expect(movements.first.sourceLocationId, equals(locId));
      },
    );

    test(
      'Issuing more stock than available throws InsufficientStockException without partial write',
      () async {
        final locId = await locationsRepo.createLocation(name: 'Drawer X');
        final compId = await inventoryRepo.createComponent(
          name: 'OLED Display',
          category: 'Display',
          initialStock: 5,
          initialLocationId: locId,
        );

        expect(
          () => movementsRepo.issueStock(
            componentId: compId,
            sourceLocationId: locId,
            quantity: 10,
          ),
          throwsA(isA<InsufficientStockException>()),
        );

        // Verify stock was not deducted
        final totalStock = await inventoryRepo
            .watchComponentTotalStock(compId)
            .first;
        expect(totalStock, equals(5));
      },
    );

    test(
      'Stock transfer between two locations is atomic and preserves total count',
      () async {
        final locSource = await locationsRepo.createLocation(
          name: 'Storage Room',
        );
        final locDest = await locationsRepo.createLocation(
          name: 'Bench Drawer',
        );

        final compId = await inventoryRepo.createComponent(
          name: 'STM32 MCU',
          category: 'Microcontroller',
          initialStock: 30,
          initialLocationId: locSource,
        );

        await movementsRepo.transferStock(
          componentId: compId,
          sourceLocationId: locSource,
          destinationLocationId: locDest,
          quantity: 12,
        );

        final balances = await inventoryRepo
            .watchBalancesForComponent(compId)
            .first;
        final sourceBal = balances.firstWhere(
          (b) => b.location.id == locSource,
        );
        final destBal = balances.firstWhere((b) => b.location.id == locDest);

        expect(sourceBal.quantity, equals(18));
        expect(destBal.quantity, equals(12));

        final totalStock = await inventoryRepo
            .watchComponentTotalStock(compId)
            .first;
        expect(totalStock, equals(30)); // Total preserved!
      },
    );

    test('Stock adjustment records audit discrepancy correctly', () async {
      final locId = await locationsRepo.createLocation(name: 'Bin 5');
      final compId = await inventoryRepo.createComponent(
        name: 'Fuse 500mA',
        category: 'Miscellaneous',
        initialStock: 20,
        initialLocationId: locId,
      );

      // Found 2 broken fuses, adjust to 18
      await movementsRepo.adjustStock(
        componentId: compId,
        locationId: locId,
        newQuantity: 18,
        reason: 'Discarded 2 damaged units',
      );

      final totalStock = await inventoryRepo
          .watchComponentTotalStock(compId)
          .first;
      expect(totalStock, equals(18));

      final movements = await movementsRepo
          .watchMovementsForComponent(compId)
          .first;
      expect(movements.first.movementType, equals('negativeAdjustment'));
      expect(movements.first.quantityDelta, equals(-2));
      expect(movements.first.notes, equals('Discarded 2 damaged units'));
    });
  });

  group('Location Hierarchy Rules', () {
    test('Cannot set a location as its own parent', () async {
      final locId = await locationsRepo.createLocation(name: 'Workshop');

      expect(
        () => locationsRepo.updateLocation(
          id: locId,
          name: 'Workshop',
          parentId: locId,
        ),
        throwsA(isA<InvalidLocationHierarchyException>()),
      );
    });

    test('Cannot move a location into one of its descendants', () async {
      final workshop = await locationsRepo.createLocation(name: 'Workshop');
      final shelf = await locationsRepo.createLocation(
        name: 'Shelf A',
        parentId: workshop,
      );
      final drawer = await locationsRepo.createLocation(
        name: 'Drawer 1',
        parentId: shelf,
      );

      // Attempting to move workshop into drawer (circular hierarchy)
      expect(
        () => locationsRepo.updateLocation(
          id: workshop,
          name: 'Workshop',
          parentId: drawer,
        ),
        throwsA(isA<InvalidLocationHierarchyException>()),
      );
    });

    test('Cannot archive location with remaining stock', () async {
      final locId = await locationsRepo.createLocation(name: 'Drawer 1');
      await inventoryRepo.createComponent(
        name: 'Part A',
        category: 'IC',
        initialStock: 10,
        initialLocationId: locId,
      );

      expect(
        () => locationsRepo.archiveLocation(locId),
        throwsA(isA<LocationNotEmptyException>()),
      );
    });
  });

  group('Purchasing & Receiving Rules', () {
    test(
      'Purchase order receiving increases inventory and updates PO status',
      () async {
        final locId = await locationsRepo.createLocation(name: 'Main Shelf');
        final supplierId = await suppliersRepo.createSupplier(name: 'Mouser');
        final compId = await inventoryRepo.createComponent(
          name: 'NE555 Timer',
          category: 'IC',
        );

        final poId = await purchasingRepo.createPurchaseOrder(
          orderNumber: 'PO-TEST-01',
          supplierId: supplierId,
          orderDate: DateTime.now(),
          items: [
            NewPurchaseOrderItem(
              componentId: compId,
              orderedQuantity: 20,
              unitCostCents: 45,
            ),
          ],
        );

        var po = await purchasingRepo.watchPurchaseOrder(poId).first;
        expect(po?.order.status, equals('ordered'));
        final itemId = po!.items.first.item.id;

        // Partial receipt: 8 units
        await purchasingRepo.receivePurchaseOrderItem(
          purchaseOrderId: poId,
          itemId: itemId,
          destinationLocationId: locId,
          quantityToReceive: 8,
        );

        po = await purchasingRepo.watchPurchaseOrder(poId).first;
        expect(po?.order.status, equals('partiallyReceived'));
        expect(po?.items.first.item.receivedQuantity, equals(8));

        var stock = await inventoryRepo.watchComponentTotalStock(compId).first;
        expect(stock, equals(8));

        // Over-receipt attempt
        expect(
          () => purchasingRepo.receivePurchaseOrderItem(
            purchaseOrderId: poId,
            itemId: itemId,
            destinationLocationId: locId,
            quantityToReceive: 15, // remaining is 12
          ),
          throwsA(isA<OverReceiptException>()),
        );

        // Remaining receipt: 12 units
        await purchasingRepo.receivePurchaseOrderItem(
          purchaseOrderId: poId,
          itemId: itemId,
          destinationLocationId: locId,
          quantityToReceive: 12,
        );

        po = await purchasingRepo.watchPurchaseOrder(poId).first;
        expect(po?.order.status, equals('received'));
        expect(po?.items.first.item.receivedQuantity, equals(20));

        stock = await inventoryRepo.watchComponentTotalStock(compId).first;
        expect(stock, equals(20));
      },
    );
  });

  group('Projects & BOM Requirements', () {
    test('BOM calculates live stock shortages correctly', () async {
      final locId = await locationsRepo.createLocation(name: 'Drawer');
      final compA = await inventoryRepo.createComponent(
        name: 'Relay 5V',
        category: 'Electromechanical',
        initialStock: 2,
        initialLocationId: locId,
      );
      final compB = await inventoryRepo.createComponent(
        name: 'Flyback Diode',
        category: 'Diode',
        initialStock: 10,
        initialLocationId: locId,
      );

      final projectId = await projectsRepo.createProject(
        name: 'Automated Switch',
      );

      await projectsRepo.addBomItem(
        projectId: projectId,
        componentId: compA,
        quantityRequired: 5,
      );
      await projectsRepo.addBomItem(
        projectId: projectId,
        componentId: compB,
        quantityRequired: 4,
      );

      final boms = await projectsRepo.watchProjectBoms(projectId).first;
      final bomA = boms.firstWhere((b) => b.component.id == compA);
      final bomB = boms.firstWhere((b) => b.component.id == compB);

      expect(bomA.shortage, equals(3)); // 5 required - 2 available = 3 shortage
      expect(bomA.isSatisfied, isFalse);

      expect(
        bomB.shortage,
        equals(0),
      ); // 4 required - 10 available = 0 shortage
      expect(bomB.isSatisfied, isTrue);
    });
  });

  group('Stocktake Reconciliation', () {
    test(
      'Reconciling stocktake updates balances and logs auditable discrepancies',
      () async {
        final locId = await locationsRepo.createLocation(name: 'Bin A');
        final compId = await inventoryRepo.createComponent(
          name: 'Hex Standoff 10mm',
          category: 'Hardware',
          initialStock: 100,
          initialLocationId: locId,
        );

        final sessionId = await stocktakeRepo.startSession(locationId: locId);
        final entries = await stocktakeRepo
            .watchSessionEntries(sessionId)
            .first;
        expect(entries.length, equals(1));
        expect(entries.first.entry.expectedQuantity, equals(100));

        // Physical count finds 94 (6 missing)
        await stocktakeRepo.updateCountedQuantity(entries.first.entry.id, 94);

        await stocktakeRepo.reconcileSession(sessionId);

        final updatedStock = await inventoryRepo
            .watchComponentTotalStock(compId)
            .first;
        expect(updatedStock, equals(94));

        final movements = await movementsRepo
            .watchMovementsForComponent(compId)
            .first;
        expect(movements.first.movementType, equals('stocktakeReconciliation'));
        expect(movements.first.quantityDelta, equals(-6));
      },
    );
  });

  group('Data Portability: JSON Export & Restore', () {
    test(
      'Can export database to JSON and restore it without data loss',
      () async {
        await exportImportService.seedDemoWorkshopData();

        final exportedJson = await exportImportService.exportToJson();
        expect(exportedJson.contains('PartPouch'), isTrue);
        expect(exportedJson.contains('ESP32-C3 Dev Board'), isTrue);

        // Clear all data
        await exportImportService.resetAllData();
        var components = await inventoryRepo.watchComponentsWithStock().first;
        expect(components.isEmpty, isTrue);

        // Restore from JSON
        await exportImportService.importFromJson(exportedJson);
        components = await inventoryRepo.watchComponentsWithStock().first;
        expect(components.length, greaterThanOrEqualTo(5));
        expect(
          components.any((c) => c.component.name == 'ESP32-C3 Dev Board'),
          isTrue,
        );
      },
    );
  });
}
