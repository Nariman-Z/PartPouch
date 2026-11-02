import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../../locations/data/locations_repository.dart';
import '../../suppliers/data/suppliers_repository.dart';
import '../data/inventory_repository.dart';

const List<String> kCommonCategories = [
  'Microcontroller',
  'Resistors',
  'Capacitors',
  'Inductors',
  'ICs & Semiconductors',
  'Sensors',
  'Diodes',
  'Transistors',
  'Optoelectronics',
  'Displays',
  'Power & Regulators',
  'Modules & Shields',
  'Connectors',
  'Switches & Relays',
  'Audio & Sound',
  'Hardware & Misc',
  'Other',
];

class AddEditComponentScreen extends ConsumerStatefulWidget {
  final String? componentId; // Null for Add, non-null for Edit

  const AddEditComponentScreen({super.key, this.componentId});

  @override
  ConsumerState<AddEditComponentScreen> createState() =>
      _AddEditComponentScreenState();
}

class _AddEditComponentScreenState
    extends ConsumerState<AddEditComponentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController(text: 'Microcontroller');
  final _manufacturerController = TextEditingController();
  final _mpnController = TextEditingController();
  final _skuController = TextEditingController();
  final _footprintController = TextEditingController();
  final _datasheetController = TextEditingController();
  final _tagsController = TextEditingController();
  final _minStockController = TextEditingController(text: '0');
  final _targetStockController = TextEditingController();
  final _uomController = TextEditingController(text: 'pcs');
  final _unitCostController = TextEditingController();
  final _initialStockController = TextEditingController(text: '0');
  final _descriptionController = TextEditingController();

  String? _selectedSupplierId;
  String? _selectedInitialLocationId;
  bool _isLoading = false;
  bool _isInitLoaded = false;

  bool get isEdit => widget.componentId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _manufacturerController.dispose();
    _mpnController.dispose();
    _skuController.dispose();
    _footprintController.dispose();
    _datasheetController.dispose();
    _tagsController.dispose();
    _minStockController.dispose();
    _targetStockController.dispose();
    _uomController.dispose();
    _unitCostController.dispose();
    _initialStockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadExistingData(Component comp) {
    if (_isInitLoaded) return;
    _nameController.text = comp.name;
    _categoryController.text = comp.category;
    _manufacturerController.text = comp.manufacturer ?? '';
    _mpnController.text = comp.manufacturerPartNumber ?? '';
    _skuController.text = comp.internalSku ?? '';
    _footprintController.text = comp.packageFootprint ?? '';
    _datasheetController.text = comp.datasheetUrl ?? '';
    _tagsController.text = comp.tags ?? '';
    _minStockController.text = comp.minStockThreshold.toString();
    _targetStockController.text = comp.targetStockQuantity?.toString() ?? '';
    _uomController.text = comp.unitOfMeasure;
    _selectedSupplierId = comp.defaultSupplierId;
    _descriptionController.text = comp.description ?? '';

    if (comp.unitCostCents != null) {
      _unitCostController.text = CurrencyFormatter.formatCentsAmount(
        comp.unitCostCents,
      );
    }

    _isInitLoaded = true;
  }

  Future<void> _save() async {
    final theme = ThemeProvider();
    if (!_formKey.currentState!.validate()) return;

    final initialStock = int.tryParse(_initialStockController.text) ?? 0;
    if (!isEdit && initialStock > 0 && _selectedInitialLocationId == null) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'لطفاً مکان ذخیره‌سازی را برای موجودی اولیه انتخاب کنید.'
            : 'Please select a storage location for the initial stock.',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final unitCostCents = CurrencyFormatter.parseToCents(
        _unitCostController.text,
      );
      final minStock = int.tryParse(_minStockController.text) ?? 0;
      final targetStock = int.tryParse(_targetStockController.text);

      if (isEdit) {
        await ref
            .read(inventoryRepositoryProvider)
            .updateComponent(
              id: widget.componentId!,
              name: _nameController.text.trim(),
              category: _categoryController.text.trim(),
              manufacturer: _manufacturerController.text.trim().isEmpty
                  ? null
                  : _manufacturerController.text.trim(),
              manufacturerPartNumber: _mpnController.text.trim().isEmpty
                  ? null
                  : _mpnController.text.trim(),
              internalSku: _skuController.text.trim().isEmpty
                  ? null
                  : _skuController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              packageFootprint: _footprintController.text.trim().isEmpty
                  ? null
                  : _footprintController.text.trim(),
              datasheetUrl: _datasheetController.text.trim().isEmpty
                  ? null
                  : _datasheetController.text.trim(),
              tags: _tagsController.text.trim().isEmpty
                  ? null
                  : _tagsController.text.trim(),
              minStockThreshold: minStock,
              targetStockQuantity: targetStock,
              defaultSupplierId: _selectedSupplierId,
              unitOfMeasure: 'pcs',
              unitCostCents: unitCostCents,
            );

        if (mounted) {
          context.pop();
          AppSnackBar.show(
            context,
            message: theme.currentLanguage == 'Persian'
                ? 'قطعه به‌روزرسانی شد.'
                : 'Component updated.',
            type: SnackBarType.success,
          );
        }
      } else {
        final newId = await ref
            .read(inventoryRepositoryProvider)
            .createComponent(
              name: _nameController.text.trim(),
              category: _categoryController.text.trim(),
              manufacturer: _manufacturerController.text.trim().isEmpty
                  ? null
                  : _manufacturerController.text.trim(),
              manufacturerPartNumber: _mpnController.text.trim().isEmpty
                  ? null
                  : _mpnController.text.trim(),
              internalSku: _skuController.text.trim().isEmpty
                  ? null
                  : _skuController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              packageFootprint: _footprintController.text.trim().isEmpty
                  ? null
                  : _footprintController.text.trim(),
              datasheetUrl: _datasheetController.text.trim().isEmpty
                  ? null
                  : _datasheetController.text.trim(),
              tags: _tagsController.text.trim().isEmpty
                  ? null
                  : _tagsController.text.trim(),
              minStockThreshold: minStock,
              targetStockQuantity: targetStock,
              defaultSupplierId: _selectedSupplierId,
              unitOfMeasure: 'pcs',
              unitCostCents: unitCostCents,
              initialStock: initialStock > 0 ? initialStock : 0,
              initialLocationId: initialStock > 0
                  ? _selectedInitialLocationId
                  : null,
            );

        if (mounted) {
          context.pop();
          context.push('/component/$newId');
          AppSnackBar.show(
            context,
            message: theme.currentLanguage == 'Persian'
                ? 'قطعه جدید ایجاد شد.'
                : 'Component created.',
            type: SnackBarType.success,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: e.toString(),
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final locationsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchAllLocations();
    final suppliersAsync = ref
        .watch(suppliersRepositoryProvider)
        .watchAllSuppliers();

    if (isEdit) {
      final compAsync = ref
          .watch(inventoryRepositoryProvider)
          .watchComponentById(widget.componentId!);
      return StreamBuilder<Component?>(
        stream: compAsync,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            _loadExistingData(snapshot.data!);
          }
          return _buildForm(locationsAsync, suppliersAsync, theme);
        },
      );
    }

    return _buildForm(locationsAsync, suppliersAsync, theme);
  }

  Widget _buildForm(
    Stream<List<Location>> locationsAsync,
    Stream<List<Supplier>> suppliersAsync,
    ThemeProvider theme,
  ) {
    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.primaryColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              theme.translate(isEdit ? 'edit_component' : 'create_component'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: theme.textColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Name
                PpTextField(
                  controller: _nameController,
                  label: '${theme.translate('components')} *',
                  hint: 'e.g. ESP32-C3 Dev Board, 10k Resistor',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return theme.translate('required_field');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Category
                PpTextField(
                  controller: _categoryController,
                  label: '${theme.translate('category')} *',
                  hint: 'e.g. Microcontroller, Resistors',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return theme.translate('required_field');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                // Common Category Chips
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kCommonCategories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      final cat = kCommonCategories[index];
                      final isSelected = _categoryController.text.trim() == cat;
                      return ActionChip(
                        label: Text(cat),
                        backgroundColor: isSelected
                            ? theme.activeColor.withValues(alpha: 0.15)
                            : theme.secondaryColor,
                        side: BorderSide(
                          color: isSelected ? theme.activeColor : theme.borderColor,
                        ),
                        labelStyle: theme.textStyle(
                          fontSize: 11,
                          color: isSelected
                              ? theme.activeColor
                              : theme.subTextColor,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        onPressed: () {
                          setState(() => _categoryController.text = cat);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Manufacturer & MPN
                Row(
                  children: [
                    Expanded(
                      child: PpTextField(
                        controller: _manufacturerController,
                        label: theme.translate('manufacturer'),
                        hint: 'e.g. Espressif, Yageo',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PpTextField(
                        controller: _mpnController,
                        label: theme.translate('mpn'),
                        hint: 'e.g. ESP32-C3-WROOM-02',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // SKU & Footprint
                Row(
                  children: [
                    Expanded(
                      child: PpTextField(
                        controller: _skuController,
                        label: theme.translate('sku'),
                        hint: 'e.g. MCU-ESP32-01',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PpTextField(
                        controller: _footprintController,
                        label: theme.translate('package'),
                        hint: 'e.g. SMD 0805, DIP-8',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Unit Cost
                PpTextField(
                  controller: _unitCostController,
                  label: '${theme.translate('unit_cost')} (${theme.currencySymbol})',
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Stock Thresholds
                Row(
                  children: [
                    Expanded(
                      child: PpTextField(
                        controller: _minStockController,
                        label: theme.translate('min_stock'),
                        hint: '0',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PpTextField(
                        controller: _targetStockController,
                        label: '${theme.translate('target_stock')} (${theme.translate('none')})',
                        hint: 'e.g. 50',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Initial Stock section (Only when creating a new component)
                if (!isEdit) ...[
                  PpCard(
                    backgroundColor: theme.secondaryColor,
                    borderColor: theme.borderColor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.add_business_rounded,
                              color: theme.activeColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              theme.currentLanguage == 'Persian'
                                  ? 'تنظیم موجودی اولیه'
                                  : 'Initial Stock Setup',
                              style: theme.textStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.activeColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        PpTextField(
                          controller: _initialStockController,
                          label: theme.currentLanguage == 'Persian'
                              ? 'موجودی اولیه در انبار'
                              : 'Initial Quantity On Hand',
                          hint: '0',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        StreamBuilder<List<Location>>(
                          stream: locationsAsync,
                          builder: (context, snapshot) {
                            final locations = snapshot.data ?? [];
                            if (_selectedInitialLocationId == null &&
                                locations.isNotEmpty) {
                              _selectedInitialLocationId = locations.first.id;
                            }

                            return DropdownButtonFormField<String>(
                              initialValue: _selectedInitialLocationId,
                              dropdownColor: theme.secondaryColor,
                              style: theme.textStyle(fontSize: 14, color: theme.textColor),
                              decoration: InputDecoration(
                                labelText: theme.currentLanguage == 'Persian'
                                    ? 'مکان نگهداری اولیه'
                                    : 'Initial Storage Location',
                                labelStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                              ),
                              items: locations.map((l) {
                                return DropdownMenuItem(
                                  value: l.id,
                                  child: Text(
                                    l.name,
                                    style: theme.textStyle(fontSize: 14, color: theme.textColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedInitialLocationId = val),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Default Supplier
                StreamBuilder<List<Supplier>>(
                  stream: suppliersAsync,
                  builder: (context, snapshot) {
                    final suppliers = snapshot.data ?? [];
                    return DropdownButtonFormField<String?>(
                      initialValue: _selectedSupplierId,
                      dropdownColor: theme.secondaryColor,
                      style: theme.textStyle(fontSize: 14, color: theme.textColor),
                      decoration: InputDecoration(
                        labelText: '${theme.translate('supplier')} (${theme.translate('none')})',
                        labelStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            theme.translate('none'),
                            style: theme.textStyle(fontSize: 14, color: theme.textColor),
                          ),
                        ),
                        ...suppliers.map(
                          (s) => DropdownMenuItem(
                            value: s.id,
                            child: Text(
                              s.name,
                              style: theme.textStyle(fontSize: 14, color: theme.textColor),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) => setState(() => _selectedSupplierId = val),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Datasheet & Tags
                PpTextField(
                  controller: _datasheetController,
                  label: theme.translate('datasheet'),
                  hint: 'https://...',
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: AppSpacing.md),

                PpTextField(
                  controller: _tagsController,
                  label: theme.translate('tags'),
                  hint: 'e.g. smd, 3.3v, logic, esp, prototype',
                ),
                const SizedBox(height: AppSpacing.md),

                // Description
                PpTextField(
                  controller: _descriptionController,
                  label: theme.translate('notes'),
                  hint: theme.currentLanguage == 'Persian'
                      ? 'توضیحات فنی، نکات پین‌اوت، هشدارها...'
                      : 'Technical notes, pinout notes, storage precautions...',
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Save Button
                PpButton(
                  label: theme.translate(isEdit ? 'save' : 'add'),
                  icon: Icons.check_rounded,
                  isLoading: _isLoading,
                  onPressed: _save,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
