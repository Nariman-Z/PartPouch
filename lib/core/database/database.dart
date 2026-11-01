import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// --- TABLE DEFINITIONS ---

class Components extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category =>
      text()(); // e.g. Microcontroller, Resistor, Capacitor, IC, Sensor, Diode, Transistor, Module, Connector, Miscellaneous
  TextColumn get manufacturer => text().nullable()();
  TextColumn get manufacturerPartNumber => text().nullable()();
  TextColumn get internalSku => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get packageFootprint => text().nullable()();
  TextColumn get datasheetUrl => text().nullable()();
  TextColumn get tags => text().nullable()();
  IntColumn get minStockThreshold => integer().withDefault(const Constant(0))();
  IntColumn get targetStockQuantity => integer().nullable()();
  TextColumn get defaultSupplierId => text().nullable()();
  TextColumn get unitOfMeasure => text().withDefault(const Constant('pcs'))();
  IntColumn get unitCostCents =>
      integer().nullable()(); // Weighted-average cost in cents
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Locations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get code => text().nullable()(); // e.g. LOC-001-02
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class InventoryBalances extends Table {
  TextColumn get id => text()();
  TextColumn get componentId => text().references(Components, #id)();
  TextColumn get locationId => text().references(Locations, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {componentId, locationId},
  ];
}

class StockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get componentId => text().references(Components, #id)();
  TextColumn get movementType =>
      text()(); // initialStock, received, issued, transfer, positiveAdjustment, negativeAdjustment, stocktakeReconciliation, purchaseOrderReceipt
  IntColumn get quantityDelta => integer()();
  @ReferenceName('sourceStockMovements')
  TextColumn get sourceLocationId =>
      text().nullable().references(Locations, #id)();
  @ReferenceName('destinationStockMovements')
  TextColumn get destinationLocationId =>
      text().nullable().references(Locations, #id)();
  IntColumn get unitCostCents => integer().nullable()();
  TextColumn get projectId => text().nullable().references(Projects, #id)();
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  TextColumn get purchaseOrderId =>
      text().nullable().references(PurchaseOrders, #id)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Suppliers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get website => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PurchaseOrders extends Table {
  TextColumn get id => text()();
  TextColumn get orderNumber => text()();
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  DateTimeColumn get orderDate => dateTime()();
  DateTimeColumn get expectedArrivalDate => dateTime().nullable()();
  TextColumn get status =>
      text()(); // draft, ordered, partiallyReceived, received, cancelled
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class PurchaseOrderItems extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseOrderId => text().references(PurchaseOrders, #id)();
  TextColumn get componentId => text().references(Components, #id)();
  IntColumn get orderedQuantity => integer()();
  IntColumn get receivedQuantity => integer().withDefault(const Constant(0))();
  IntColumn get unitCostCents => integer().withDefault(const Constant(0))();
  TextColumn get supplierPartNumber => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withDefault(
    const Constant('inProgress'),
  )(); // planning, inProgress, completed, onHold, cancelled
  DateTimeColumn get targetDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProjectBoms extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get componentId => text().references(Components, #id)();
  IntColumn get quantityRequired => integer()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {projectId, componentId},
  ];
}

class StocktakeSessions extends Table {
  TextColumn get id => text()();
  TextColumn get locationId => text().nullable().references(Locations, #id)();
  TextColumn get status => text()(); // inProgress, completed, cancelled
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class StocktakeEntries extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(StocktakeSessions, #id)();
  TextColumn get componentId => text().references(Components, #id)();
  IntColumn get expectedQuantity => integer()();
  IntColumn get countedQuantity => integer()();
  BoolColumn get reconciled => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    Components,
    Locations,
    InventoryBalances,
    StockMovements,
    Suppliers,
    PurchaseOrders,
    PurchaseOrderItems,
    Projects,
    ProjectBoms,
    StocktakeSessions,
    StocktakeEntries,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'partpouch_db');
  }
}
