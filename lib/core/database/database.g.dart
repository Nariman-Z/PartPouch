// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ComponentsTable extends Components
    with TableInfo<$ComponentsTable, Component> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComponentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manufacturerMeta = const VerificationMeta(
    'manufacturer',
  );
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
    'manufacturer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manufacturerPartNumberMeta =
      const VerificationMeta('manufacturerPartNumber');
  @override
  late final GeneratedColumn<String> manufacturerPartNumber =
      GeneratedColumn<String>(
        'manufacturer_part_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _internalSkuMeta = const VerificationMeta(
    'internalSku',
  );
  @override
  late final GeneratedColumn<String> internalSku = GeneratedColumn<String>(
    'internal_sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _packageFootprintMeta = const VerificationMeta(
    'packageFootprint',
  );
  @override
  late final GeneratedColumn<String> packageFootprint = GeneratedColumn<String>(
    'package_footprint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _datasheetUrlMeta = const VerificationMeta(
    'datasheetUrl',
  );
  @override
  late final GeneratedColumn<String> datasheetUrl = GeneratedColumn<String>(
    'datasheet_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minStockThresholdMeta = const VerificationMeta(
    'minStockThreshold',
  );
  @override
  late final GeneratedColumn<int> minStockThreshold = GeneratedColumn<int>(
    'min_stock_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetStockQuantityMeta =
      const VerificationMeta('targetStockQuantity');
  @override
  late final GeneratedColumn<int> targetStockQuantity = GeneratedColumn<int>(
    'target_stock_quantity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultSupplierIdMeta = const VerificationMeta(
    'defaultSupplierId',
  );
  @override
  late final GeneratedColumn<String> defaultSupplierId =
      GeneratedColumn<String>(
        'default_supplier_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _unitOfMeasureMeta = const VerificationMeta(
    'unitOfMeasure',
  );
  @override
  late final GeneratedColumn<String> unitOfMeasure = GeneratedColumn<String>(
    'unit_of_measure',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pcs'),
  );
  static const VerificationMeta _unitCostCentsMeta = const VerificationMeta(
    'unitCostCents',
  );
  @override
  late final GeneratedColumn<int> unitCostCents = GeneratedColumn<int>(
    'unit_cost_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    manufacturer,
    manufacturerPartNumber,
    internalSku,
    description,
    packageFootprint,
    datasheetUrl,
    tags,
    minStockThreshold,
    targetStockQuantity,
    defaultSupplierId,
    unitOfMeasure,
    unitCostCents,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'components';
  @override
  VerificationContext validateIntegrity(
    Insertable<Component> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
        _manufacturerMeta,
        manufacturer.isAcceptableOrUnknown(
          data['manufacturer']!,
          _manufacturerMeta,
        ),
      );
    }
    if (data.containsKey('manufacturer_part_number')) {
      context.handle(
        _manufacturerPartNumberMeta,
        manufacturerPartNumber.isAcceptableOrUnknown(
          data['manufacturer_part_number']!,
          _manufacturerPartNumberMeta,
        ),
      );
    }
    if (data.containsKey('internal_sku')) {
      context.handle(
        _internalSkuMeta,
        internalSku.isAcceptableOrUnknown(
          data['internal_sku']!,
          _internalSkuMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('package_footprint')) {
      context.handle(
        _packageFootprintMeta,
        packageFootprint.isAcceptableOrUnknown(
          data['package_footprint']!,
          _packageFootprintMeta,
        ),
      );
    }
    if (data.containsKey('datasheet_url')) {
      context.handle(
        _datasheetUrlMeta,
        datasheetUrl.isAcceptableOrUnknown(
          data['datasheet_url']!,
          _datasheetUrlMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('min_stock_threshold')) {
      context.handle(
        _minStockThresholdMeta,
        minStockThreshold.isAcceptableOrUnknown(
          data['min_stock_threshold']!,
          _minStockThresholdMeta,
        ),
      );
    }
    if (data.containsKey('target_stock_quantity')) {
      context.handle(
        _targetStockQuantityMeta,
        targetStockQuantity.isAcceptableOrUnknown(
          data['target_stock_quantity']!,
          _targetStockQuantityMeta,
        ),
      );
    }
    if (data.containsKey('default_supplier_id')) {
      context.handle(
        _defaultSupplierIdMeta,
        defaultSupplierId.isAcceptableOrUnknown(
          data['default_supplier_id']!,
          _defaultSupplierIdMeta,
        ),
      );
    }
    if (data.containsKey('unit_of_measure')) {
      context.handle(
        _unitOfMeasureMeta,
        unitOfMeasure.isAcceptableOrUnknown(
          data['unit_of_measure']!,
          _unitOfMeasureMeta,
        ),
      );
    }
    if (data.containsKey('unit_cost_cents')) {
      context.handle(
        _unitCostCentsMeta,
        unitCostCents.isAcceptableOrUnknown(
          data['unit_cost_cents']!,
          _unitCostCentsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Component map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Component(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      manufacturer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer'],
      ),
      manufacturerPartNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer_part_number'],
      ),
      internalSku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}internal_sku'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      packageFootprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_footprint'],
      ),
      datasheetUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}datasheet_url'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      minStockThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_stock_threshold'],
      )!,
      targetStockQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_stock_quantity'],
      ),
      defaultSupplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_supplier_id'],
      ),
      unitOfMeasure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_of_measure'],
      )!,
      unitCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_cents'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $ComponentsTable createAlias(String alias) {
    return $ComponentsTable(attachedDatabase, alias);
  }
}

class Component extends DataClass implements Insertable<Component> {
  final String id;
  final String name;
  final String category;
  final String? manufacturer;
  final String? manufacturerPartNumber;
  final String? internalSku;
  final String? description;
  final String? packageFootprint;
  final String? datasheetUrl;
  final String? tags;
  final int minStockThreshold;
  final int? targetStockQuantity;
  final String? defaultSupplierId;
  final String unitOfMeasure;
  final int? unitCostCents;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const Component({
    required this.id,
    required this.name,
    required this.category,
    this.manufacturer,
    this.manufacturerPartNumber,
    this.internalSku,
    this.description,
    this.packageFootprint,
    this.datasheetUrl,
    this.tags,
    required this.minStockThreshold,
    this.targetStockQuantity,
    this.defaultSupplierId,
    required this.unitOfMeasure,
    this.unitCostCents,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || manufacturerPartNumber != null) {
      map['manufacturer_part_number'] = Variable<String>(
        manufacturerPartNumber,
      );
    }
    if (!nullToAbsent || internalSku != null) {
      map['internal_sku'] = Variable<String>(internalSku);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || packageFootprint != null) {
      map['package_footprint'] = Variable<String>(packageFootprint);
    }
    if (!nullToAbsent || datasheetUrl != null) {
      map['datasheet_url'] = Variable<String>(datasheetUrl);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['min_stock_threshold'] = Variable<int>(minStockThreshold);
    if (!nullToAbsent || targetStockQuantity != null) {
      map['target_stock_quantity'] = Variable<int>(targetStockQuantity);
    }
    if (!nullToAbsent || defaultSupplierId != null) {
      map['default_supplier_id'] = Variable<String>(defaultSupplierId);
    }
    map['unit_of_measure'] = Variable<String>(unitOfMeasure);
    if (!nullToAbsent || unitCostCents != null) {
      map['unit_cost_cents'] = Variable<int>(unitCostCents);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  ComponentsCompanion toCompanion(bool nullToAbsent) {
    return ComponentsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      manufacturerPartNumber: manufacturerPartNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturerPartNumber),
      internalSku: internalSku == null && nullToAbsent
          ? const Value.absent()
          : Value(internalSku),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      packageFootprint: packageFootprint == null && nullToAbsent
          ? const Value.absent()
          : Value(packageFootprint),
      datasheetUrl: datasheetUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(datasheetUrl),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      minStockThreshold: Value(minStockThreshold),
      targetStockQuantity: targetStockQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(targetStockQuantity),
      defaultSupplierId: defaultSupplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultSupplierId),
      unitOfMeasure: Value(unitOfMeasure),
      unitCostCents: unitCostCents == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostCents),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Component.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Component(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      manufacturerPartNumber: serializer.fromJson<String?>(
        json['manufacturerPartNumber'],
      ),
      internalSku: serializer.fromJson<String?>(json['internalSku']),
      description: serializer.fromJson<String?>(json['description']),
      packageFootprint: serializer.fromJson<String?>(json['packageFootprint']),
      datasheetUrl: serializer.fromJson<String?>(json['datasheetUrl']),
      tags: serializer.fromJson<String?>(json['tags']),
      minStockThreshold: serializer.fromJson<int>(json['minStockThreshold']),
      targetStockQuantity: serializer.fromJson<int?>(
        json['targetStockQuantity'],
      ),
      defaultSupplierId: serializer.fromJson<String?>(
        json['defaultSupplierId'],
      ),
      unitOfMeasure: serializer.fromJson<String>(json['unitOfMeasure']),
      unitCostCents: serializer.fromJson<int?>(json['unitCostCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'manufacturerPartNumber': serializer.toJson<String?>(
        manufacturerPartNumber,
      ),
      'internalSku': serializer.toJson<String?>(internalSku),
      'description': serializer.toJson<String?>(description),
      'packageFootprint': serializer.toJson<String?>(packageFootprint),
      'datasheetUrl': serializer.toJson<String?>(datasheetUrl),
      'tags': serializer.toJson<String?>(tags),
      'minStockThreshold': serializer.toJson<int>(minStockThreshold),
      'targetStockQuantity': serializer.toJson<int?>(targetStockQuantity),
      'defaultSupplierId': serializer.toJson<String?>(defaultSupplierId),
      'unitOfMeasure': serializer.toJson<String>(unitOfMeasure),
      'unitCostCents': serializer.toJson<int?>(unitCostCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Component copyWith({
    String? id,
    String? name,
    String? category,
    Value<String?> manufacturer = const Value.absent(),
    Value<String?> manufacturerPartNumber = const Value.absent(),
    Value<String?> internalSku = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> packageFootprint = const Value.absent(),
    Value<String?> datasheetUrl = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    int? minStockThreshold,
    Value<int?> targetStockQuantity = const Value.absent(),
    Value<String?> defaultSupplierId = const Value.absent(),
    String? unitOfMeasure,
    Value<int?> unitCostCents = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Component(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    manufacturer: manufacturer.present ? manufacturer.value : this.manufacturer,
    manufacturerPartNumber: manufacturerPartNumber.present
        ? manufacturerPartNumber.value
        : this.manufacturerPartNumber,
    internalSku: internalSku.present ? internalSku.value : this.internalSku,
    description: description.present ? description.value : this.description,
    packageFootprint: packageFootprint.present
        ? packageFootprint.value
        : this.packageFootprint,
    datasheetUrl: datasheetUrl.present ? datasheetUrl.value : this.datasheetUrl,
    tags: tags.present ? tags.value : this.tags,
    minStockThreshold: minStockThreshold ?? this.minStockThreshold,
    targetStockQuantity: targetStockQuantity.present
        ? targetStockQuantity.value
        : this.targetStockQuantity,
    defaultSupplierId: defaultSupplierId.present
        ? defaultSupplierId.value
        : this.defaultSupplierId,
    unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
    unitCostCents: unitCostCents.present
        ? unitCostCents.value
        : this.unitCostCents,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Component copyWithCompanion(ComponentsCompanion data) {
    return Component(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      manufacturerPartNumber: data.manufacturerPartNumber.present
          ? data.manufacturerPartNumber.value
          : this.manufacturerPartNumber,
      internalSku: data.internalSku.present
          ? data.internalSku.value
          : this.internalSku,
      description: data.description.present
          ? data.description.value
          : this.description,
      packageFootprint: data.packageFootprint.present
          ? data.packageFootprint.value
          : this.packageFootprint,
      datasheetUrl: data.datasheetUrl.present
          ? data.datasheetUrl.value
          : this.datasheetUrl,
      tags: data.tags.present ? data.tags.value : this.tags,
      minStockThreshold: data.minStockThreshold.present
          ? data.minStockThreshold.value
          : this.minStockThreshold,
      targetStockQuantity: data.targetStockQuantity.present
          ? data.targetStockQuantity.value
          : this.targetStockQuantity,
      defaultSupplierId: data.defaultSupplierId.present
          ? data.defaultSupplierId.value
          : this.defaultSupplierId,
      unitOfMeasure: data.unitOfMeasure.present
          ? data.unitOfMeasure.value
          : this.unitOfMeasure,
      unitCostCents: data.unitCostCents.present
          ? data.unitCostCents.value
          : this.unitCostCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Component(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('manufacturerPartNumber: $manufacturerPartNumber, ')
          ..write('internalSku: $internalSku, ')
          ..write('description: $description, ')
          ..write('packageFootprint: $packageFootprint, ')
          ..write('datasheetUrl: $datasheetUrl, ')
          ..write('tags: $tags, ')
          ..write('minStockThreshold: $minStockThreshold, ')
          ..write('targetStockQuantity: $targetStockQuantity, ')
          ..write('defaultSupplierId: $defaultSupplierId, ')
          ..write('unitOfMeasure: $unitOfMeasure, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    manufacturer,
    manufacturerPartNumber,
    internalSku,
    description,
    packageFootprint,
    datasheetUrl,
    tags,
    minStockThreshold,
    targetStockQuantity,
    defaultSupplierId,
    unitOfMeasure,
    unitCostCents,
    createdAt,
    updatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Component &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.manufacturer == this.manufacturer &&
          other.manufacturerPartNumber == this.manufacturerPartNumber &&
          other.internalSku == this.internalSku &&
          other.description == this.description &&
          other.packageFootprint == this.packageFootprint &&
          other.datasheetUrl == this.datasheetUrl &&
          other.tags == this.tags &&
          other.minStockThreshold == this.minStockThreshold &&
          other.targetStockQuantity == this.targetStockQuantity &&
          other.defaultSupplierId == this.defaultSupplierId &&
          other.unitOfMeasure == this.unitOfMeasure &&
          other.unitCostCents == this.unitCostCents &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class ComponentsCompanion extends UpdateCompanion<Component> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> manufacturer;
  final Value<String?> manufacturerPartNumber;
  final Value<String?> internalSku;
  final Value<String?> description;
  final Value<String?> packageFootprint;
  final Value<String?> datasheetUrl;
  final Value<String?> tags;
  final Value<int> minStockThreshold;
  final Value<int?> targetStockQuantity;
  final Value<String?> defaultSupplierId;
  final Value<String> unitOfMeasure;
  final Value<int?> unitCostCents;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const ComponentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.manufacturerPartNumber = const Value.absent(),
    this.internalSku = const Value.absent(),
    this.description = const Value.absent(),
    this.packageFootprint = const Value.absent(),
    this.datasheetUrl = const Value.absent(),
    this.tags = const Value.absent(),
    this.minStockThreshold = const Value.absent(),
    this.targetStockQuantity = const Value.absent(),
    this.defaultSupplierId = const Value.absent(),
    this.unitOfMeasure = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComponentsCompanion.insert({
    required String id,
    required String name,
    required String category,
    this.manufacturer = const Value.absent(),
    this.manufacturerPartNumber = const Value.absent(),
    this.internalSku = const Value.absent(),
    this.description = const Value.absent(),
    this.packageFootprint = const Value.absent(),
    this.datasheetUrl = const Value.absent(),
    this.tags = const Value.absent(),
    this.minStockThreshold = const Value.absent(),
    this.targetStockQuantity = const Value.absent(),
    this.defaultSupplierId = const Value.absent(),
    this.unitOfMeasure = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Component> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? manufacturer,
    Expression<String>? manufacturerPartNumber,
    Expression<String>? internalSku,
    Expression<String>? description,
    Expression<String>? packageFootprint,
    Expression<String>? datasheetUrl,
    Expression<String>? tags,
    Expression<int>? minStockThreshold,
    Expression<int>? targetStockQuantity,
    Expression<String>? defaultSupplierId,
    Expression<String>? unitOfMeasure,
    Expression<int>? unitCostCents,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (manufacturerPartNumber != null)
        'manufacturer_part_number': manufacturerPartNumber,
      if (internalSku != null) 'internal_sku': internalSku,
      if (description != null) 'description': description,
      if (packageFootprint != null) 'package_footprint': packageFootprint,
      if (datasheetUrl != null) 'datasheet_url': datasheetUrl,
      if (tags != null) 'tags': tags,
      if (minStockThreshold != null) 'min_stock_threshold': minStockThreshold,
      if (targetStockQuantity != null)
        'target_stock_quantity': targetStockQuantity,
      if (defaultSupplierId != null) 'default_supplier_id': defaultSupplierId,
      if (unitOfMeasure != null) 'unit_of_measure': unitOfMeasure,
      if (unitCostCents != null) 'unit_cost_cents': unitCostCents,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComponentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String?>? manufacturer,
    Value<String?>? manufacturerPartNumber,
    Value<String?>? internalSku,
    Value<String?>? description,
    Value<String?>? packageFootprint,
    Value<String?>? datasheetUrl,
    Value<String?>? tags,
    Value<int>? minStockThreshold,
    Value<int?>? targetStockQuantity,
    Value<String?>? defaultSupplierId,
    Value<String>? unitOfMeasure,
    Value<int?>? unitCostCents,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return ComponentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      manufacturer: manufacturer ?? this.manufacturer,
      manufacturerPartNumber:
          manufacturerPartNumber ?? this.manufacturerPartNumber,
      internalSku: internalSku ?? this.internalSku,
      description: description ?? this.description,
      packageFootprint: packageFootprint ?? this.packageFootprint,
      datasheetUrl: datasheetUrl ?? this.datasheetUrl,
      tags: tags ?? this.tags,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      targetStockQuantity: targetStockQuantity ?? this.targetStockQuantity,
      defaultSupplierId: defaultSupplierId ?? this.defaultSupplierId,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      unitCostCents: unitCostCents ?? this.unitCostCents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (manufacturerPartNumber.present) {
      map['manufacturer_part_number'] = Variable<String>(
        manufacturerPartNumber.value,
      );
    }
    if (internalSku.present) {
      map['internal_sku'] = Variable<String>(internalSku.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (packageFootprint.present) {
      map['package_footprint'] = Variable<String>(packageFootprint.value);
    }
    if (datasheetUrl.present) {
      map['datasheet_url'] = Variable<String>(datasheetUrl.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (minStockThreshold.present) {
      map['min_stock_threshold'] = Variable<int>(minStockThreshold.value);
    }
    if (targetStockQuantity.present) {
      map['target_stock_quantity'] = Variable<int>(targetStockQuantity.value);
    }
    if (defaultSupplierId.present) {
      map['default_supplier_id'] = Variable<String>(defaultSupplierId.value);
    }
    if (unitOfMeasure.present) {
      map['unit_of_measure'] = Variable<String>(unitOfMeasure.value);
    }
    if (unitCostCents.present) {
      map['unit_cost_cents'] = Variable<int>(unitCostCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComponentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('manufacturerPartNumber: $manufacturerPartNumber, ')
          ..write('internalSku: $internalSku, ')
          ..write('description: $description, ')
          ..write('packageFootprint: $packageFootprint, ')
          ..write('datasheetUrl: $datasheetUrl, ')
          ..write('tags: $tags, ')
          ..write('minStockThreshold: $minStockThreshold, ')
          ..write('targetStockQuantity: $targetStockQuantity, ')
          ..write('defaultSupplierId: $defaultSupplierId, ')
          ..write('unitOfMeasure: $unitOfMeasure, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    code,
    description,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Location> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Location(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class Location extends DataClass implements Insertable<Location> {
  final String id;
  final String name;
  final String? parentId;
  final String? code;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const Location({
    required this.id,
    required this.name,
    this.parentId,
    this.code,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Location.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      code: serializer.fromJson<String?>(json['code']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'code': serializer.toJson<String?>(code),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Location copyWith({
    String? id,
    String? name,
    Value<String?> parentId = const Value.absent(),
    Value<String?> code = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Location(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    code: code.present ? code.value : this.code,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Location copyWithCompanion(LocationsCompanion data) {
    return Location(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      code: data.code.present ? data.code.value : this.code,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    parentId,
    code,
    description,
    createdAt,
    updatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.code == this.code &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<String?> code;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    this.code = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Location> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<String>? code,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentId,
    Value<String?>? code,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return LocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      code: code ?? this.code,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('code: $code, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryBalancesTable extends InventoryBalances
    with TableInfo<$InventoryBalancesTable, InventoryBalance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryBalancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id)',
    ),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, componentId, locationId, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_balances';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryBalance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {componentId, locationId},
  ];
  @override
  InventoryBalance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryBalance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $InventoryBalancesTable createAlias(String alias) {
    return $InventoryBalancesTable(attachedDatabase, alias);
  }
}

class InventoryBalance extends DataClass
    implements Insertable<InventoryBalance> {
  final String id;
  final String componentId;
  final String locationId;
  final int quantity;
  const InventoryBalance({
    required this.id,
    required this.componentId,
    required this.locationId,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['component_id'] = Variable<String>(componentId);
    map['location_id'] = Variable<String>(locationId);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  InventoryBalancesCompanion toCompanion(bool nullToAbsent) {
    return InventoryBalancesCompanion(
      id: Value(id),
      componentId: Value(componentId),
      locationId: Value(locationId),
      quantity: Value(quantity),
    );
  }

  factory InventoryBalance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryBalance(
      id: serializer.fromJson<String>(json['id']),
      componentId: serializer.fromJson<String>(json['componentId']),
      locationId: serializer.fromJson<String>(json['locationId']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'componentId': serializer.toJson<String>(componentId),
      'locationId': serializer.toJson<String>(locationId),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  InventoryBalance copyWith({
    String? id,
    String? componentId,
    String? locationId,
    int? quantity,
  }) => InventoryBalance(
    id: id ?? this.id,
    componentId: componentId ?? this.componentId,
    locationId: locationId ?? this.locationId,
    quantity: quantity ?? this.quantity,
  );
  InventoryBalance copyWithCompanion(InventoryBalancesCompanion data) {
    return InventoryBalance(
      id: data.id.present ? data.id.value : this.id,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBalance(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('locationId: $locationId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, componentId, locationId, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryBalance &&
          other.id == this.id &&
          other.componentId == this.componentId &&
          other.locationId == this.locationId &&
          other.quantity == this.quantity);
}

class InventoryBalancesCompanion extends UpdateCompanion<InventoryBalance> {
  final Value<String> id;
  final Value<String> componentId;
  final Value<String> locationId;
  final Value<int> quantity;
  final Value<int> rowid;
  const InventoryBalancesCompanion({
    this.id = const Value.absent(),
    this.componentId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryBalancesCompanion.insert({
    required String id,
    required String componentId,
    required String locationId,
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       componentId = Value(componentId),
       locationId = Value(locationId);
  static Insertable<InventoryBalance> custom({
    Expression<String>? id,
    Expression<String>? componentId,
    Expression<String>? locationId,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (componentId != null) 'component_id': componentId,
      if (locationId != null) 'location_id': locationId,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryBalancesCompanion copyWith({
    Value<String>? id,
    Value<String>? componentId,
    Value<String>? locationId,
    Value<int>? quantity,
    Value<int>? rowid,
  }) {
    return InventoryBalancesCompanion(
      id: id ?? this.id,
      componentId: componentId ?? this.componentId,
      locationId: locationId ?? this.locationId,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBalancesCompanion(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('locationId: $locationId, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inProgress'),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    status,
    targetDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String? description;
  final String status;
  final DateTime? targetDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    this.targetDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? status,
    Value<DateTime?> targetDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    status,
    targetDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.status == this.status &&
          other.targetDate == this.targetDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> status;
  final Value<DateTime?> targetDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.targetDate = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? status,
    Expression<DateTime>? targetDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (targetDate != null) 'target_date': targetDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? status,
    Value<DateTime?>? targetDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('targetDate: $targetDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    website,
    email,
    phone,
    notes,
    createdAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final String id;
  final String name;
  final String? website;
  final String? email;
  final String? phone;
  final String? notes;
  final DateTime createdAt;
  final DateTime? archivedAt;
  const Supplier({
    required this.id,
    required this.name,
    this.website,
    this.email,
    this.phone,
    this.notes,
    required this.createdAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      website: serializer.fromJson<String?>(json['website']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'website': serializer.toJson<String?>(website),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Supplier copyWith({
    String? id,
    String? name,
    Value<String?> website = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Supplier(
    id: id ?? this.id,
    name: name ?? this.name,
    website: website.present ? website.value : this.website,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      website: data.website.present ? data.website.value : this.website,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('website: $website, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    website,
    email,
    phone,
    notes,
    createdAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.website == this.website &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> website;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.website = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    required String id,
    required String name,
    this.website = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Supplier> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? website,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (website != null) 'website': website,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? website,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      website: website ?? this.website,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('website: $website, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseOrdersTable extends PurchaseOrders
    with TableInfo<$PurchaseOrdersTable, PurchaseOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderNumberMeta = const VerificationMeta(
    'orderNumber',
  );
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
    'order_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES suppliers (id)',
    ),
  );
  static const VerificationMeta _orderDateMeta = const VerificationMeta(
    'orderDate',
  );
  @override
  late final GeneratedColumn<DateTime> orderDate = GeneratedColumn<DateTime>(
    'order_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedArrivalDateMeta =
      const VerificationMeta('expectedArrivalDate');
  @override
  late final GeneratedColumn<DateTime> expectedArrivalDate =
      GeneratedColumn<DateTime>(
        'expected_arrival_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderNumber,
    supplierId,
    orderDate,
    expectedArrivalDate,
    status,
    currency,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_number')) {
      context.handle(
        _orderNumberMeta,
        orderNumber.isAcceptableOrUnknown(
          data['order_number']!,
          _orderNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('order_date')) {
      context.handle(
        _orderDateMeta,
        orderDate.isAcceptableOrUnknown(data['order_date']!, _orderDateMeta),
      );
    } else if (isInserting) {
      context.missing(_orderDateMeta);
    }
    if (data.containsKey('expected_arrival_date')) {
      context.handle(
        _expectedArrivalDateMeta,
        expectedArrivalDate.isAcceptableOrUnknown(
          data['expected_arrival_date']!,
          _expectedArrivalDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_number'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      orderDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}order_date'],
      )!,
      expectedArrivalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expected_arrival_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PurchaseOrdersTable createAlias(String alias) {
    return $PurchaseOrdersTable(attachedDatabase, alias);
  }
}

class PurchaseOrder extends DataClass implements Insertable<PurchaseOrder> {
  final String id;
  final String orderNumber;
  final String? supplierId;
  final DateTime orderDate;
  final DateTime? expectedArrivalDate;
  final String status;
  final String currency;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PurchaseOrder({
    required this.id,
    required this.orderNumber,
    this.supplierId,
    required this.orderDate,
    this.expectedArrivalDate,
    required this.status,
    required this.currency,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_number'] = Variable<String>(orderNumber);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    map['order_date'] = Variable<DateTime>(orderDate);
    if (!nullToAbsent || expectedArrivalDate != null) {
      map['expected_arrival_date'] = Variable<DateTime>(expectedArrivalDate);
    }
    map['status'] = Variable<String>(status);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PurchaseOrdersCompanion toCompanion(bool nullToAbsent) {
    return PurchaseOrdersCompanion(
      id: Value(id),
      orderNumber: Value(orderNumber),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      orderDate: Value(orderDate),
      expectedArrivalDate: expectedArrivalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedArrivalDate),
      status: Value(status),
      currency: Value(currency),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PurchaseOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseOrder(
      id: serializer.fromJson<String>(json['id']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      orderDate: serializer.fromJson<DateTime>(json['orderDate']),
      expectedArrivalDate: serializer.fromJson<DateTime?>(
        json['expectedArrivalDate'],
      ),
      status: serializer.fromJson<String>(json['status']),
      currency: serializer.fromJson<String>(json['currency']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'supplierId': serializer.toJson<String?>(supplierId),
      'orderDate': serializer.toJson<DateTime>(orderDate),
      'expectedArrivalDate': serializer.toJson<DateTime?>(expectedArrivalDate),
      'status': serializer.toJson<String>(status),
      'currency': serializer.toJson<String>(currency),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PurchaseOrder copyWith({
    String? id,
    String? orderNumber,
    Value<String?> supplierId = const Value.absent(),
    DateTime? orderDate,
    Value<DateTime?> expectedArrivalDate = const Value.absent(),
    String? status,
    String? currency,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PurchaseOrder(
    id: id ?? this.id,
    orderNumber: orderNumber ?? this.orderNumber,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    orderDate: orderDate ?? this.orderDate,
    expectedArrivalDate: expectedArrivalDate.present
        ? expectedArrivalDate.value
        : this.expectedArrivalDate,
    status: status ?? this.status,
    currency: currency ?? this.currency,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PurchaseOrder copyWithCompanion(PurchaseOrdersCompanion data) {
    return PurchaseOrder(
      id: data.id.present ? data.id.value : this.id,
      orderNumber: data.orderNumber.present
          ? data.orderNumber.value
          : this.orderNumber,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      orderDate: data.orderDate.present ? data.orderDate.value : this.orderDate,
      expectedArrivalDate: data.expectedArrivalDate.present
          ? data.expectedArrivalDate.value
          : this.expectedArrivalDate,
      status: data.status.present ? data.status.value : this.status,
      currency: data.currency.present ? data.currency.value : this.currency,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrder(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('orderDate: $orderDate, ')
          ..write('expectedArrivalDate: $expectedArrivalDate, ')
          ..write('status: $status, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderNumber,
    supplierId,
    orderDate,
    expectedArrivalDate,
    status,
    currency,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseOrder &&
          other.id == this.id &&
          other.orderNumber == this.orderNumber &&
          other.supplierId == this.supplierId &&
          other.orderDate == this.orderDate &&
          other.expectedArrivalDate == this.expectedArrivalDate &&
          other.status == this.status &&
          other.currency == this.currency &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PurchaseOrdersCompanion extends UpdateCompanion<PurchaseOrder> {
  final Value<String> id;
  final Value<String> orderNumber;
  final Value<String?> supplierId;
  final Value<DateTime> orderDate;
  final Value<DateTime?> expectedArrivalDate;
  final Value<String> status;
  final Value<String> currency;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PurchaseOrdersCompanion({
    this.id = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.orderDate = const Value.absent(),
    this.expectedArrivalDate = const Value.absent(),
    this.status = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseOrdersCompanion.insert({
    required String id,
    required String orderNumber,
    this.supplierId = const Value.absent(),
    required DateTime orderDate,
    this.expectedArrivalDate = const Value.absent(),
    required String status,
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderNumber = Value(orderNumber),
       orderDate = Value(orderDate),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PurchaseOrder> custom({
    Expression<String>? id,
    Expression<String>? orderNumber,
    Expression<String>? supplierId,
    Expression<DateTime>? orderDate,
    Expression<DateTime>? expectedArrivalDate,
    Expression<String>? status,
    Expression<String>? currency,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderNumber != null) 'order_number': orderNumber,
      if (supplierId != null) 'supplier_id': supplierId,
      if (orderDate != null) 'order_date': orderDate,
      if (expectedArrivalDate != null)
        'expected_arrival_date': expectedArrivalDate,
      if (status != null) 'status': status,
      if (currency != null) 'currency': currency,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseOrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? orderNumber,
    Value<String?>? supplierId,
    Value<DateTime>? orderDate,
    Value<DateTime?>? expectedArrivalDate,
    Value<String>? status,
    Value<String>? currency,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PurchaseOrdersCompanion(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      supplierId: supplierId ?? this.supplierId,
      orderDate: orderDate ?? this.orderDate,
      expectedArrivalDate: expectedArrivalDate ?? this.expectedArrivalDate,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (orderDate.present) {
      map['order_date'] = Variable<DateTime>(orderDate.value);
    }
    if (expectedArrivalDate.present) {
      map['expected_arrival_date'] = Variable<DateTime>(
        expectedArrivalDate.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrdersCompanion(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('orderDate: $orderDate, ')
          ..write('expectedArrivalDate: $expectedArrivalDate, ')
          ..write('status: $status, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id)',
    ),
  );
  static const VerificationMeta _movementTypeMeta = const VerificationMeta(
    'movementType',
  );
  @override
  late final GeneratedColumn<String> movementType = GeneratedColumn<String>(
    'movement_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityDeltaMeta = const VerificationMeta(
    'quantityDelta',
  );
  @override
  late final GeneratedColumn<int> quantityDelta = GeneratedColumn<int>(
    'quantity_delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLocationIdMeta = const VerificationMeta(
    'sourceLocationId',
  );
  @override
  late final GeneratedColumn<String> sourceLocationId = GeneratedColumn<String>(
    'source_location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
  );
  static const VerificationMeta _destinationLocationIdMeta =
      const VerificationMeta('destinationLocationId');
  @override
  late final GeneratedColumn<String> destinationLocationId =
      GeneratedColumn<String>(
        'destination_location_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES locations (id)',
        ),
      );
  static const VerificationMeta _unitCostCentsMeta = const VerificationMeta(
    'unitCostCents',
  );
  @override
  late final GeneratedColumn<int> unitCostCents = GeneratedColumn<int>(
    'unit_cost_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES suppliers (id)',
    ),
  );
  static const VerificationMeta _purchaseOrderIdMeta = const VerificationMeta(
    'purchaseOrderId',
  );
  @override
  late final GeneratedColumn<String> purchaseOrderId = GeneratedColumn<String>(
    'purchase_order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase_orders (id)',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    componentId,
    movementType,
    quantityDelta,
    sourceLocationId,
    destinationLocationId,
    unitCostCents,
    projectId,
    supplierId,
    purchaseOrderId,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentIdMeta);
    }
    if (data.containsKey('movement_type')) {
      context.handle(
        _movementTypeMeta,
        movementType.isAcceptableOrUnknown(
          data['movement_type']!,
          _movementTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_movementTypeMeta);
    }
    if (data.containsKey('quantity_delta')) {
      context.handle(
        _quantityDeltaMeta,
        quantityDelta.isAcceptableOrUnknown(
          data['quantity_delta']!,
          _quantityDeltaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityDeltaMeta);
    }
    if (data.containsKey('source_location_id')) {
      context.handle(
        _sourceLocationIdMeta,
        sourceLocationId.isAcceptableOrUnknown(
          data['source_location_id']!,
          _sourceLocationIdMeta,
        ),
      );
    }
    if (data.containsKey('destination_location_id')) {
      context.handle(
        _destinationLocationIdMeta,
        destinationLocationId.isAcceptableOrUnknown(
          data['destination_location_id']!,
          _destinationLocationIdMeta,
        ),
      );
    }
    if (data.containsKey('unit_cost_cents')) {
      context.handle(
        _unitCostCentsMeta,
        unitCostCents.isAcceptableOrUnknown(
          data['unit_cost_cents']!,
          _unitCostCentsMeta,
        ),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('purchase_order_id')) {
      context.handle(
        _purchaseOrderIdMeta,
        purchaseOrderId.isAcceptableOrUnknown(
          data['purchase_order_id']!,
          _purchaseOrderIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      )!,
      movementType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}movement_type'],
      )!,
      quantityDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_delta'],
      )!,
      sourceLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_location_id'],
      ),
      destinationLocationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_location_id'],
      ),
      unitCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_cents'],
      ),
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      purchaseOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_order_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final String id;
  final String componentId;
  final String movementType;
  final int quantityDelta;
  final String? sourceLocationId;
  final String? destinationLocationId;
  final int? unitCostCents;
  final String? projectId;
  final String? supplierId;
  final String? purchaseOrderId;
  final String? notes;
  final DateTime createdAt;
  const StockMovement({
    required this.id,
    required this.componentId,
    required this.movementType,
    required this.quantityDelta,
    this.sourceLocationId,
    this.destinationLocationId,
    this.unitCostCents,
    this.projectId,
    this.supplierId,
    this.purchaseOrderId,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['component_id'] = Variable<String>(componentId);
    map['movement_type'] = Variable<String>(movementType);
    map['quantity_delta'] = Variable<int>(quantityDelta);
    if (!nullToAbsent || sourceLocationId != null) {
      map['source_location_id'] = Variable<String>(sourceLocationId);
    }
    if (!nullToAbsent || destinationLocationId != null) {
      map['destination_location_id'] = Variable<String>(destinationLocationId);
    }
    if (!nullToAbsent || unitCostCents != null) {
      map['unit_cost_cents'] = Variable<int>(unitCostCents);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || purchaseOrderId != null) {
      map['purchase_order_id'] = Variable<String>(purchaseOrderId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      componentId: Value(componentId),
      movementType: Value(movementType),
      quantityDelta: Value(quantityDelta),
      sourceLocationId: sourceLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceLocationId),
      destinationLocationId: destinationLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationLocationId),
      unitCostCents: unitCostCents == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostCents),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      purchaseOrderId: purchaseOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseOrderId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory StockMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<String>(json['id']),
      componentId: serializer.fromJson<String>(json['componentId']),
      movementType: serializer.fromJson<String>(json['movementType']),
      quantityDelta: serializer.fromJson<int>(json['quantityDelta']),
      sourceLocationId: serializer.fromJson<String?>(json['sourceLocationId']),
      destinationLocationId: serializer.fromJson<String?>(
        json['destinationLocationId'],
      ),
      unitCostCents: serializer.fromJson<int?>(json['unitCostCents']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      purchaseOrderId: serializer.fromJson<String?>(json['purchaseOrderId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'componentId': serializer.toJson<String>(componentId),
      'movementType': serializer.toJson<String>(movementType),
      'quantityDelta': serializer.toJson<int>(quantityDelta),
      'sourceLocationId': serializer.toJson<String?>(sourceLocationId),
      'destinationLocationId': serializer.toJson<String?>(
        destinationLocationId,
      ),
      'unitCostCents': serializer.toJson<int?>(unitCostCents),
      'projectId': serializer.toJson<String?>(projectId),
      'supplierId': serializer.toJson<String?>(supplierId),
      'purchaseOrderId': serializer.toJson<String?>(purchaseOrderId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockMovement copyWith({
    String? id,
    String? componentId,
    String? movementType,
    int? quantityDelta,
    Value<String?> sourceLocationId = const Value.absent(),
    Value<String?> destinationLocationId = const Value.absent(),
    Value<int?> unitCostCents = const Value.absent(),
    Value<String?> projectId = const Value.absent(),
    Value<String?> supplierId = const Value.absent(),
    Value<String?> purchaseOrderId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => StockMovement(
    id: id ?? this.id,
    componentId: componentId ?? this.componentId,
    movementType: movementType ?? this.movementType,
    quantityDelta: quantityDelta ?? this.quantityDelta,
    sourceLocationId: sourceLocationId.present
        ? sourceLocationId.value
        : this.sourceLocationId,
    destinationLocationId: destinationLocationId.present
        ? destinationLocationId.value
        : this.destinationLocationId,
    unitCostCents: unitCostCents.present
        ? unitCostCents.value
        : this.unitCostCents,
    projectId: projectId.present ? projectId.value : this.projectId,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    purchaseOrderId: purchaseOrderId.present
        ? purchaseOrderId.value
        : this.purchaseOrderId,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      movementType: data.movementType.present
          ? data.movementType.value
          : this.movementType,
      quantityDelta: data.quantityDelta.present
          ? data.quantityDelta.value
          : this.quantityDelta,
      sourceLocationId: data.sourceLocationId.present
          ? data.sourceLocationId.value
          : this.sourceLocationId,
      destinationLocationId: data.destinationLocationId.present
          ? data.destinationLocationId.value
          : this.destinationLocationId,
      unitCostCents: data.unitCostCents.present
          ? data.unitCostCents.value
          : this.unitCostCents,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      purchaseOrderId: data.purchaseOrderId.present
          ? data.purchaseOrderId.value
          : this.purchaseOrderId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('movementType: $movementType, ')
          ..write('quantityDelta: $quantityDelta, ')
          ..write('sourceLocationId: $sourceLocationId, ')
          ..write('destinationLocationId: $destinationLocationId, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('projectId: $projectId, ')
          ..write('supplierId: $supplierId, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    componentId,
    movementType,
    quantityDelta,
    sourceLocationId,
    destinationLocationId,
    unitCostCents,
    projectId,
    supplierId,
    purchaseOrderId,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.componentId == this.componentId &&
          other.movementType == this.movementType &&
          other.quantityDelta == this.quantityDelta &&
          other.sourceLocationId == this.sourceLocationId &&
          other.destinationLocationId == this.destinationLocationId &&
          other.unitCostCents == this.unitCostCents &&
          other.projectId == this.projectId &&
          other.supplierId == this.supplierId &&
          other.purchaseOrderId == this.purchaseOrderId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<String> id;
  final Value<String> componentId;
  final Value<String> movementType;
  final Value<int> quantityDelta;
  final Value<String?> sourceLocationId;
  final Value<String?> destinationLocationId;
  final Value<int?> unitCostCents;
  final Value<String?> projectId;
  final Value<String?> supplierId;
  final Value<String?> purchaseOrderId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.componentId = const Value.absent(),
    this.movementType = const Value.absent(),
    this.quantityDelta = const Value.absent(),
    this.sourceLocationId = const Value.absent(),
    this.destinationLocationId = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.projectId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.purchaseOrderId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    required String id,
    required String componentId,
    required String movementType,
    required int quantityDelta,
    this.sourceLocationId = const Value.absent(),
    this.destinationLocationId = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.projectId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.purchaseOrderId = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       componentId = Value(componentId),
       movementType = Value(movementType),
       quantityDelta = Value(quantityDelta),
       createdAt = Value(createdAt);
  static Insertable<StockMovement> custom({
    Expression<String>? id,
    Expression<String>? componentId,
    Expression<String>? movementType,
    Expression<int>? quantityDelta,
    Expression<String>? sourceLocationId,
    Expression<String>? destinationLocationId,
    Expression<int>? unitCostCents,
    Expression<String>? projectId,
    Expression<String>? supplierId,
    Expression<String>? purchaseOrderId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (componentId != null) 'component_id': componentId,
      if (movementType != null) 'movement_type': movementType,
      if (quantityDelta != null) 'quantity_delta': quantityDelta,
      if (sourceLocationId != null) 'source_location_id': sourceLocationId,
      if (destinationLocationId != null)
        'destination_location_id': destinationLocationId,
      if (unitCostCents != null) 'unit_cost_cents': unitCostCents,
      if (projectId != null) 'project_id': projectId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (purchaseOrderId != null) 'purchase_order_id': purchaseOrderId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovementsCompanion copyWith({
    Value<String>? id,
    Value<String>? componentId,
    Value<String>? movementType,
    Value<int>? quantityDelta,
    Value<String?>? sourceLocationId,
    Value<String?>? destinationLocationId,
    Value<int?>? unitCostCents,
    Value<String?>? projectId,
    Value<String?>? supplierId,
    Value<String?>? purchaseOrderId,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      componentId: componentId ?? this.componentId,
      movementType: movementType ?? this.movementType,
      quantityDelta: quantityDelta ?? this.quantityDelta,
      sourceLocationId: sourceLocationId ?? this.sourceLocationId,
      destinationLocationId:
          destinationLocationId ?? this.destinationLocationId,
      unitCostCents: unitCostCents ?? this.unitCostCents,
      projectId: projectId ?? this.projectId,
      supplierId: supplierId ?? this.supplierId,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (movementType.present) {
      map['movement_type'] = Variable<String>(movementType.value);
    }
    if (quantityDelta.present) {
      map['quantity_delta'] = Variable<int>(quantityDelta.value);
    }
    if (sourceLocationId.present) {
      map['source_location_id'] = Variable<String>(sourceLocationId.value);
    }
    if (destinationLocationId.present) {
      map['destination_location_id'] = Variable<String>(
        destinationLocationId.value,
      );
    }
    if (unitCostCents.present) {
      map['unit_cost_cents'] = Variable<int>(unitCostCents.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (purchaseOrderId.present) {
      map['purchase_order_id'] = Variable<String>(purchaseOrderId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('movementType: $movementType, ')
          ..write('quantityDelta: $quantityDelta, ')
          ..write('sourceLocationId: $sourceLocationId, ')
          ..write('destinationLocationId: $destinationLocationId, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('projectId: $projectId, ')
          ..write('supplierId: $supplierId, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseOrderItemsTable extends PurchaseOrderItems
    with TableInfo<$PurchaseOrderItemsTable, PurchaseOrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseOrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseOrderIdMeta = const VerificationMeta(
    'purchaseOrderId',
  );
  @override
  late final GeneratedColumn<String> purchaseOrderId = GeneratedColumn<String>(
    'purchase_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase_orders (id)',
    ),
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id)',
    ),
  );
  static const VerificationMeta _orderedQuantityMeta = const VerificationMeta(
    'orderedQuantity',
  );
  @override
  late final GeneratedColumn<int> orderedQuantity = GeneratedColumn<int>(
    'ordered_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedQuantityMeta = const VerificationMeta(
    'receivedQuantity',
  );
  @override
  late final GeneratedColumn<int> receivedQuantity = GeneratedColumn<int>(
    'received_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _unitCostCentsMeta = const VerificationMeta(
    'unitCostCents',
  );
  @override
  late final GeneratedColumn<int> unitCostCents = GeneratedColumn<int>(
    'unit_cost_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _supplierPartNumberMeta =
      const VerificationMeta('supplierPartNumber');
  @override
  late final GeneratedColumn<String> supplierPartNumber =
      GeneratedColumn<String>(
        'supplier_part_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseOrderId,
    componentId,
    orderedQuantity,
    receivedQuantity,
    unitCostCents,
    supplierPartNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseOrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_order_id')) {
      context.handle(
        _purchaseOrderIdMeta,
        purchaseOrderId.isAcceptableOrUnknown(
          data['purchase_order_id']!,
          _purchaseOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseOrderIdMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentIdMeta);
    }
    if (data.containsKey('ordered_quantity')) {
      context.handle(
        _orderedQuantityMeta,
        orderedQuantity.isAcceptableOrUnknown(
          data['ordered_quantity']!,
          _orderedQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderedQuantityMeta);
    }
    if (data.containsKey('received_quantity')) {
      context.handle(
        _receivedQuantityMeta,
        receivedQuantity.isAcceptableOrUnknown(
          data['received_quantity']!,
          _receivedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('unit_cost_cents')) {
      context.handle(
        _unitCostCentsMeta,
        unitCostCents.isAcceptableOrUnknown(
          data['unit_cost_cents']!,
          _unitCostCentsMeta,
        ),
      );
    }
    if (data.containsKey('supplier_part_number')) {
      context.handle(
        _supplierPartNumberMeta,
        supplierPartNumber.isAcceptableOrUnknown(
          data['supplier_part_number']!,
          _supplierPartNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseOrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseOrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      purchaseOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_order_id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      )!,
      orderedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordered_quantity'],
      )!,
      receivedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}received_quantity'],
      )!,
      unitCostCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_cents'],
      )!,
      supplierPartNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_part_number'],
      ),
    );
  }

  @override
  $PurchaseOrderItemsTable createAlias(String alias) {
    return $PurchaseOrderItemsTable(attachedDatabase, alias);
  }
}

class PurchaseOrderItem extends DataClass
    implements Insertable<PurchaseOrderItem> {
  final String id;
  final String purchaseOrderId;
  final String componentId;
  final int orderedQuantity;
  final int receivedQuantity;
  final int unitCostCents;
  final String? supplierPartNumber;
  const PurchaseOrderItem({
    required this.id,
    required this.purchaseOrderId,
    required this.componentId,
    required this.orderedQuantity,
    required this.receivedQuantity,
    required this.unitCostCents,
    this.supplierPartNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_order_id'] = Variable<String>(purchaseOrderId);
    map['component_id'] = Variable<String>(componentId);
    map['ordered_quantity'] = Variable<int>(orderedQuantity);
    map['received_quantity'] = Variable<int>(receivedQuantity);
    map['unit_cost_cents'] = Variable<int>(unitCostCents);
    if (!nullToAbsent || supplierPartNumber != null) {
      map['supplier_part_number'] = Variable<String>(supplierPartNumber);
    }
    return map;
  }

  PurchaseOrderItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseOrderItemsCompanion(
      id: Value(id),
      purchaseOrderId: Value(purchaseOrderId),
      componentId: Value(componentId),
      orderedQuantity: Value(orderedQuantity),
      receivedQuantity: Value(receivedQuantity),
      unitCostCents: Value(unitCostCents),
      supplierPartNumber: supplierPartNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierPartNumber),
    );
  }

  factory PurchaseOrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseOrderItem(
      id: serializer.fromJson<String>(json['id']),
      purchaseOrderId: serializer.fromJson<String>(json['purchaseOrderId']),
      componentId: serializer.fromJson<String>(json['componentId']),
      orderedQuantity: serializer.fromJson<int>(json['orderedQuantity']),
      receivedQuantity: serializer.fromJson<int>(json['receivedQuantity']),
      unitCostCents: serializer.fromJson<int>(json['unitCostCents']),
      supplierPartNumber: serializer.fromJson<String?>(
        json['supplierPartNumber'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseOrderId': serializer.toJson<String>(purchaseOrderId),
      'componentId': serializer.toJson<String>(componentId),
      'orderedQuantity': serializer.toJson<int>(orderedQuantity),
      'receivedQuantity': serializer.toJson<int>(receivedQuantity),
      'unitCostCents': serializer.toJson<int>(unitCostCents),
      'supplierPartNumber': serializer.toJson<String?>(supplierPartNumber),
    };
  }

  PurchaseOrderItem copyWith({
    String? id,
    String? purchaseOrderId,
    String? componentId,
    int? orderedQuantity,
    int? receivedQuantity,
    int? unitCostCents,
    Value<String?> supplierPartNumber = const Value.absent(),
  }) => PurchaseOrderItem(
    id: id ?? this.id,
    purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
    componentId: componentId ?? this.componentId,
    orderedQuantity: orderedQuantity ?? this.orderedQuantity,
    receivedQuantity: receivedQuantity ?? this.receivedQuantity,
    unitCostCents: unitCostCents ?? this.unitCostCents,
    supplierPartNumber: supplierPartNumber.present
        ? supplierPartNumber.value
        : this.supplierPartNumber,
  );
  PurchaseOrderItem copyWithCompanion(PurchaseOrderItemsCompanion data) {
    return PurchaseOrderItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseOrderId: data.purchaseOrderId.present
          ? data.purchaseOrderId.value
          : this.purchaseOrderId,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      orderedQuantity: data.orderedQuantity.present
          ? data.orderedQuantity.value
          : this.orderedQuantity,
      receivedQuantity: data.receivedQuantity.present
          ? data.receivedQuantity.value
          : this.receivedQuantity,
      unitCostCents: data.unitCostCents.present
          ? data.unitCostCents.value
          : this.unitCostCents,
      supplierPartNumber: data.supplierPartNumber.present
          ? data.supplierPartNumber.value
          : this.supplierPartNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrderItem(')
          ..write('id: $id, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('componentId: $componentId, ')
          ..write('orderedQuantity: $orderedQuantity, ')
          ..write('receivedQuantity: $receivedQuantity, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('supplierPartNumber: $supplierPartNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchaseOrderId,
    componentId,
    orderedQuantity,
    receivedQuantity,
    unitCostCents,
    supplierPartNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseOrderItem &&
          other.id == this.id &&
          other.purchaseOrderId == this.purchaseOrderId &&
          other.componentId == this.componentId &&
          other.orderedQuantity == this.orderedQuantity &&
          other.receivedQuantity == this.receivedQuantity &&
          other.unitCostCents == this.unitCostCents &&
          other.supplierPartNumber == this.supplierPartNumber);
}

class PurchaseOrderItemsCompanion extends UpdateCompanion<PurchaseOrderItem> {
  final Value<String> id;
  final Value<String> purchaseOrderId;
  final Value<String> componentId;
  final Value<int> orderedQuantity;
  final Value<int> receivedQuantity;
  final Value<int> unitCostCents;
  final Value<String?> supplierPartNumber;
  final Value<int> rowid;
  const PurchaseOrderItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseOrderId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.orderedQuantity = const Value.absent(),
    this.receivedQuantity = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.supplierPartNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseOrderItemsCompanion.insert({
    required String id,
    required String purchaseOrderId,
    required String componentId,
    required int orderedQuantity,
    this.receivedQuantity = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.supplierPartNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       purchaseOrderId = Value(purchaseOrderId),
       componentId = Value(componentId),
       orderedQuantity = Value(orderedQuantity);
  static Insertable<PurchaseOrderItem> custom({
    Expression<String>? id,
    Expression<String>? purchaseOrderId,
    Expression<String>? componentId,
    Expression<int>? orderedQuantity,
    Expression<int>? receivedQuantity,
    Expression<int>? unitCostCents,
    Expression<String>? supplierPartNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseOrderId != null) 'purchase_order_id': purchaseOrderId,
      if (componentId != null) 'component_id': componentId,
      if (orderedQuantity != null) 'ordered_quantity': orderedQuantity,
      if (receivedQuantity != null) 'received_quantity': receivedQuantity,
      if (unitCostCents != null) 'unit_cost_cents': unitCostCents,
      if (supplierPartNumber != null)
        'supplier_part_number': supplierPartNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseOrderItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? purchaseOrderId,
    Value<String>? componentId,
    Value<int>? orderedQuantity,
    Value<int>? receivedQuantity,
    Value<int>? unitCostCents,
    Value<String?>? supplierPartNumber,
    Value<int>? rowid,
  }) {
    return PurchaseOrderItemsCompanion(
      id: id ?? this.id,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      componentId: componentId ?? this.componentId,
      orderedQuantity: orderedQuantity ?? this.orderedQuantity,
      receivedQuantity: receivedQuantity ?? this.receivedQuantity,
      unitCostCents: unitCostCents ?? this.unitCostCents,
      supplierPartNumber: supplierPartNumber ?? this.supplierPartNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseOrderId.present) {
      map['purchase_order_id'] = Variable<String>(purchaseOrderId.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (orderedQuantity.present) {
      map['ordered_quantity'] = Variable<int>(orderedQuantity.value);
    }
    if (receivedQuantity.present) {
      map['received_quantity'] = Variable<int>(receivedQuantity.value);
    }
    if (unitCostCents.present) {
      map['unit_cost_cents'] = Variable<int>(unitCostCents.value);
    }
    if (supplierPartNumber.present) {
      map['supplier_part_number'] = Variable<String>(supplierPartNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseOrderId: $purchaseOrderId, ')
          ..write('componentId: $componentId, ')
          ..write('orderedQuantity: $orderedQuantity, ')
          ..write('receivedQuantity: $receivedQuantity, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('supplierPartNumber: $supplierPartNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectBomsTable extends ProjectBoms
    with TableInfo<$ProjectBomsTable, ProjectBom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectBomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id)',
    ),
  );
  static const VerificationMeta _quantityRequiredMeta = const VerificationMeta(
    'quantityRequired',
  );
  @override
  late final GeneratedColumn<int> quantityRequired = GeneratedColumn<int>(
    'quantity_required',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    componentId,
    quantityRequired,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_boms';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectBom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentIdMeta);
    }
    if (data.containsKey('quantity_required')) {
      context.handle(
        _quantityRequiredMeta,
        quantityRequired.isAcceptableOrUnknown(
          data['quantity_required']!,
          _quantityRequiredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityRequiredMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {projectId, componentId},
  ];
  @override
  ProjectBom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectBom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      )!,
      quantityRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity_required'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ProjectBomsTable createAlias(String alias) {
    return $ProjectBomsTable(attachedDatabase, alias);
  }
}

class ProjectBom extends DataClass implements Insertable<ProjectBom> {
  final String id;
  final String projectId;
  final String componentId;
  final int quantityRequired;
  final String? notes;
  const ProjectBom({
    required this.id,
    required this.projectId,
    required this.componentId,
    required this.quantityRequired,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['component_id'] = Variable<String>(componentId);
    map['quantity_required'] = Variable<int>(quantityRequired);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ProjectBomsCompanion toCompanion(bool nullToAbsent) {
    return ProjectBomsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      componentId: Value(componentId),
      quantityRequired: Value(quantityRequired),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ProjectBom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectBom(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      componentId: serializer.fromJson<String>(json['componentId']),
      quantityRequired: serializer.fromJson<int>(json['quantityRequired']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'componentId': serializer.toJson<String>(componentId),
      'quantityRequired': serializer.toJson<int>(quantityRequired),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ProjectBom copyWith({
    String? id,
    String? projectId,
    String? componentId,
    int? quantityRequired,
    Value<String?> notes = const Value.absent(),
  }) => ProjectBom(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    componentId: componentId ?? this.componentId,
    quantityRequired: quantityRequired ?? this.quantityRequired,
    notes: notes.present ? notes.value : this.notes,
  );
  ProjectBom copyWithCompanion(ProjectBomsCompanion data) {
    return ProjectBom(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      quantityRequired: data.quantityRequired.present
          ? data.quantityRequired.value
          : this.quantityRequired,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectBom(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('componentId: $componentId, ')
          ..write('quantityRequired: $quantityRequired, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, componentId, quantityRequired, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectBom &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.componentId == this.componentId &&
          other.quantityRequired == this.quantityRequired &&
          other.notes == this.notes);
}

class ProjectBomsCompanion extends UpdateCompanion<ProjectBom> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> componentId;
  final Value<int> quantityRequired;
  final Value<String?> notes;
  final Value<int> rowid;
  const ProjectBomsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.quantityRequired = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectBomsCompanion.insert({
    required String id,
    required String projectId,
    required String componentId,
    required int quantityRequired,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       componentId = Value(componentId),
       quantityRequired = Value(quantityRequired);
  static Insertable<ProjectBom> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? componentId,
    Expression<int>? quantityRequired,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (componentId != null) 'component_id': componentId,
      if (quantityRequired != null) 'quantity_required': quantityRequired,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectBomsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? componentId,
    Value<int>? quantityRequired,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ProjectBomsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      componentId: componentId ?? this.componentId,
      quantityRequired: quantityRequired ?? this.quantityRequired,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (quantityRequired.present) {
      map['quantity_required'] = Variable<int>(quantityRequired.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectBomsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('componentId: $componentId, ')
          ..write('quantityRequired: $quantityRequired, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StocktakeSessionsTable extends StocktakeSessions
    with TableInfo<$StocktakeSessionsTable, StocktakeSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StocktakeSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationId,
    status,
    startedAt,
    completedAt,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stocktake_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StocktakeSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StocktakeSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StocktakeSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $StocktakeSessionsTable createAlias(String alias) {
    return $StocktakeSessionsTable(attachedDatabase, alias);
  }
}

class StocktakeSession extends DataClass
    implements Insertable<StocktakeSession> {
  final String id;
  final String? locationId;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? notes;
  const StocktakeSession({
    required this.id,
    this.locationId,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  StocktakeSessionsCompanion toCompanion(bool nullToAbsent) {
    return StocktakeSessionsCompanion(
      id: Value(id),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      status: Value(status),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory StocktakeSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StocktakeSession(
      id: serializer.fromJson<String>(json['id']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locationId': serializer.toJson<String?>(locationId),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  StocktakeSession copyWith({
    String? id,
    Value<String?> locationId = const Value.absent(),
    String? status,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => StocktakeSession(
    id: id ?? this.id,
    locationId: locationId.present ? locationId.value : this.locationId,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    notes: notes.present ? notes.value : this.notes,
  );
  StocktakeSession copyWithCompanion(StocktakeSessionsCompanion data) {
    return StocktakeSession(
      id: data.id.present ? data.id.value : this.id,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StocktakeSession(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, locationId, status, startedAt, completedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StocktakeSession &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes);
}

class StocktakeSessionsCompanion extends UpdateCompanion<StocktakeSession> {
  final Value<String> id;
  final Value<String?> locationId;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String?> notes;
  final Value<int> rowid;
  const StocktakeSessionsCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StocktakeSessionsCompanion.insert({
    required String id,
    this.locationId = const Value.absent(),
    required String status,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<StocktakeSession> custom({
    Expression<String>? id,
    Expression<String>? locationId,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StocktakeSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? locationId,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return StocktakeSessionsCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StocktakeSessionsCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StocktakeEntriesTable extends StocktakeEntries
    with TableInfo<$StocktakeEntriesTable, StocktakeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StocktakeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stocktake_sessions (id)',
    ),
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id)',
    ),
  );
  static const VerificationMeta _expectedQuantityMeta = const VerificationMeta(
    'expectedQuantity',
  );
  @override
  late final GeneratedColumn<int> expectedQuantity = GeneratedColumn<int>(
    'expected_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countedQuantityMeta = const VerificationMeta(
    'countedQuantity',
  );
  @override
  late final GeneratedColumn<int> countedQuantity = GeneratedColumn<int>(
    'counted_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reconciledMeta = const VerificationMeta(
    'reconciled',
  );
  @override
  late final GeneratedColumn<bool> reconciled = GeneratedColumn<bool>(
    'reconciled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reconciled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    componentId,
    expectedQuantity,
    countedQuantity,
    reconciled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stocktake_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<StocktakeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentIdMeta);
    }
    if (data.containsKey('expected_quantity')) {
      context.handle(
        _expectedQuantityMeta,
        expectedQuantity.isAcceptableOrUnknown(
          data['expected_quantity']!,
          _expectedQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedQuantityMeta);
    }
    if (data.containsKey('counted_quantity')) {
      context.handle(
        _countedQuantityMeta,
        countedQuantity.isAcceptableOrUnknown(
          data['counted_quantity']!,
          _countedQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countedQuantityMeta);
    }
    if (data.containsKey('reconciled')) {
      context.handle(
        _reconciledMeta,
        reconciled.isAcceptableOrUnknown(data['reconciled']!, _reconciledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StocktakeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StocktakeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      )!,
      expectedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_quantity'],
      )!,
      countedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counted_quantity'],
      )!,
      reconciled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reconciled'],
      )!,
    );
  }

  @override
  $StocktakeEntriesTable createAlias(String alias) {
    return $StocktakeEntriesTable(attachedDatabase, alias);
  }
}

class StocktakeEntry extends DataClass implements Insertable<StocktakeEntry> {
  final String id;
  final String sessionId;
  final String componentId;
  final int expectedQuantity;
  final int countedQuantity;
  final bool reconciled;
  const StocktakeEntry({
    required this.id,
    required this.sessionId,
    required this.componentId,
    required this.expectedQuantity,
    required this.countedQuantity,
    required this.reconciled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['component_id'] = Variable<String>(componentId);
    map['expected_quantity'] = Variable<int>(expectedQuantity);
    map['counted_quantity'] = Variable<int>(countedQuantity);
    map['reconciled'] = Variable<bool>(reconciled);
    return map;
  }

  StocktakeEntriesCompanion toCompanion(bool nullToAbsent) {
    return StocktakeEntriesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      componentId: Value(componentId),
      expectedQuantity: Value(expectedQuantity),
      countedQuantity: Value(countedQuantity),
      reconciled: Value(reconciled),
    );
  }

  factory StocktakeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StocktakeEntry(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      componentId: serializer.fromJson<String>(json['componentId']),
      expectedQuantity: serializer.fromJson<int>(json['expectedQuantity']),
      countedQuantity: serializer.fromJson<int>(json['countedQuantity']),
      reconciled: serializer.fromJson<bool>(json['reconciled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'componentId': serializer.toJson<String>(componentId),
      'expectedQuantity': serializer.toJson<int>(expectedQuantity),
      'countedQuantity': serializer.toJson<int>(countedQuantity),
      'reconciled': serializer.toJson<bool>(reconciled),
    };
  }

  StocktakeEntry copyWith({
    String? id,
    String? sessionId,
    String? componentId,
    int? expectedQuantity,
    int? countedQuantity,
    bool? reconciled,
  }) => StocktakeEntry(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    componentId: componentId ?? this.componentId,
    expectedQuantity: expectedQuantity ?? this.expectedQuantity,
    countedQuantity: countedQuantity ?? this.countedQuantity,
    reconciled: reconciled ?? this.reconciled,
  );
  StocktakeEntry copyWithCompanion(StocktakeEntriesCompanion data) {
    return StocktakeEntry(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      expectedQuantity: data.expectedQuantity.present
          ? data.expectedQuantity.value
          : this.expectedQuantity,
      countedQuantity: data.countedQuantity.present
          ? data.countedQuantity.value
          : this.countedQuantity,
      reconciled: data.reconciled.present
          ? data.reconciled.value
          : this.reconciled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StocktakeEntry(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('componentId: $componentId, ')
          ..write('expectedQuantity: $expectedQuantity, ')
          ..write('countedQuantity: $countedQuantity, ')
          ..write('reconciled: $reconciled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    componentId,
    expectedQuantity,
    countedQuantity,
    reconciled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StocktakeEntry &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.componentId == this.componentId &&
          other.expectedQuantity == this.expectedQuantity &&
          other.countedQuantity == this.countedQuantity &&
          other.reconciled == this.reconciled);
}

class StocktakeEntriesCompanion extends UpdateCompanion<StocktakeEntry> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> componentId;
  final Value<int> expectedQuantity;
  final Value<int> countedQuantity;
  final Value<bool> reconciled;
  final Value<int> rowid;
  const StocktakeEntriesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.expectedQuantity = const Value.absent(),
    this.countedQuantity = const Value.absent(),
    this.reconciled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StocktakeEntriesCompanion.insert({
    required String id,
    required String sessionId,
    required String componentId,
    required int expectedQuantity,
    required int countedQuantity,
    this.reconciled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       componentId = Value(componentId),
       expectedQuantity = Value(expectedQuantity),
       countedQuantity = Value(countedQuantity);
  static Insertable<StocktakeEntry> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? componentId,
    Expression<int>? expectedQuantity,
    Expression<int>? countedQuantity,
    Expression<bool>? reconciled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (componentId != null) 'component_id': componentId,
      if (expectedQuantity != null) 'expected_quantity': expectedQuantity,
      if (countedQuantity != null) 'counted_quantity': countedQuantity,
      if (reconciled != null) 'reconciled': reconciled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StocktakeEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? componentId,
    Value<int>? expectedQuantity,
    Value<int>? countedQuantity,
    Value<bool>? reconciled,
    Value<int>? rowid,
  }) {
    return StocktakeEntriesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      componentId: componentId ?? this.componentId,
      expectedQuantity: expectedQuantity ?? this.expectedQuantity,
      countedQuantity: countedQuantity ?? this.countedQuantity,
      reconciled: reconciled ?? this.reconciled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (expectedQuantity.present) {
      map['expected_quantity'] = Variable<int>(expectedQuantity.value);
    }
    if (countedQuantity.present) {
      map['counted_quantity'] = Variable<int>(countedQuantity.value);
    }
    if (reconciled.present) {
      map['reconciled'] = Variable<bool>(reconciled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StocktakeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('componentId: $componentId, ')
          ..write('expectedQuantity: $expectedQuantity, ')
          ..write('countedQuantity: $countedQuantity, ')
          ..write('reconciled: $reconciled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ComponentsTable components = $ComponentsTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $InventoryBalancesTable inventoryBalances =
      $InventoryBalancesTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $PurchaseOrdersTable purchaseOrders = $PurchaseOrdersTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $PurchaseOrderItemsTable purchaseOrderItems =
      $PurchaseOrderItemsTable(this);
  late final $ProjectBomsTable projectBoms = $ProjectBomsTable(this);
  late final $StocktakeSessionsTable stocktakeSessions =
      $StocktakeSessionsTable(this);
  late final $StocktakeEntriesTable stocktakeEntries = $StocktakeEntriesTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    components,
    locations,
    inventoryBalances,
    projects,
    suppliers,
    purchaseOrders,
    stockMovements,
    purchaseOrderItems,
    projectBoms,
    stocktakeSessions,
    stocktakeEntries,
    appSettings,
  ];
}

typedef $$ComponentsTableCreateCompanionBuilder =
    ComponentsCompanion Function({
      required String id,
      required String name,
      required String category,
      Value<String?> manufacturer,
      Value<String?> manufacturerPartNumber,
      Value<String?> internalSku,
      Value<String?> description,
      Value<String?> packageFootprint,
      Value<String?> datasheetUrl,
      Value<String?> tags,
      Value<int> minStockThreshold,
      Value<int?> targetStockQuantity,
      Value<String?> defaultSupplierId,
      Value<String> unitOfMeasure,
      Value<int?> unitCostCents,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$ComponentsTableUpdateCompanionBuilder =
    ComponentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<String?> manufacturer,
      Value<String?> manufacturerPartNumber,
      Value<String?> internalSku,
      Value<String?> description,
      Value<String?> packageFootprint,
      Value<String?> datasheetUrl,
      Value<String?> tags,
      Value<int> minStockThreshold,
      Value<int?> targetStockQuantity,
      Value<String?> defaultSupplierId,
      Value<String> unitOfMeasure,
      Value<int?> unitCostCents,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$ComponentsTableReferences
    extends BaseReferences<_$AppDatabase, $ComponentsTable, Component> {
  $$ComponentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryBalancesTable, List<InventoryBalance>>
  _inventoryBalancesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inventoryBalances,
        aliasName: 'components__id__inventory_balances__component_id',
      );

  $$InventoryBalancesTableProcessedTableManager get inventoryBalancesRefs {
    final manager = $$InventoryBalancesTableTableManager(
      $_db,
      $_db.inventoryBalances,
    ).filter((f) => f.componentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inventoryBalancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'components__id__stock_movements__component_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.componentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchaseOrderItemsTable, List<PurchaseOrderItem>>
  _purchaseOrderItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.purchaseOrderItems,
        aliasName: 'components__id__purchase_order_items__component_id',
      );

  $$PurchaseOrderItemsTableProcessedTableManager get purchaseOrderItemsRefs {
    final manager = $$PurchaseOrderItemsTableTableManager(
      $_db,
      $_db.purchaseOrderItems,
    ).filter((f) => f.componentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _purchaseOrderItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectBomsTable, List<ProjectBom>>
  _projectBomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projectBoms,
    aliasName: 'components__id__project_boms__component_id',
  );

  $$ProjectBomsTableProcessedTableManager get projectBomsRefs {
    final manager = $$ProjectBomsTableTableManager(
      $_db,
      $_db.projectBoms,
    ).filter((f) => f.componentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectBomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StocktakeEntriesTable, List<StocktakeEntry>>
  _stocktakeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stocktakeEntries,
    aliasName: 'components__id__stocktake_entries__component_id',
  );

  $$StocktakeEntriesTableProcessedTableManager get stocktakeEntriesRefs {
    final manager = $$StocktakeEntriesTableTableManager(
      $_db,
      $_db.stocktakeEntries,
    ).filter((f) => f.componentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stocktakeEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ComponentsTableFilterComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturerPartNumber => $composableBuilder(
    column: $table.manufacturerPartNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get internalSku => $composableBuilder(
    column: $table.internalSku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageFootprint => $composableBuilder(
    column: $table.packageFootprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datasheetUrl => $composableBuilder(
    column: $table.datasheetUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minStockThreshold => $composableBuilder(
    column: $table.minStockThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetStockQuantity => $composableBuilder(
    column: $table.targetStockQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultSupplierId => $composableBuilder(
    column: $table.defaultSupplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitOfMeasure => $composableBuilder(
    column: $table.unitOfMeasure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostCents => $composableBuilder(
    column: $table.unitCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> inventoryBalancesRefs(
    Expression<bool> Function($$InventoryBalancesTableFilterComposer f) f,
  ) {
    final $$InventoryBalancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryBalances,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryBalancesTableFilterComposer(
            $db: $db,
            $table: $db.inventoryBalances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchaseOrderItemsRefs(
    Expression<bool> Function($$PurchaseOrderItemsTableFilterComposer f) f,
  ) {
    final $$PurchaseOrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseOrderItems,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectBomsRefs(
    Expression<bool> Function($$ProjectBomsTableFilterComposer f) f,
  ) {
    final $$ProjectBomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectBoms,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectBomsTableFilterComposer(
            $db: $db,
            $table: $db.projectBoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stocktakeEntriesRefs(
    Expression<bool> Function($$StocktakeEntriesTableFilterComposer f) f,
  ) {
    final $$StocktakeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stocktakeEntries,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocktakeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.stocktakeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComponentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturerPartNumber => $composableBuilder(
    column: $table.manufacturerPartNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get internalSku => $composableBuilder(
    column: $table.internalSku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageFootprint => $composableBuilder(
    column: $table.packageFootprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datasheetUrl => $composableBuilder(
    column: $table.datasheetUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minStockThreshold => $composableBuilder(
    column: $table.minStockThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetStockQuantity => $composableBuilder(
    column: $table.targetStockQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultSupplierId => $composableBuilder(
    column: $table.defaultSupplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitOfMeasure => $composableBuilder(
    column: $table.unitOfMeasure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostCents => $composableBuilder(
    column: $table.unitCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComponentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manufacturerPartNumber => $composableBuilder(
    column: $table.manufacturerPartNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get internalSku => $composableBuilder(
    column: $table.internalSku,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get packageFootprint => $composableBuilder(
    column: $table.packageFootprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get datasheetUrl => $composableBuilder(
    column: $table.datasheetUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get minStockThreshold => $composableBuilder(
    column: $table.minStockThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetStockQuantity => $composableBuilder(
    column: $table.targetStockQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultSupplierId => $composableBuilder(
    column: $table.defaultSupplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitOfMeasure => $composableBuilder(
    column: $table.unitOfMeasure,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitCostCents => $composableBuilder(
    column: $table.unitCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> inventoryBalancesRefs<T extends Object>(
    Expression<T> Function($$InventoryBalancesTableAnnotationComposer a) f,
  ) {
    final $$InventoryBalancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryBalances,
          getReferencedColumn: (t) => t.componentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryBalancesTableAnnotationComposer(
                $db: $db,
                $table: $db.inventoryBalances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchaseOrderItemsRefs<T extends Object>(
    Expression<T> Function($$PurchaseOrderItemsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseOrderItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.purchaseOrderItems,
          getReferencedColumn: (t) => t.componentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PurchaseOrderItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.purchaseOrderItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> projectBomsRefs<T extends Object>(
    Expression<T> Function($$ProjectBomsTableAnnotationComposer a) f,
  ) {
    final $$ProjectBomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectBoms,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectBomsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectBoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stocktakeEntriesRefs<T extends Object>(
    Expression<T> Function($$StocktakeEntriesTableAnnotationComposer a) f,
  ) {
    final $$StocktakeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stocktakeEntries,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocktakeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.stocktakeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComponentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComponentsTable,
          Component,
          $$ComponentsTableFilterComposer,
          $$ComponentsTableOrderingComposer,
          $$ComponentsTableAnnotationComposer,
          $$ComponentsTableCreateCompanionBuilder,
          $$ComponentsTableUpdateCompanionBuilder,
          (Component, $$ComponentsTableReferences),
          Component,
          PrefetchHooks Function({
            bool inventoryBalancesRefs,
            bool stockMovementsRefs,
            bool purchaseOrderItemsRefs,
            bool projectBomsRefs,
            bool stocktakeEntriesRefs,
          })
        > {
  $$ComponentsTableTableManager(_$AppDatabase db, $ComponentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComponentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComponentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComponentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> manufacturerPartNumber = const Value.absent(),
                Value<String?> internalSku = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> packageFootprint = const Value.absent(),
                Value<String?> datasheetUrl = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> minStockThreshold = const Value.absent(),
                Value<int?> targetStockQuantity = const Value.absent(),
                Value<String?> defaultSupplierId = const Value.absent(),
                Value<String> unitOfMeasure = const Value.absent(),
                Value<int?> unitCostCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentsCompanion(
                id: id,
                name: name,
                category: category,
                manufacturer: manufacturer,
                manufacturerPartNumber: manufacturerPartNumber,
                internalSku: internalSku,
                description: description,
                packageFootprint: packageFootprint,
                datasheetUrl: datasheetUrl,
                tags: tags,
                minStockThreshold: minStockThreshold,
                targetStockQuantity: targetStockQuantity,
                defaultSupplierId: defaultSupplierId,
                unitOfMeasure: unitOfMeasure,
                unitCostCents: unitCostCents,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> manufacturerPartNumber = const Value.absent(),
                Value<String?> internalSku = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> packageFootprint = const Value.absent(),
                Value<String?> datasheetUrl = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> minStockThreshold = const Value.absent(),
                Value<int?> targetStockQuantity = const Value.absent(),
                Value<String?> defaultSupplierId = const Value.absent(),
                Value<String> unitOfMeasure = const Value.absent(),
                Value<int?> unitCostCents = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComponentsCompanion.insert(
                id: id,
                name: name,
                category: category,
                manufacturer: manufacturer,
                manufacturerPartNumber: manufacturerPartNumber,
                internalSku: internalSku,
                description: description,
                packageFootprint: packageFootprint,
                datasheetUrl: datasheetUrl,
                tags: tags,
                minStockThreshold: minStockThreshold,
                targetStockQuantity: targetStockQuantity,
                defaultSupplierId: defaultSupplierId,
                unitOfMeasure: unitOfMeasure,
                unitCostCents: unitCostCents,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ComponentsTable, Component>(table),
                  $$ComponentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                inventoryBalancesRefs = false,
                stockMovementsRefs = false,
                purchaseOrderItemsRefs = false,
                projectBomsRefs = false,
                stocktakeEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inventoryBalancesRefs) db.inventoryBalances,
                    if (stockMovementsRefs) db.stockMovements,
                    if (purchaseOrderItemsRefs) db.purchaseOrderItems,
                    if (projectBomsRefs) db.projectBoms,
                    if (stocktakeEntriesRefs) db.stocktakeEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inventoryBalancesRefs)
                        await $_getPrefetchedDataByColumns<
                          Component,
                          $ComponentsTable,
                          InventoryBalance,
                          $InventoryBalancesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ComponentsTableReferences
                              ._inventoryBalancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ComponentsTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoryBalancesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'component_id',
                          typedResults: items,
                        ),
                      if (stockMovementsRefs)
                        await $_getPrefetchedDataByColumns<
                          Component,
                          $ComponentsTable,
                          StockMovement,
                          $StockMovementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ComponentsTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ComponentsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'component_id',
                          typedResults: items,
                        ),
                      if (purchaseOrderItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          Component,
                          $ComponentsTable,
                          PurchaseOrderItem,
                          $PurchaseOrderItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ComponentsTableReferences
                              ._purchaseOrderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ComponentsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseOrderItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'component_id',
                          typedResults: items,
                        ),
                      if (projectBomsRefs)
                        await $_getPrefetchedDataByColumns<
                          Component,
                          $ComponentsTable,
                          ProjectBom,
                          $ProjectBomsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ComponentsTableReferences
                              ._projectBomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ComponentsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectBomsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'component_id',
                          typedResults: items,
                        ),
                      if (stocktakeEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          Component,
                          $ComponentsTable,
                          StocktakeEntry,
                          $StocktakeEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ComponentsTableReferences
                              ._stocktakeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ComponentsTableReferences(
                                db,
                                table,
                                p0,
                              ).stocktakeEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'component_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComponentsTable,
      Component,
      $$ComponentsTableFilterComposer,
      $$ComponentsTableOrderingComposer,
      $$ComponentsTableAnnotationComposer,
      $$ComponentsTableCreateCompanionBuilder,
      $$ComponentsTableUpdateCompanionBuilder,
      (Component, $$ComponentsTableReferences),
      Component,
      PrefetchHooks Function({
        bool inventoryBalancesRefs,
        bool stockMovementsRefs,
        bool purchaseOrderItemsRefs,
        bool projectBomsRefs,
        bool stocktakeEntriesRefs,
      })
    >;
typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({
      required String id,
      required String name,
      Value<String?> parentId,
      Value<String?> code,
      Value<String?> description,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentId,
      Value<String?> code,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$LocationsTableReferences
    extends BaseReferences<_$AppDatabase, $LocationsTable, Location> {
  $$LocationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryBalancesTable, List<InventoryBalance>>
  _inventoryBalancesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.inventoryBalances,
        aliasName: 'locations__id__inventory_balances__location_id',
      );

  $$InventoryBalancesTableProcessedTableManager get inventoryBalancesRefs {
    final manager = $$InventoryBalancesTableTableManager(
      $_db,
      $_db.inventoryBalances,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inventoryBalancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _sourceStockMovementsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'locations__id__stock_movements__source_location_id',
  );

  $$StockMovementsTableProcessedTableManager get sourceStockMovements {
    final manager = $$StockMovementsTableTableManager($_db, $_db.stockMovements)
        .filter(
          (f) => f.sourceLocationId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _sourceStockMovementsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _destinationStockMovementsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.stockMovements,
        aliasName: 'locations__id__stock_movements__destination_location_id',
      );

  $$StockMovementsTableProcessedTableManager get destinationStockMovements {
    final manager = $$StockMovementsTableTableManager($_db, $_db.stockMovements)
        .filter(
          (f) =>
              f.destinationLocationId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _destinationStockMovementsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StocktakeSessionsTable, List<StocktakeSession>>
  _stocktakeSessionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.stocktakeSessions,
        aliasName: 'locations__id__stocktake_sessions__location_id',
      );

  $$StocktakeSessionsTableProcessedTableManager get stocktakeSessionsRefs {
    final manager = $$StocktakeSessionsTableTableManager(
      $_db,
      $_db.stocktakeSessions,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stocktakeSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> inventoryBalancesRefs(
    Expression<bool> Function($$InventoryBalancesTableFilterComposer f) f,
  ) {
    final $$InventoryBalancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryBalances,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryBalancesTableFilterComposer(
            $db: $db,
            $table: $db.inventoryBalances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceStockMovements(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.sourceLocationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> destinationStockMovements(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.destinationLocationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stocktakeSessionsRefs(
    Expression<bool> Function($$StocktakeSessionsTableFilterComposer f) f,
  ) {
    final $$StocktakeSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stocktakeSessions,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocktakeSessionsTableFilterComposer(
            $db: $db,
            $table: $db.stocktakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> inventoryBalancesRefs<T extends Object>(
    Expression<T> Function($$InventoryBalancesTableAnnotationComposer a) f,
  ) {
    final $$InventoryBalancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.inventoryBalances,
          getReferencedColumn: (t) => t.locationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InventoryBalancesTableAnnotationComposer(
                $db: $db,
                $table: $db.inventoryBalances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sourceStockMovements<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.sourceLocationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> destinationStockMovements<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.destinationLocationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stocktakeSessionsRefs<T extends Object>(
    Expression<T> Function($$StocktakeSessionsTableAnnotationComposer a) f,
  ) {
    final $$StocktakeSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.stocktakeSessions,
          getReferencedColumn: (t) => t.locationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StocktakeSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.stocktakeSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationsTable,
          Location,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (Location, $$LocationsTableReferences),
          Location,
          PrefetchHooks Function({
            bool inventoryBalancesRefs,
            bool sourceStockMovements,
            bool destinationStockMovements,
            bool stocktakeSessionsRefs,
          })
        > {
  $$LocationsTableTableManager(_$AppDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion(
                id: id,
                name: name,
                parentId: parentId,
                code: code,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentId = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                code: code,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocationsTable, Location>(table),
                  $$LocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                inventoryBalancesRefs = false,
                sourceStockMovements = false,
                destinationStockMovements = false,
                stocktakeSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inventoryBalancesRefs) db.inventoryBalances,
                    if (sourceStockMovements) db.stockMovements,
                    if (destinationStockMovements) db.stockMovements,
                    if (stocktakeSessionsRefs) db.stocktakeSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inventoryBalancesRefs)
                        await $_getPrefetchedDataByColumns<
                          Location,
                          $LocationsTable,
                          InventoryBalance,
                          $InventoryBalancesTable
                        >(
                          currentTable: table,
                          referencedTable: $$LocationsTableReferences
                              ._inventoryBalancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocationsTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoryBalancesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'location_id',
                          typedResults: items,
                        ),
                      if (sourceStockMovements)
                        await $_getPrefetchedDataByColumns<
                          Location,
                          $LocationsTable,
                          StockMovement,
                          $StockMovementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LocationsTableReferences
                              ._sourceStockMovementsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocationsTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceStockMovements,
                          currentColumn: 'id',
                          referencedColumn: 'source_location_id',
                          typedResults: items,
                        ),
                      if (destinationStockMovements)
                        await $_getPrefetchedDataByColumns<
                          Location,
                          $LocationsTable,
                          StockMovement,
                          $StockMovementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LocationsTableReferences
                              ._destinationStockMovementsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocationsTableReferences(
                                db,
                                table,
                                p0,
                              ).destinationStockMovements,
                          currentColumn: 'id',
                          referencedColumn: 'destination_location_id',
                          typedResults: items,
                        ),
                      if (stocktakeSessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Location,
                          $LocationsTable,
                          StocktakeSession,
                          $StocktakeSessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LocationsTableReferences
                              ._stocktakeSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocationsTableReferences(
                                db,
                                table,
                                p0,
                              ).stocktakeSessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'location_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationsTable,
      Location,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (Location, $$LocationsTableReferences),
      Location,
      PrefetchHooks Function({
        bool inventoryBalancesRefs,
        bool sourceStockMovements,
        bool destinationStockMovements,
        bool stocktakeSessionsRefs,
      })
    >;
typedef $$InventoryBalancesTableCreateCompanionBuilder =
    InventoryBalancesCompanion Function({
      required String id,
      required String componentId,
      required String locationId,
      Value<int> quantity,
      Value<int> rowid,
    });
typedef $$InventoryBalancesTableUpdateCompanionBuilder =
    InventoryBalancesCompanion Function({
      Value<String> id,
      Value<String> componentId,
      Value<String> locationId,
      Value<int> quantity,
      Value<int> rowid,
    });

final class $$InventoryBalancesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InventoryBalancesTable,
          InventoryBalance
        > {
  $$InventoryBalancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ComponentsTable _componentIdTable(_$AppDatabase db) => db.components
      .createAlias('inventory_balances__component_id__components__id');

  $$ComponentsTableProcessedTableManager get componentId {
    final $_column = $_itemColumn<String>('component_id')!;

    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationsTable _locationIdTable(_$AppDatabase db) => db.locations
      .createAlias('inventory_balances__location_id__locations__id');

  $$LocationsTableProcessedTableManager get locationId {
    final $_column = $_itemColumn<String>('location_id')!;

    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InventoryBalancesTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryBalancesTable> {
  $$InventoryBalancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  $$ComponentsTableFilterComposer get componentId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryBalancesTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryBalancesTable> {
  $$InventoryBalancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  $$ComponentsTableOrderingComposer get componentId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryBalancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryBalancesTable> {
  $$InventoryBalancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$ComponentsTableAnnotationComposer get componentId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryBalancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryBalancesTable,
          InventoryBalance,
          $$InventoryBalancesTableFilterComposer,
          $$InventoryBalancesTableOrderingComposer,
          $$InventoryBalancesTableAnnotationComposer,
          $$InventoryBalancesTableCreateCompanionBuilder,
          $$InventoryBalancesTableUpdateCompanionBuilder,
          (InventoryBalance, $$InventoryBalancesTableReferences),
          InventoryBalance,
          PrefetchHooks Function({bool componentId, bool locationId})
        > {
  $$InventoryBalancesTableTableManager(
    _$AppDatabase db,
    $InventoryBalancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryBalancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryBalancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryBalancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> componentId = const Value.absent(),
                Value<String> locationId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryBalancesCompanion(
                id: id,
                componentId: componentId,
                locationId: locationId,
                quantity: quantity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String componentId,
                required String locationId,
                Value<int> quantity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryBalancesCompanion.insert(
                id: id,
                componentId: componentId,
                locationId: locationId,
                quantity: quantity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InventoryBalancesTable, InventoryBalance>(table),
                  $$InventoryBalancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({componentId = false, locationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (componentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.componentId,
                                referencedTable:
                                    $$InventoryBalancesTableReferences
                                        ._componentIdTable(db),
                                referencedColumn:
                                    $$InventoryBalancesTableReferences
                                        ._componentIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (locationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.locationId,
                                referencedTable:
                                    $$InventoryBalancesTableReferences
                                        ._locationIdTable(db),
                                referencedColumn:
                                    $$InventoryBalancesTableReferences
                                        ._locationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InventoryBalancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryBalancesTable,
      InventoryBalance,
      $$InventoryBalancesTableFilterComposer,
      $$InventoryBalancesTableOrderingComposer,
      $$InventoryBalancesTableAnnotationComposer,
      $$InventoryBalancesTableCreateCompanionBuilder,
      $$InventoryBalancesTableUpdateCompanionBuilder,
      (InventoryBalance, $$InventoryBalancesTableReferences),
      InventoryBalance,
      PrefetchHooks Function({bool componentId, bool locationId})
    >;
typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String> status,
      Value<DateTime?> targetDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> status,
      Value<DateTime?> targetDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'projects__id__stock_movements__project_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectBomsTable, List<ProjectBom>>
  _projectBomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projectBoms,
    aliasName: 'projects__id__project_boms__project_id',
  );

  $$ProjectBomsTableProcessedTableManager get projectBomsRefs {
    final manager = $$ProjectBomsTableTableManager(
      $_db,
      $_db.projectBoms,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectBomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectBomsRefs(
    Expression<bool> Function($$ProjectBomsTableFilterComposer f) f,
  ) {
    final $$ProjectBomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectBoms,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectBomsTableFilterComposer(
            $db: $db,
            $table: $db.projectBoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectBomsRefs<T extends Object>(
    Expression<T> Function($$ProjectBomsTableAnnotationComposer a) f,
  ) {
    final $$ProjectBomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectBoms,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectBomsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectBoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({
            bool stockMovementsRefs,
            bool projectBomsRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                description: description,
                status: status,
                targetDate: targetDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                description: description,
                status: status,
                targetDate: targetDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectsTable, Project>(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({stockMovementsRefs = false, projectBomsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stockMovementsRefs) db.stockMovements,
                    if (projectBomsRefs) db.projectBoms,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stockMovementsRefs)
                        await $_getPrefetchedDataByColumns<
                          Project,
                          $ProjectsTable,
                          StockMovement,
                          $StockMovementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'project_id',
                          typedResults: items,
                        ),
                      if (projectBomsRefs)
                        await $_getPrefetchedDataByColumns<
                          Project,
                          $ProjectsTable,
                          ProjectBom,
                          $ProjectBomsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectBomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectBomsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'project_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool stockMovementsRefs, bool projectBomsRefs})
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      required String id,
      required String name,
      Value<String?> website,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> notes,
      required DateTime createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> website,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchaseOrdersTable, List<PurchaseOrder>>
  _purchaseOrdersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseOrders,
    aliasName: 'suppliers__id__purchase_orders__supplier_id',
  );

  $$PurchaseOrdersTableProcessedTableManager get purchaseOrdersRefs {
    final manager = $$PurchaseOrdersTableTableManager(
      $_db,
      $_db.purchaseOrders,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseOrdersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'suppliers__id__stock_movements__supplier_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> purchaseOrdersRefs(
    Expression<bool> Function($$PurchaseOrdersTableFilterComposer f) f,
  ) {
    final $$PurchaseOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableFilterComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> purchaseOrdersRefs<T extends Object>(
    Expression<T> Function($$PurchaseOrdersTableAnnotationComposer a) f,
  ) {
    final $$PurchaseOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, $$SuppliersTableReferences),
          Supplier,
          PrefetchHooks Function({
            bool purchaseOrdersRefs,
            bool stockMovementsRefs,
          })
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                name: name,
                website: website,
                email: email,
                phone: phone,
                notes: notes,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> website = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                name: name,
                website: website,
                email: email,
                phone: phone,
                notes: notes,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SuppliersTable, Supplier>(table),
                  $$SuppliersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({purchaseOrdersRefs = false, stockMovementsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (purchaseOrdersRefs) db.purchaseOrders,
                    if (stockMovementsRefs) db.stockMovements,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (purchaseOrdersRefs)
                        await $_getPrefetchedDataByColumns<
                          Supplier,
                          $SuppliersTable,
                          PurchaseOrder,
                          $PurchaseOrdersTable
                        >(
                          currentTable: table,
                          referencedTable: $$SuppliersTableReferences
                              ._purchaseOrdersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SuppliersTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseOrdersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'supplier_id',
                          typedResults: items,
                        ),
                      if (stockMovementsRefs)
                        await $_getPrefetchedDataByColumns<
                          Supplier,
                          $SuppliersTable,
                          StockMovement,
                          $StockMovementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SuppliersTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SuppliersTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'supplier_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, $$SuppliersTableReferences),
      Supplier,
      PrefetchHooks Function({bool purchaseOrdersRefs, bool stockMovementsRefs})
    >;
typedef $$PurchaseOrdersTableCreateCompanionBuilder =
    PurchaseOrdersCompanion Function({
      required String id,
      required String orderNumber,
      Value<String?> supplierId,
      required DateTime orderDate,
      Value<DateTime?> expectedArrivalDate,
      required String status,
      Value<String> currency,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PurchaseOrdersTableUpdateCompanionBuilder =
    PurchaseOrdersCompanion Function({
      Value<String> id,
      Value<String> orderNumber,
      Value<String?> supplierId,
      Value<DateTime> orderDate,
      Value<DateTime?> expectedArrivalDate,
      Value<String> status,
      Value<String> currency,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PurchaseOrdersTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseOrdersTable, PurchaseOrder> {
  $$PurchaseOrdersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias('purchase_orders__supplier_id__suppliers__id');

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<String>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'purchase_orders__id__stock_movements__purchase_order_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager($_db, $_db.stockMovements)
        .filter(
          (f) => f.purchaseOrderId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchaseOrderItemsTable, List<PurchaseOrderItem>>
  _purchaseOrderItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.purchaseOrderItems,
        aliasName:
            'purchase_orders__id__purchase_order_items__purchase_order_id',
      );

  $$PurchaseOrderItemsTableProcessedTableManager get purchaseOrderItemsRefs {
    final manager =
        $$PurchaseOrderItemsTableTableManager(
          $_db,
          $_db.purchaseOrderItems,
        ).filter(
          (f) => f.purchaseOrderId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _purchaseOrderItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PurchaseOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseOrdersTable> {
  $$PurchaseOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get orderDate => $composableBuilder(
    column: $table.orderDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expectedArrivalDate => $composableBuilder(
    column: $table.expectedArrivalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.purchaseOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchaseOrderItemsRefs(
    Expression<bool> Function($$PurchaseOrderItemsTableFilterComposer f) f,
  ) {
    final $$PurchaseOrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseOrderItems,
      getReferencedColumn: (t) => t.purchaseOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseOrderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchaseOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseOrdersTable> {
  $$PurchaseOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get orderDate => $composableBuilder(
    column: $table.orderDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expectedArrivalDate => $composableBuilder(
    column: $table.expectedArrivalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseOrdersTable> {
  $$PurchaseOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get orderDate =>
      $composableBuilder(column: $table.orderDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expectedArrivalDate => $composableBuilder(
    column: $table.expectedArrivalDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.purchaseOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchaseOrderItemsRefs<T extends Object>(
    Expression<T> Function($$PurchaseOrderItemsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseOrderItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.purchaseOrderItems,
          getReferencedColumn: (t) => t.purchaseOrderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PurchaseOrderItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.purchaseOrderItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PurchaseOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseOrdersTable,
          PurchaseOrder,
          $$PurchaseOrdersTableFilterComposer,
          $$PurchaseOrdersTableOrderingComposer,
          $$PurchaseOrdersTableAnnotationComposer,
          $$PurchaseOrdersTableCreateCompanionBuilder,
          $$PurchaseOrdersTableUpdateCompanionBuilder,
          (PurchaseOrder, $$PurchaseOrdersTableReferences),
          PurchaseOrder,
          PrefetchHooks Function({
            bool supplierId,
            bool stockMovementsRefs,
            bool purchaseOrderItemsRefs,
          })
        > {
  $$PurchaseOrdersTableTableManager(
    _$AppDatabase db,
    $PurchaseOrdersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderNumber = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<DateTime> orderDate = const Value.absent(),
                Value<DateTime?> expectedArrivalDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrdersCompanion(
                id: id,
                orderNumber: orderNumber,
                supplierId: supplierId,
                orderDate: orderDate,
                expectedArrivalDate: expectedArrivalDate,
                status: status,
                currency: currency,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderNumber,
                Value<String?> supplierId = const Value.absent(),
                required DateTime orderDate,
                Value<DateTime?> expectedArrivalDate = const Value.absent(),
                required String status,
                Value<String> currency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrdersCompanion.insert(
                id: id,
                orderNumber: orderNumber,
                supplierId: supplierId,
                orderDate: orderDate,
                expectedArrivalDate: expectedArrivalDate,
                status: status,
                currency: currency,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchaseOrdersTable, PurchaseOrder>(table),
                  $$PurchaseOrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                supplierId = false,
                stockMovementsRefs = false,
                purchaseOrderItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stockMovementsRefs) db.stockMovements,
                    if (purchaseOrderItemsRefs) db.purchaseOrderItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (supplierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.supplierId,
                                    referencedTable:
                                        $$PurchaseOrdersTableReferences
                                            ._supplierIdTable(db),
                                    referencedColumn:
                                        $$PurchaseOrdersTableReferences
                                            ._supplierIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stockMovementsRefs)
                        await $_getPrefetchedDataByColumns<
                          PurchaseOrder,
                          $PurchaseOrdersTable,
                          StockMovement,
                          $StockMovementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PurchaseOrdersTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PurchaseOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'purchase_order_id',
                          typedResults: items,
                        ),
                      if (purchaseOrderItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          PurchaseOrder,
                          $PurchaseOrdersTable,
                          PurchaseOrderItem,
                          $PurchaseOrderItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PurchaseOrdersTableReferences
                              ._purchaseOrderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PurchaseOrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseOrderItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'purchase_order_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PurchaseOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseOrdersTable,
      PurchaseOrder,
      $$PurchaseOrdersTableFilterComposer,
      $$PurchaseOrdersTableOrderingComposer,
      $$PurchaseOrdersTableAnnotationComposer,
      $$PurchaseOrdersTableCreateCompanionBuilder,
      $$PurchaseOrdersTableUpdateCompanionBuilder,
      (PurchaseOrder, $$PurchaseOrdersTableReferences),
      PurchaseOrder,
      PrefetchHooks Function({
        bool supplierId,
        bool stockMovementsRefs,
        bool purchaseOrderItemsRefs,
      })
    >;
typedef $$StockMovementsTableCreateCompanionBuilder =
    StockMovementsCompanion Function({
      required String id,
      required String componentId,
      required String movementType,
      required int quantityDelta,
      Value<String?> sourceLocationId,
      Value<String?> destinationLocationId,
      Value<int?> unitCostCents,
      Value<String?> projectId,
      Value<String?> supplierId,
      Value<String?> purchaseOrderId,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StockMovementsTableUpdateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<String> id,
      Value<String> componentId,
      Value<String> movementType,
      Value<int> quantityDelta,
      Value<String?> sourceLocationId,
      Value<String?> destinationLocationId,
      Value<int?> unitCostCents,
      Value<String?> projectId,
      Value<String?> supplierId,
      Value<String?> purchaseOrderId,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StockMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement> {
  $$StockMovementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ComponentsTable _componentIdTable(_$AppDatabase db) => db.components
      .createAlias('stock_movements__component_id__components__id');

  $$ComponentsTableProcessedTableManager get componentId {
    final $_column = $_itemColumn<String>('component_id')!;

    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationsTable _sourceLocationIdTable(_$AppDatabase db) => db
      .locations
      .createAlias('stock_movements__source_location_id__locations__id');

  $$LocationsTableProcessedTableManager? get sourceLocationId {
    final $_column = $_itemColumn<String>('source_location_id');
    if ($_column == null) return null;
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceLocationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationsTable _destinationLocationIdTable(_$AppDatabase db) => db
      .locations
      .createAlias('stock_movements__destination_location_id__locations__id');

  $$LocationsTableProcessedTableManager? get destinationLocationId {
    final $_column = $_itemColumn<String>('destination_location_id');
    if ($_column == null) return null;
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _destinationLocationIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('stock_movements__project_id__projects__id');

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias('stock_movements__supplier_id__suppliers__id');

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<String>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PurchaseOrdersTable _purchaseOrderIdTable(_$AppDatabase db) => db
      .purchaseOrders
      .createAlias('stock_movements__purchase_order_id__purchase_orders__id');

  $$PurchaseOrdersTableProcessedTableManager? get purchaseOrderId {
    final $_column = $_itemColumn<String>('purchase_order_id');
    if ($_column == null) return null;
    final manager = $$PurchaseOrdersTableTableManager(
      $_db,
      $_db.purchaseOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityDelta => $composableBuilder(
    column: $table.quantityDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostCents => $composableBuilder(
    column: $table.unitCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ComponentsTableFilterComposer get componentId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableFilterComposer get sourceLocationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceLocationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableFilterComposer get destinationLocationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationLocationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchaseOrdersTableFilterComposer get purchaseOrderId {
    final $$PurchaseOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableFilterComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityDelta => $composableBuilder(
    column: $table.quantityDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostCents => $composableBuilder(
    column: $table.unitCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ComponentsTableOrderingComposer get componentId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableOrderingComposer get sourceLocationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceLocationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableOrderingComposer get destinationLocationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationLocationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchaseOrdersTableOrderingComposer get purchaseOrderId {
    final $$PurchaseOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantityDelta => $composableBuilder(
    column: $table.quantityDelta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitCostCents => $composableBuilder(
    column: $table.unitCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ComponentsTableAnnotationComposer get componentId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableAnnotationComposer get sourceLocationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceLocationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableAnnotationComposer get destinationLocationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationLocationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchaseOrdersTableAnnotationComposer get purchaseOrderId {
    final $$PurchaseOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovementsTable,
          StockMovement,
          $$StockMovementsTableFilterComposer,
          $$StockMovementsTableOrderingComposer,
          $$StockMovementsTableAnnotationComposer,
          $$StockMovementsTableCreateCompanionBuilder,
          $$StockMovementsTableUpdateCompanionBuilder,
          (StockMovement, $$StockMovementsTableReferences),
          StockMovement,
          PrefetchHooks Function({
            bool componentId,
            bool sourceLocationId,
            bool destinationLocationId,
            bool projectId,
            bool supplierId,
            bool purchaseOrderId,
          })
        > {
  $$StockMovementsTableTableManager(
    _$AppDatabase db,
    $StockMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> componentId = const Value.absent(),
                Value<String> movementType = const Value.absent(),
                Value<int> quantityDelta = const Value.absent(),
                Value<String?> sourceLocationId = const Value.absent(),
                Value<String?> destinationLocationId = const Value.absent(),
                Value<int?> unitCostCents = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> purchaseOrderId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion(
                id: id,
                componentId: componentId,
                movementType: movementType,
                quantityDelta: quantityDelta,
                sourceLocationId: sourceLocationId,
                destinationLocationId: destinationLocationId,
                unitCostCents: unitCostCents,
                projectId: projectId,
                supplierId: supplierId,
                purchaseOrderId: purchaseOrderId,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String componentId,
                required String movementType,
                required int quantityDelta,
                Value<String?> sourceLocationId = const Value.absent(),
                Value<String?> destinationLocationId = const Value.absent(),
                Value<int?> unitCostCents = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> purchaseOrderId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion.insert(
                id: id,
                componentId: componentId,
                movementType: movementType,
                quantityDelta: quantityDelta,
                sourceLocationId: sourceLocationId,
                destinationLocationId: destinationLocationId,
                unitCostCents: unitCostCents,
                projectId: projectId,
                supplierId: supplierId,
                purchaseOrderId: purchaseOrderId,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StockMovementsTable, StockMovement>(table),
                  $$StockMovementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                componentId = false,
                sourceLocationId = false,
                destinationLocationId = false,
                projectId = false,
                supplierId = false,
                purchaseOrderId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (componentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.componentId,
                                    referencedTable:
                                        $$StockMovementsTableReferences
                                            ._componentIdTable(db),
                                    referencedColumn:
                                        $$StockMovementsTableReferences
                                            ._componentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceLocationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceLocationId,
                                    referencedTable:
                                        $$StockMovementsTableReferences
                                            ._sourceLocationIdTable(db),
                                    referencedColumn:
                                        $$StockMovementsTableReferences
                                            ._sourceLocationIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (destinationLocationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.destinationLocationId,
                                    referencedTable:
                                        $$StockMovementsTableReferences
                                            ._destinationLocationIdTable(db),
                                    referencedColumn:
                                        $$StockMovementsTableReferences
                                            ._destinationLocationIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$StockMovementsTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$StockMovementsTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (supplierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.supplierId,
                                    referencedTable:
                                        $$StockMovementsTableReferences
                                            ._supplierIdTable(db),
                                    referencedColumn:
                                        $$StockMovementsTableReferences
                                            ._supplierIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (purchaseOrderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.purchaseOrderId,
                                    referencedTable:
                                        $$StockMovementsTableReferences
                                            ._purchaseOrderIdTable(db),
                                    referencedColumn:
                                        $$StockMovementsTableReferences
                                            ._purchaseOrderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$StockMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovementsTable,
      StockMovement,
      $$StockMovementsTableFilterComposer,
      $$StockMovementsTableOrderingComposer,
      $$StockMovementsTableAnnotationComposer,
      $$StockMovementsTableCreateCompanionBuilder,
      $$StockMovementsTableUpdateCompanionBuilder,
      (StockMovement, $$StockMovementsTableReferences),
      StockMovement,
      PrefetchHooks Function({
        bool componentId,
        bool sourceLocationId,
        bool destinationLocationId,
        bool projectId,
        bool supplierId,
        bool purchaseOrderId,
      })
    >;
typedef $$PurchaseOrderItemsTableCreateCompanionBuilder =
    PurchaseOrderItemsCompanion Function({
      required String id,
      required String purchaseOrderId,
      required String componentId,
      required int orderedQuantity,
      Value<int> receivedQuantity,
      Value<int> unitCostCents,
      Value<String?> supplierPartNumber,
      Value<int> rowid,
    });
typedef $$PurchaseOrderItemsTableUpdateCompanionBuilder =
    PurchaseOrderItemsCompanion Function({
      Value<String> id,
      Value<String> purchaseOrderId,
      Value<String> componentId,
      Value<int> orderedQuantity,
      Value<int> receivedQuantity,
      Value<int> unitCostCents,
      Value<String?> supplierPartNumber,
      Value<int> rowid,
    });

final class $$PurchaseOrderItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PurchaseOrderItemsTable,
          PurchaseOrderItem
        > {
  $$PurchaseOrderItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PurchaseOrdersTable _purchaseOrderIdTable(_$AppDatabase db) =>
      db.purchaseOrders.createAlias(
        'purchase_order_items__purchase_order_id__purchase_orders__id',
      );

  $$PurchaseOrdersTableProcessedTableManager get purchaseOrderId {
    final $_column = $_itemColumn<String>('purchase_order_id')!;

    final manager = $$PurchaseOrdersTableTableManager(
      $_db,
      $_db.purchaseOrders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ComponentsTable _componentIdTable(_$AppDatabase db) => db.components
      .createAlias('purchase_order_items__component_id__components__id');

  $$ComponentsTableProcessedTableManager get componentId {
    final $_column = $_itemColumn<String>('component_id')!;

    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PurchaseOrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseOrderItemsTable> {
  $$PurchaseOrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderedQuantity => $composableBuilder(
    column: $table.orderedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receivedQuantity => $composableBuilder(
    column: $table.receivedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostCents => $composableBuilder(
    column: $table.unitCostCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierPartNumber => $composableBuilder(
    column: $table.supplierPartNumber,
    builder: (column) => ColumnFilters(column),
  );

  $$PurchaseOrdersTableFilterComposer get purchaseOrderId {
    final $$PurchaseOrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableFilterComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableFilterComposer get componentId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseOrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseOrderItemsTable> {
  $$PurchaseOrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderedQuantity => $composableBuilder(
    column: $table.orderedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receivedQuantity => $composableBuilder(
    column: $table.receivedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostCents => $composableBuilder(
    column: $table.unitCostCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierPartNumber => $composableBuilder(
    column: $table.supplierPartNumber,
    builder: (column) => ColumnOrderings(column),
  );

  $$PurchaseOrdersTableOrderingComposer get purchaseOrderId {
    final $$PurchaseOrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableOrderingComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableOrderingComposer get componentId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseOrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseOrderItemsTable> {
  $$PurchaseOrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderedQuantity => $composableBuilder(
    column: $table.orderedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receivedQuantity => $composableBuilder(
    column: $table.receivedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitCostCents => $composableBuilder(
    column: $table.unitCostCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierPartNumber => $composableBuilder(
    column: $table.supplierPartNumber,
    builder: (column) => column,
  );

  $$PurchaseOrdersTableAnnotationComposer get purchaseOrderId {
    final $$PurchaseOrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseOrderId,
      referencedTable: $db.purchaseOrders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseOrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseOrders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableAnnotationComposer get componentId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseOrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseOrderItemsTable,
          PurchaseOrderItem,
          $$PurchaseOrderItemsTableFilterComposer,
          $$PurchaseOrderItemsTableOrderingComposer,
          $$PurchaseOrderItemsTableAnnotationComposer,
          $$PurchaseOrderItemsTableCreateCompanionBuilder,
          $$PurchaseOrderItemsTableUpdateCompanionBuilder,
          (PurchaseOrderItem, $$PurchaseOrderItemsTableReferences),
          PurchaseOrderItem,
          PrefetchHooks Function({bool purchaseOrderId, bool componentId})
        > {
  $$PurchaseOrderItemsTableTableManager(
    _$AppDatabase db,
    $PurchaseOrderItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseOrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseOrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseOrderItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> purchaseOrderId = const Value.absent(),
                Value<String> componentId = const Value.absent(),
                Value<int> orderedQuantity = const Value.absent(),
                Value<int> receivedQuantity = const Value.absent(),
                Value<int> unitCostCents = const Value.absent(),
                Value<String?> supplierPartNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrderItemsCompanion(
                id: id,
                purchaseOrderId: purchaseOrderId,
                componentId: componentId,
                orderedQuantity: orderedQuantity,
                receivedQuantity: receivedQuantity,
                unitCostCents: unitCostCents,
                supplierPartNumber: supplierPartNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String purchaseOrderId,
                required String componentId,
                required int orderedQuantity,
                Value<int> receivedQuantity = const Value.absent(),
                Value<int> unitCostCents = const Value.absent(),
                Value<String?> supplierPartNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrderItemsCompanion.insert(
                id: id,
                purchaseOrderId: purchaseOrderId,
                componentId: componentId,
                orderedQuantity: orderedQuantity,
                receivedQuantity: receivedQuantity,
                unitCostCents: unitCostCents,
                supplierPartNumber: supplierPartNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchaseOrderItemsTable, PurchaseOrderItem>(
                    table,
                  ),
                  $$PurchaseOrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({purchaseOrderId = false, componentId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (purchaseOrderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.purchaseOrderId,
                                    referencedTable:
                                        $$PurchaseOrderItemsTableReferences
                                            ._purchaseOrderIdTable(db),
                                    referencedColumn:
                                        $$PurchaseOrderItemsTableReferences
                                            ._purchaseOrderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (componentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.componentId,
                                    referencedTable:
                                        $$PurchaseOrderItemsTableReferences
                                            ._componentIdTable(db),
                                    referencedColumn:
                                        $$PurchaseOrderItemsTableReferences
                                            ._componentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PurchaseOrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseOrderItemsTable,
      PurchaseOrderItem,
      $$PurchaseOrderItemsTableFilterComposer,
      $$PurchaseOrderItemsTableOrderingComposer,
      $$PurchaseOrderItemsTableAnnotationComposer,
      $$PurchaseOrderItemsTableCreateCompanionBuilder,
      $$PurchaseOrderItemsTableUpdateCompanionBuilder,
      (PurchaseOrderItem, $$PurchaseOrderItemsTableReferences),
      PurchaseOrderItem,
      PrefetchHooks Function({bool purchaseOrderId, bool componentId})
    >;
typedef $$ProjectBomsTableCreateCompanionBuilder =
    ProjectBomsCompanion Function({
      required String id,
      required String projectId,
      required String componentId,
      required int quantityRequired,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$ProjectBomsTableUpdateCompanionBuilder =
    ProjectBomsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> componentId,
      Value<int> quantityRequired,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$ProjectBomsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectBomsTable, ProjectBom> {
  $$ProjectBomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('project_boms__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ComponentsTable _componentIdTable(_$AppDatabase db) =>
      db.components.createAlias('project_boms__component_id__components__id');

  $$ComponentsTableProcessedTableManager get componentId {
    final $_column = $_itemColumn<String>('component_id')!;

    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectBomsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectBomsTable> {
  $$ProjectBomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantityRequired => $composableBuilder(
    column: $table.quantityRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableFilterComposer get componentId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectBomsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectBomsTable> {
  $$ProjectBomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityRequired => $composableBuilder(
    column: $table.quantityRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableOrderingComposer get componentId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectBomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectBomsTable> {
  $$ProjectBomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantityRequired => $composableBuilder(
    column: $table.quantityRequired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableAnnotationComposer get componentId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectBomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectBomsTable,
          ProjectBom,
          $$ProjectBomsTableFilterComposer,
          $$ProjectBomsTableOrderingComposer,
          $$ProjectBomsTableAnnotationComposer,
          $$ProjectBomsTableCreateCompanionBuilder,
          $$ProjectBomsTableUpdateCompanionBuilder,
          (ProjectBom, $$ProjectBomsTableReferences),
          ProjectBom,
          PrefetchHooks Function({bool projectId, bool componentId})
        > {
  $$ProjectBomsTableTableManager(_$AppDatabase db, $ProjectBomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectBomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectBomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectBomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> componentId = const Value.absent(),
                Value<int> quantityRequired = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectBomsCompanion(
                id: id,
                projectId: projectId,
                componentId: componentId,
                quantityRequired: quantityRequired,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String componentId,
                required int quantityRequired,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectBomsCompanion.insert(
                id: id,
                projectId: projectId,
                componentId: componentId,
                quantityRequired: quantityRequired,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectBomsTable, ProjectBom>(table),
                  $$ProjectBomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, componentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$ProjectBomsTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$ProjectBomsTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (componentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.componentId,
                                referencedTable: $$ProjectBomsTableReferences
                                    ._componentIdTable(db),
                                referencedColumn: $$ProjectBomsTableReferences
                                    ._componentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProjectBomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectBomsTable,
      ProjectBom,
      $$ProjectBomsTableFilterComposer,
      $$ProjectBomsTableOrderingComposer,
      $$ProjectBomsTableAnnotationComposer,
      $$ProjectBomsTableCreateCompanionBuilder,
      $$ProjectBomsTableUpdateCompanionBuilder,
      (ProjectBom, $$ProjectBomsTableReferences),
      ProjectBom,
      PrefetchHooks Function({bool projectId, bool componentId})
    >;
typedef $$StocktakeSessionsTableCreateCompanionBuilder =
    StocktakeSessionsCompanion Function({
      required String id,
      Value<String?> locationId,
      required String status,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$StocktakeSessionsTableUpdateCompanionBuilder =
    StocktakeSessionsCompanion Function({
      Value<String> id,
      Value<String?> locationId,
      Value<String> status,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$StocktakeSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StocktakeSessionsTable,
          StocktakeSession
        > {
  $$StocktakeSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LocationsTable _locationIdTable(_$AppDatabase db) => db.locations
      .createAlias('stocktake_sessions__location_id__locations__id');

  $$LocationsTableProcessedTableManager? get locationId {
    final $_column = $_itemColumn<String>('location_id');
    if ($_column == null) return null;
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StocktakeEntriesTable, List<StocktakeEntry>>
  _stocktakeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stocktakeEntries,
    aliasName: 'stocktake_sessions__id__stocktake_entries__session_id',
  );

  $$StocktakeEntriesTableProcessedTableManager get stocktakeEntriesRefs {
    final manager = $$StocktakeEntriesTableTableManager(
      $_db,
      $_db.stocktakeEntries,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stocktakeEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StocktakeSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $StocktakeSessionsTable> {
  $$StocktakeSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stocktakeEntriesRefs(
    Expression<bool> Function($$StocktakeEntriesTableFilterComposer f) f,
  ) {
    final $$StocktakeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stocktakeEntries,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocktakeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.stocktakeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StocktakeSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StocktakeSessionsTable> {
  $$StocktakeSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocktakeSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StocktakeSessionsTable> {
  $$StocktakeSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stocktakeEntriesRefs<T extends Object>(
    Expression<T> Function($$StocktakeEntriesTableAnnotationComposer a) f,
  ) {
    final $$StocktakeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stocktakeEntries,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocktakeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.stocktakeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StocktakeSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StocktakeSessionsTable,
          StocktakeSession,
          $$StocktakeSessionsTableFilterComposer,
          $$StocktakeSessionsTableOrderingComposer,
          $$StocktakeSessionsTableAnnotationComposer,
          $$StocktakeSessionsTableCreateCompanionBuilder,
          $$StocktakeSessionsTableUpdateCompanionBuilder,
          (StocktakeSession, $$StocktakeSessionsTableReferences),
          StocktakeSession,
          PrefetchHooks Function({bool locationId, bool stocktakeEntriesRefs})
        > {
  $$StocktakeSessionsTableTableManager(
    _$AppDatabase db,
    $StocktakeSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StocktakeSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StocktakeSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StocktakeSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> locationId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StocktakeSessionsCompanion(
                id: id,
                locationId: locationId,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> locationId = const Value.absent(),
                required String status,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StocktakeSessionsCompanion.insert(
                id: id,
                locationId: locationId,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StocktakeSessionsTable, StocktakeSession>(table),
                  $$StocktakeSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({locationId = false, stocktakeEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stocktakeEntriesRefs) db.stocktakeEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (locationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.locationId,
                                    referencedTable:
                                        $$StocktakeSessionsTableReferences
                                            ._locationIdTable(db),
                                    referencedColumn:
                                        $$StocktakeSessionsTableReferences
                                            ._locationIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stocktakeEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          StocktakeSession,
                          $StocktakeSessionsTable,
                          StocktakeEntry,
                          $StocktakeEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$StocktakeSessionsTableReferences
                              ._stocktakeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StocktakeSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).stocktakeEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StocktakeSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StocktakeSessionsTable,
      StocktakeSession,
      $$StocktakeSessionsTableFilterComposer,
      $$StocktakeSessionsTableOrderingComposer,
      $$StocktakeSessionsTableAnnotationComposer,
      $$StocktakeSessionsTableCreateCompanionBuilder,
      $$StocktakeSessionsTableUpdateCompanionBuilder,
      (StocktakeSession, $$StocktakeSessionsTableReferences),
      StocktakeSession,
      PrefetchHooks Function({bool locationId, bool stocktakeEntriesRefs})
    >;
typedef $$StocktakeEntriesTableCreateCompanionBuilder =
    StocktakeEntriesCompanion Function({
      required String id,
      required String sessionId,
      required String componentId,
      required int expectedQuantity,
      required int countedQuantity,
      Value<bool> reconciled,
      Value<int> rowid,
    });
typedef $$StocktakeEntriesTableUpdateCompanionBuilder =
    StocktakeEntriesCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> componentId,
      Value<int> expectedQuantity,
      Value<int> countedQuantity,
      Value<bool> reconciled,
      Value<int> rowid,
    });

final class $$StocktakeEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $StocktakeEntriesTable, StocktakeEntry> {
  $$StocktakeEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StocktakeSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .stocktakeSessions
      .createAlias('stocktake_entries__session_id__stocktake_sessions__id');

  $$StocktakeSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$StocktakeSessionsTableTableManager(
      $_db,
      $_db.stocktakeSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ComponentsTable _componentIdTable(_$AppDatabase db) => db.components
      .createAlias('stocktake_entries__component_id__components__id');

  $$ComponentsTableProcessedTableManager get componentId {
    final $_column = $_itemColumn<String>('component_id')!;

    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StocktakeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $StocktakeEntriesTable> {
  $$StocktakeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedQuantity => $composableBuilder(
    column: $table.expectedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countedQuantity => $composableBuilder(
    column: $table.countedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reconciled => $composableBuilder(
    column: $table.reconciled,
    builder: (column) => ColumnFilters(column),
  );

  $$StocktakeSessionsTableFilterComposer get sessionId {
    final $$StocktakeSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.stocktakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocktakeSessionsTableFilterComposer(
            $db: $db,
            $table: $db.stocktakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableFilterComposer get componentId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocktakeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StocktakeEntriesTable> {
  $$StocktakeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedQuantity => $composableBuilder(
    column: $table.expectedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countedQuantity => $composableBuilder(
    column: $table.countedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reconciled => $composableBuilder(
    column: $table.reconciled,
    builder: (column) => ColumnOrderings(column),
  );

  $$StocktakeSessionsTableOrderingComposer get sessionId {
    final $$StocktakeSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.stocktakeSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocktakeSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.stocktakeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableOrderingComposer get componentId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocktakeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StocktakeEntriesTable> {
  $$StocktakeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get expectedQuantity => $composableBuilder(
    column: $table.expectedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get countedQuantity => $composableBuilder(
    column: $table.countedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reconciled => $composableBuilder(
    column: $table.reconciled,
    builder: (column) => column,
  );

  $$StocktakeSessionsTableAnnotationComposer get sessionId {
    final $$StocktakeSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.stocktakeSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StocktakeSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.stocktakeSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ComponentsTableAnnotationComposer get componentId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StocktakeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StocktakeEntriesTable,
          StocktakeEntry,
          $$StocktakeEntriesTableFilterComposer,
          $$StocktakeEntriesTableOrderingComposer,
          $$StocktakeEntriesTableAnnotationComposer,
          $$StocktakeEntriesTableCreateCompanionBuilder,
          $$StocktakeEntriesTableUpdateCompanionBuilder,
          (StocktakeEntry, $$StocktakeEntriesTableReferences),
          StocktakeEntry,
          PrefetchHooks Function({bool sessionId, bool componentId})
        > {
  $$StocktakeEntriesTableTableManager(
    _$AppDatabase db,
    $StocktakeEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StocktakeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StocktakeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StocktakeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> componentId = const Value.absent(),
                Value<int> expectedQuantity = const Value.absent(),
                Value<int> countedQuantity = const Value.absent(),
                Value<bool> reconciled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StocktakeEntriesCompanion(
                id: id,
                sessionId: sessionId,
                componentId: componentId,
                expectedQuantity: expectedQuantity,
                countedQuantity: countedQuantity,
                reconciled: reconciled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String componentId,
                required int expectedQuantity,
                required int countedQuantity,
                Value<bool> reconciled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StocktakeEntriesCompanion.insert(
                id: id,
                sessionId: sessionId,
                componentId: componentId,
                expectedQuantity: expectedQuantity,
                countedQuantity: countedQuantity,
                reconciled: reconciled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StocktakeEntriesTable, StocktakeEntry>(table),
                  $$StocktakeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, componentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$StocktakeEntriesTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$StocktakeEntriesTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (componentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.componentId,
                                referencedTable:
                                    $$StocktakeEntriesTableReferences
                                        ._componentIdTable(db),
                                referencedColumn:
                                    $$StocktakeEntriesTableReferences
                                        ._componentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StocktakeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StocktakeEntriesTable,
      StocktakeEntry,
      $$StocktakeEntriesTableFilterComposer,
      $$StocktakeEntriesTableOrderingComposer,
      $$StocktakeEntriesTableAnnotationComposer,
      $$StocktakeEntriesTableCreateCompanionBuilder,
      $$StocktakeEntriesTableUpdateCompanionBuilder,
      (StocktakeEntry, $$StocktakeEntriesTableReferences),
      StocktakeEntry,
      PrefetchHooks Function({bool sessionId, bool componentId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ComponentsTableTableManager get components =>
      $$ComponentsTableTableManager(_db, _db.components);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$InventoryBalancesTableTableManager get inventoryBalances =>
      $$InventoryBalancesTableTableManager(_db, _db.inventoryBalances);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$PurchaseOrdersTableTableManager get purchaseOrders =>
      $$PurchaseOrdersTableTableManager(_db, _db.purchaseOrders);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$PurchaseOrderItemsTableTableManager get purchaseOrderItems =>
      $$PurchaseOrderItemsTableTableManager(_db, _db.purchaseOrderItems);
  $$ProjectBomsTableTableManager get projectBoms =>
      $$ProjectBomsTableTableManager(_db, _db.projectBoms);
  $$StocktakeSessionsTableTableManager get stocktakeSessions =>
      $$StocktakeSessionsTableTableManager(_db, _db.stocktakeSessions);
  $$StocktakeEntriesTableTableManager get stocktakeEntries =>
      $$StocktakeEntriesTableTableManager(_db, _db.stocktakeEntries);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
