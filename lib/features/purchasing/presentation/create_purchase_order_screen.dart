import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/formatting/date_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../../inventory/data/inventory_repository.dart';
import '../../suppliers/data/suppliers_repository.dart';
import '../data/purchasing_repository.dart';

class CreatePurchaseOrderScreen extends ConsumerStatefulWidget {
  const CreatePurchaseOrderScreen({super.key});

  @override
  ConsumerState<CreatePurchaseOrderScreen> createState() =>
      _CreatePurchaseOrderScreenState();
}

class _CreatePurchaseOrderScreenState
    extends ConsumerState<CreatePurchaseOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _orderNumberController;
  final _notesController = TextEditingController();
  String? _selectedSupplierId;
  DateTime _orderDate = DateTime.now();
  DateTime? _expectedDate;

  final List<NewPurchaseOrderItem> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final timestamp = DateTime.now().millisecondsSinceEpoch % 10000;
    _orderNumberController = TextEditingController(text: 'PO-2026-$timestamp');
  }

  @override
  void dispose() {
    _orderNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addItem(
    Component comp,
    int qty,
    int unitCostCents,
    String? supplierPartNumber,
  ) {
    setState(() {
      _items.add(
        NewPurchaseOrderItem(
          componentId: comp.id,
          orderedQuantity: qty,
          unitCostCents: unitCostCents,
          supplierPartNumber: supplierPartNumber,
        ),
      );
    });
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  Future<void> _submit() async {
    final theme = ThemeProvider();
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'لطفاً حداقل یک ردیف کالا به سفارش اضافه کنید.'
            : 'Please add at least one line item to the order.',
        type: SnackBarType.info,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final poId = await ref
          .read(purchasingRepositoryProvider)
          .createPurchaseOrder(
            orderNumber: _orderNumberController.text.trim(),
            supplierId: _selectedSupplierId,
            orderDate: _orderDate,
            expectedArrivalDate: _expectedDate,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            items: _items,
          );

      if (mounted) {
        context.pop();
        context.push('/purchase-order/$poId');
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? 'سفارش خرید با موفقیت ایجاد شد.'
              : 'Purchase order created.',
          type: SnackBarType.success,
        );
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

    final suppliersAsync = ref
        .watch(suppliersRepositoryProvider)
        .watchAllSuppliers();
    final allComponentsAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentsWithStock();

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
              theme.translate('create_po'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // PO Number & Supplier
                PpTextField(
                  controller: _orderNumberController,
                  label: '${theme.translate('po_number')} *',
                  hint: 'PO-2026-001',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return theme.translate('required_field');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                StreamBuilder<List<Supplier>>(
                  stream: suppliersAsync,
                  builder: (context, snapshot) {
                    final suppliers = snapshot.data ?? [];
                    return DropdownButtonFormField<String?>(
                      initialValue: _selectedSupplierId,
                      dropdownColor: theme.secondaryColor,
                      style: theme.textStyle(fontSize: 14, color: theme.textColor),
                      decoration: InputDecoration(
                        labelText: theme.translate('supplier'),
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
                const SizedBox(height: 12),

                // Order Date & Expected Arrival Date
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _orderDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            setState(() => _orderDate = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: theme.borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                theme.translate('order_date'),
                                style: theme.textStyle(
                                  fontSize: 11,
                                  color: theme.subTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 14,
                                    color: theme.activeColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateFormatter.formatDate(_orderDate),
                                    style: theme.textStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _expectedDate ??
                                DateTime.now().add(const Duration(days: 7)),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            setState(() => _expectedDate = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: theme.borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                theme.translate('expected_date'),
                                style: theme.textStyle(
                                  fontSize: 11,
                                  color: theme.subTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.event_available_rounded,
                                    size: 14,
                                    color: theme.activeColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _expectedDate != null
                                        ? DateFormatter.formatDate(
                                            _expectedDate!)
                                        : (theme.currentLanguage == 'Persian'
                                            ? 'تعیین نشده'
                                            : 'Not set'),
                                    style: theme.textStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                PpTextField(
                  controller: _notesController,
                  label: theme.translate('notes'),
                  hint: theme.currentLanguage == 'Persian'
                      ? 'شماره رهگیری، کد پیش‌فاکتور فروشگاه...'
                      : 'Tracking number, distributor quotation #...',
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Line Items Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      theme.translate('line_items'),
                      style: theme.textStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textColor,
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.add_rounded, size: 18, color: theme.activeColor),
                      label: Text(
                        theme.translate('add_line_item'),
                        style: theme.textStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.activeColor,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _AddLineItemDialog(
                            componentsStream: allComponentsAsync,
                            onAdd: _addItem,
                            theme: theme,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Items List
                if (_items.isEmpty)
                  PpCard(
                    padding: const EdgeInsets.all(24),
                    backgroundColor: theme.secondaryColor,
                    borderColor: theme.borderColor,
                    child: Center(
                      child: Text(
                        theme.currentLanguage == 'Persian'
                            ? 'هنوز کالایی به سفارش اضافه نشده است.'
                            : 'No line items added yet. Tap "Add Item" above.',
                        style: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = _items[index];

                      return StreamBuilder<Component?>(
                        stream: ref
                            .watch(inventoryRepositoryProvider)
                            .watchComponentById(item.componentId),
                        builder: (context, compSnapshot) {
                          final comp = compSnapshot.data;
                          return PpCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            backgroundColor: theme.secondaryColor,
                            borderColor: theme.borderColor,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comp?.name ?? theme.translate('components'),
                                        style: theme.textStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: theme.textColor,
                                        ),
                                      ),
                                      Text(
                                        '${theme.translate('quantity')}: ${theme.formatNumber(item.orderedQuantity)} • ${theme.translate('unit_cost')}: ${CurrencyFormatter.formatCents(item.unitCostCents)}',
                                        style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.formatCents(
                                    item.orderedQuantity * item.unitCostCents,
                                  ),
                                  style: theme.textStyle(
                                    fontSize: 14,
                                    color: theme.activeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: theme.subTextColor,
                                  ),
                                  onPressed: () => _removeItem(index),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),

                const SizedBox(height: 24),
                PpButton(
                  label: theme.translate('create_po'),
                  icon: Icons.check_rounded,
                  isLoading: _isLoading,
                  onPressed: _submit,
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

class _AddLineItemDialog extends StatefulWidget {
  final Stream<List<ComponentWithStock>> componentsStream;
  final void Function(
    Component comp,
    int qty,
    int unitCostCents,
    String? supplierPartNumber,
  ) onAdd;
  final ThemeProvider theme;

  const _AddLineItemDialog({
    required this.componentsStream,
    required this.onAdd,
    required this.theme,
  });

  @override
  State<_AddLineItemDialog> createState() => _AddLineItemDialogState();
}

class _AddLineItemDialogState extends State<_AddLineItemDialog> {
  Component? _selectedComponent;
  final _qtyController = TextEditingController(text: '10');
  final _costController = TextEditingController(text: '0.00');
  final _supplierPartNumberController = TextEditingController();

  @override
  void dispose() {
    _qtyController.dispose();
    _costController.dispose();
    _supplierPartNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return AlertDialog(
      backgroundColor: theme.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.borderColor),
      ),
      title: Text(
        theme.translate('add_line_item'),
        style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<List<ComponentWithStock>>(
              stream: widget.componentsStream,
              builder: (context, snapshot) {
                final components = snapshot.data ?? [];
                return DropdownButtonFormField<Component>(
                  initialValue: _selectedComponent,
                  dropdownColor: theme.secondaryColor,
                  style: theme.textStyle(fontSize: 14, color: theme.textColor),
                  decoration: InputDecoration(
                    labelText: '${theme.translate('components')} *',
                    labelStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                  ),
                  items: components.map((c) {
                    return DropdownMenuItem(
                      value: c.component,
                      child: Text(
                        c.component.name,
                        style: theme.textStyle(fontSize: 14, color: theme.textColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedComponent = val;
                      if (val?.unitCostCents != null) {
                        _costController.text =
                            CurrencyFormatter.formatCentsAmount(
                              val!.unitCostCents,
                            );
                      }
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            PpTextField(
              controller: _qtyController,
              label: '${theme.translate('quantity')} *',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            PpTextField(
              controller: _costController,
              label: '${theme.translate('unit_cost')} (${theme.currencySymbol})',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),
            PpTextField(
              controller: _supplierPartNumberController,
              label: '${theme.translate('sku')} (${theme.translate('none')})',
              hint: 'e.g. 595-ESP32-C3',
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                theme.translate('cancel'),
                style: theme.textStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.subTextColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.activeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_selectedComponent == null) return;
                final qty = int.tryParse(_qtyController.text) ?? 1;
                final cost =
                    CurrencyFormatter.parseToCents(_costController.text) ?? 0;
                widget.onAdd(
                  _selectedComponent!,
                  qty,
                  cost,
                  _supplierPartNumberController.text.trim(),
                );
                Navigator.of(context).pop();
              },
              child: Text(
                theme.translate('add'),
                style: theme.textStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
