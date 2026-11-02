import 'dart:convert';
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
      if (statusFilter == 'draft') {
        query.where((tbl) =>
            tbl.status.isIn(['draft', 'ordered', 'submitted']));
      } else if (statusFilter == 'partiallyReceived') {
        query.where((tbl) =>
            tbl.status.isIn(['partiallyReceived', 'partially_received']));
      } else if (statusFilter == 'received') {
        query.where((tbl) =>
            tbl.status.isIn(['received', 'completed']));
      } else if (statusFilter == 'cancelled') {
        query.where((tbl) => tbl.status.equals('cancelled'));
      } else {
        query.where((tbl) => tbl.status.equals(statusFilter));
      }
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

  /// Exports all purchase orders and line items to formatted JSON
  Future<String> exportPurchaseOrdersToJson() async {
    final pos = await (_db.select(_db.purchaseOrders)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();

    final List<Map<String, dynamic>> ordersJson = [];

    for (final po in pos) {
      Supplier? supplier;
      if (po.supplierId != null) {
        supplier = await (_db.select(_db.suppliers)
              ..where((tbl) => tbl.id.equals(po.supplierId!)))
            .getSingleOrNull();
      }

      final items = await (_db.select(_db.purchaseOrderItems).join([
        innerJoin(
          _db.components,
          _db.components.id.equalsExp(_db.purchaseOrderItems.componentId),
        ),
      ])..where(_db.purchaseOrderItems.purchaseOrderId.equals(po.id))).get();

      final itemsJson = items.map((row) {
        final poi = row.readTable(_db.purchaseOrderItems);
        final comp = row.readTable(_db.components);
        return {
          'componentName': comp.name,
          'componentCategory': comp.category,
          'mpn': comp.manufacturerPartNumber,
          'sku': comp.internalSku,
          'orderedQuantity': poi.orderedQuantity,
          'receivedQuantity': poi.receivedQuantity,
          'unitCostCents': poi.unitCostCents,
          'supplierPartNumber': poi.supplierPartNumber,
        };
      }).toList();

      ordersJson.add({
        'orderNumber': po.orderNumber,
        'supplierName': supplier?.name,
        'orderDate': po.orderDate.toIso8601String(),
        'expectedArrivalDate': po.expectedArrivalDate?.toIso8601String(),
        'status': po.status,
        'currency': po.currency,
        'notes': po.notes,
        'items': itemsJson,
      });
    }

    final data = {
      'app': 'PartPouch',
      'type': 'purchase_orders',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'count': ordersJson.length,
      'purchaseOrders': ordersJson,
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Parses JSON and imports purchase orders and their line items
  Future<int> importPurchaseOrdersFromJson(String jsonString) async {
    final dynamic decoded = jsonDecode(jsonString);
    final List<dynamic> list;

    if (decoded is List) {
      list = decoded;
    } else if (decoded is Map && decoded['purchaseOrders'] is List) {
      list = decoded['purchaseOrders'] as List;
    } else {
      throw const PartPouchException('Invalid purchase orders JSON format.');
    }

    int importedCount = 0;
    final now = DateTime.now();

    for (final raw in list) {
      if (raw is! Map) continue;
      final orderNumber = raw['orderNumber']?.toString().trim();
      if (orderNumber == null || orderNumber.isEmpty) continue;

      final existing = await (_db.select(_db.purchaseOrders)
            ..where((tbl) => tbl.orderNumber.equals(orderNumber)))
          .getSingleOrNull();

      if (existing != null) continue;

      String? supplierId;
      final supplierName = raw['supplierName']?.toString().trim();
      if (supplierName != null && supplierName.isNotEmpty) {
        final existingSup = await (_db.select(_db.suppliers)
              ..where((tbl) => tbl.name.equals(supplierName)))
            .getSingleOrNull();
        if (existingSup != null) {
          supplierId = existingSup.id;
        } else {
          supplierId = _uuid.v4();
          await _db.into(_db.suppliers).insert(
                SuppliersCompanion.insert(
                  id: supplierId,
                  name: supplierName,
                  createdAt: now,
                ),
              );
        }
      }

      final poId = _uuid.v4();
      final orderDate = raw['orderDate'] != null
          ? DateTime.tryParse(raw['orderDate'].toString()) ?? now
          : now;
      final expectedDate = raw['expectedArrivalDate'] != null
          ? DateTime.tryParse(raw['expectedArrivalDate'].toString())
          : null;
      final status = raw['status']?.toString() ?? 'ordered';
      final currency = raw['currency']?.toString() ?? 'USD';
      final notes = raw['notes']?.toString();

      await _db.into(_db.purchaseOrders).insert(
            PurchaseOrdersCompanion.insert(
              id: poId,
              orderNumber: orderNumber,
              supplierId: Value(supplierId),
              orderDate: orderDate,
              expectedArrivalDate: Value(expectedDate),
              status: status,
              currency: Value(currency),
              notes: Value(notes),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final rawItems = raw['items'];
      if (rawItems is List) {
        for (final rawItem in rawItems) {
          if (rawItem is! Map) continue;
          final compName = rawItem['componentName']?.toString().trim();
          final mpn = rawItem['mpn']?.toString().trim();
          final sku = rawItem['sku']?.toString().trim();

          Component? comp;
          if (mpn != null && mpn.isNotEmpty) {
            comp = await (_db.select(_db.components)
                  ..where((tbl) => tbl.manufacturerPartNumber.equals(mpn)))
                .getSingleOrNull();
          }
          if (comp == null && sku != null && sku.isNotEmpty) {
            comp = await (_db.select(_db.components)
                  ..where((tbl) => tbl.internalSku.equals(sku)))
                .getSingleOrNull();
          }
          if (comp == null && compName != null && compName.isNotEmpty) {
            comp = await (_db.select(_db.components)
                  ..where((tbl) => tbl.name.equals(compName)))
                .getSingleOrNull();
          }

          String componentId;
          if (comp != null) {
            componentId = comp.id;
          } else {
            componentId = _uuid.v4();
            await _db.into(_db.components).insert(
                  ComponentsCompanion.insert(
                    id: componentId,
                    name: compName ?? (mpn ?? 'Component'),
                    category:
                        rawItem['componentCategory']?.toString() ?? 'Other',
                    manufacturerPartNumber: Value(mpn),
                    internalSku: Value(sku),
                    createdAt: now,
                    updatedAt: now,
                  ),
                );
          }

          final orderedQty =
              int.tryParse(rawItem['orderedQuantity']?.toString() ?? '1') ?? 1;
          final receivedQty =
              int.tryParse(rawItem['receivedQuantity']?.toString() ?? '0') ?? 0;
          final unitCost =
              int.tryParse(rawItem['unitCostCents']?.toString() ?? '0') ?? 0;

          await _db.into(_db.purchaseOrderItems).insert(
                PurchaseOrderItemsCompanion.insert(
                  id: _uuid.v4(),
                  purchaseOrderId: poId,
                  componentId: componentId,
                  orderedQuantity: orderedQty,
                  receivedQuantity: Value(receivedQty),
                  unitCostCents: Value(unitCost),
                  supplierPartNumber:
                      Value(rawItem['supplierPartNumber']?.toString()),
                ),
              );
        }
      }

      importedCount++;
    }

    return importedCount;
  }

  /// Seeds default realistic purchase orders if none exist
  Future<int> seedDefaultPurchaseOrders() async {
    final existing = await (_db.select(_db.purchaseOrders)).get();
    if (existing.isNotEmpty) return 0;

    final suppliers = await (_db.select(_db.suppliers)..limit(3)).get();
    final components = await (_db.select(_db.components)..limit(4)).get();

    final now = DateTime.now();
    int createdCount = 0;

    final supplier1 = suppliers.isNotEmpty ? suppliers[0].id : null;
    final supplier2 = suppliers.length > 1 ? suppliers[1].id : supplier1;

    final po1Id = _uuid.v4();
    await _db.into(_db.purchaseOrders).insert(
          PurchaseOrdersCompanion.insert(
            id: po1Id,
            orderNumber: 'PO-2026-001',
            supplierId: Value(supplier1),
            orderDate: now.subtract(const Duration(days: 3)),
            expectedArrivalDate: Value(now.add(const Duration(days: 4))),
            status: 'ordered',
            currency: const Value('USD'),
            notes: const Value('Restocking passives and microcontrollers'),
            createdAt: now.subtract(const Duration(days: 3)),
            updatedAt: now,
          ),
        );
    createdCount++;

    if (components.isNotEmpty) {
      await _db.into(_db.purchaseOrderItems).insert(
            PurchaseOrderItemsCompanion.insert(
              id: _uuid.v4(),
              purchaseOrderId: po1Id,
              componentId: components[0].id,
              orderedQuantity: 25,
              receivedQuantity: const Value(0),
              unitCostCents: Value(components[0].unitCostCents ?? 150),
            ),
          );
    }
    if (components.length > 1) {
      await _db.into(_db.purchaseOrderItems).insert(
            PurchaseOrderItemsCompanion.insert(
              id: _uuid.v4(),
              purchaseOrderId: po1Id,
              componentId: components[1].id,
              orderedQuantity: 100,
              receivedQuantity: const Value(0),
              unitCostCents: Value(components[1].unitCostCents ?? 5),
            ),
          );
    }

    final po2Id = _uuid.v4();
    await _db.into(_db.purchaseOrders).insert(
          PurchaseOrdersCompanion.insert(
            id: po2Id,
            orderNumber: 'PO-2026-002',
            supplierId: Value(supplier2),
            orderDate: now.subtract(const Duration(days: 10)),
            expectedArrivalDate: Value(now.subtract(const Duration(days: 2))),
            status: 'partiallyReceived',
            currency: const Value('USD'),
            notes: const Value('Sensors and IC breakout modules'),
            createdAt: now.subtract(const Duration(days: 10)),
            updatedAt: now,
          ),
        );
    createdCount++;

    if (components.length > 2) {
      await _db.into(_db.purchaseOrderItems).insert(
            PurchaseOrderItemsCompanion.insert(
              id: _uuid.v4(),
              purchaseOrderId: po2Id,
              componentId: components[2].id,
              orderedQuantity: 50,
              receivedQuantity: const Value(20),
              unitCostCents: Value(components[2].unitCostCents ?? 25),
            ),
          );
    }

    return createdCount;
  }
}
