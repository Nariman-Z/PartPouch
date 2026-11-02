import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../../inventory/data/inventory_repository.dart';
import '../../locations/data/locations_repository.dart';
import '../../stock_movements/data/stock_movements_repository.dart';
import '../../suppliers/data/suppliers_repository.dart';

class ReceiveStockDialog extends ConsumerStatefulWidget {
  final Component? initialComponent;
  final String? initialLocationId;

  const ReceiveStockDialog({
    super.key,
    this.initialComponent,
    this.initialLocationId,
  });

  static Future<void> show(
    BuildContext context, {
    Component? initialComponent,
    String? initialLocationId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReceiveStockDialog(
        initialComponent: initialComponent,
        initialLocationId: initialLocationId,
      ),
    );
  }

  @override
  ConsumerState<ReceiveStockDialog> createState() => _ReceiveStockDialogState();
}

class _ReceiveStockDialogState extends ConsumerState<ReceiveStockDialog> {
  final _formKey = GlobalKey<FormState>();
  Component? _selectedComponent;
  String? _selectedLocationId;
  String? _selectedSupplierId;
  String? _selectedPurchaseOrderId;
  int _quantity = 1;
  final _quantityController = TextEditingController(text: '1');
  final _unitCostController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedComponent = widget.initialComponent;
    _selectedLocationId = widget.initialLocationId;

    if (_selectedComponent?.unitCostCents != null) {
      _unitCostController.text = CurrencyFormatter.formatCentsAmount(
        _selectedComponent!.unitCostCents,
      );
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _quantity++;
      _quantityController.text = _quantity.toString();
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _quantityController.text = _quantity.toString();
      });
    }
  }

  Future<void> _submit() async {
    final theme = ThemeProvider();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedComponent == null) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'لطفاً یک قطعه انتخاب کنید.'
            : 'Please select a component.',
        type: SnackBarType.info,
      );
      return;
    }
    if (_selectedLocationId == null) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'لطفاً مکان مقصد را انتخاب کنید.'
            : 'Please select a destination location.',
        type: SnackBarType.info,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final unitCostCents = CurrencyFormatter.parseToCents(
        _unitCostController.text,
      );

      await ref
          .read(stockMovementsRepositoryProvider)
          .receiveStock(
            componentId: _selectedComponent!.id,
            destinationLocationId: _selectedLocationId!,
            quantity: _quantity,
            unitCostCents: unitCostCents,
            supplierId: _selectedSupplierId,
            purchaseOrderId: _selectedPurchaseOrderId,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? '${theme.formatNumber(_quantity)} ${_selectedComponent!.unitOfMeasure} از ${_selectedComponent!.name} به انبار اضافه شد.'
              : 'Received $_quantity ${_selectedComponent!.unitOfMeasure} of ${_selectedComponent!.name}',
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
    final cardBg = theme.isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPri = theme.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSec = theme.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final locationsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchAllLocations();
    final suppliersAsync = ref
        .watch(suppliersRepositoryProvider)
        .watchAllSuppliers();
    final allComponentsAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentsWithStock();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.activeColor.withValues(alpha: 0.15),
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          child: Icon(
                            Icons.download,
                            color: theme.activeColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          theme.translate('receive_stock'),
                          style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPri),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: textSec,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Component Selector
                if (widget.initialComponent != null) ...[
                  PpCard(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: theme.secondaryColor,
                    borderColor: theme.borderColor,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.activeColor.withValues(alpha: 0.15),
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          child: Icon(
                            Icons.memory,
                            color: theme.activeColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedComponent!.name,
                                style: theme.textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPri),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_selectedComponent!.category} • ${_selectedComponent!.packageFootprint ?? 'Standard'}',
                                style: theme.textStyle(fontSize: 12, color: textSec),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  StreamBuilder<List<ComponentWithStock>>(
                    stream: allComponentsAsync,
                    builder: (context, snapshot) {
                      final items = snapshot.data ?? [];
                      return DropdownButtonFormField<Component>(
                        initialValue: _selectedComponent,
                        dropdownColor: cardBg,
                        style: theme.textStyle(fontSize: 14, color: textPri),
                        decoration: InputDecoration(
                          labelText: '${theme.translate('components')} *',
                          labelStyle: theme.textStyle(fontSize: 13, color: textSec),
                        ),
                        items: items.map((c) {
                          return DropdownMenuItem(
                            value: c.component,
                            child: Text(
                              '${c.component.name} (${theme.formatNumber(c.totalStock)} ${c.component.unitOfMeasure})',
                              style: theme.textStyle(fontSize: 14, color: textPri),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedComponent = val;
                            if (val?.unitCostCents != null) {
                              _unitCostController.text =
                                  CurrencyFormatter.formatCentsAmount(
                                    val!.unitCostCents,
                                  );
                            }
                          });
                        },
                        validator: (val) =>
                            val == null ? theme.translate('required_field') : null,
                      );
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.md),

                // Destination Location Dropdown
                StreamBuilder<List<Location>>(
                  stream: locationsAsync,
                  builder: (context, snapshot) {
                    final locations = snapshot.data ?? [];
                    if (_selectedLocationId == null && locations.isNotEmpty) {
                      _selectedLocationId = locations.first.id;
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedLocationId,
                      dropdownColor: cardBg,
                      style: theme.textStyle(fontSize: 14, color: textPri),
                      decoration: InputDecoration(
                        labelText: '${theme.translate('destination_location')} *',
                        labelStyle: theme.textStyle(fontSize: 13, color: textSec),
                      ),
                      items: locations.map((loc) {
                        return DropdownMenuItem(
                          value: loc.id,
                          child: Text(
                            '${loc.name} ${loc.code != null ? '(${loc.code})' : ''}',
                            style: theme.textStyle(fontSize: 14, color: textPri),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedLocationId = val),
                      validator: (val) =>
                          val == null ? theme.translate('required_field') : null,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Quantity Counter
                Text(
                  '${theme.translate('quantity')} *',
                  style: theme.textStyle(
                    fontSize: 13,
                    color: textSec,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _decrement,
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.isDark ? const Color(0xFF262A30) : const Color(0xFFEAEFF5),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: theme.textStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPri),
                        decoration: InputDecoration(
                          suffixText:
                              _selectedComponent?.unitOfMeasure ?? 'pcs',
                          suffixStyle: theme.textStyle(fontSize: 12, color: textSec),
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null && parsed > 0) {
                            _quantity = parsed;
                          }
                        },
                        validator: (val) {
                          final parsed = int.tryParse(val ?? '');
                          if (parsed == null || parsed <= 0) {
                            return '> 0';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: _increment,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.isDark ? const Color(0xFF262A30) : const Color(0xFFEAEFF5),
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

                // Optional Supplier
                StreamBuilder<List<Supplier>>(
                  stream: suppliersAsync,
                  builder: (context, snapshot) {
                    final suppliers = snapshot.data ?? [];
                    return DropdownButtonFormField<String?>(
                      initialValue: _selectedSupplierId,
                      dropdownColor: cardBg,
                      style: theme.textStyle(fontSize: 14, color: textPri),
                      decoration: InputDecoration(
                        labelText: '${theme.translate('supplier')} (${theme.translate('none')})',
                        labelStyle: theme.textStyle(fontSize: 13, color: textSec),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            theme.translate('none'),
                            style: theme.textStyle(fontSize: 14, color: textPri),
                          ),
                        ),
                        ...suppliers.map(
                          (s) => DropdownMenuItem(
                            value: s.id,
                            child: Text(
                              s.name,
                              style: theme.textStyle(fontSize: 14, color: textPri),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedSupplierId = val),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Notes
                PpTextField(
                  controller: _notesController,
                  label: '${theme.translate('notes')} (${theme.translate('none')})',
                  hint: theme.currentLanguage == 'Persian'
                      ? 'شماره فاکتور، یادداشت بسته، رهگیری...'
                      : 'Invoice #, PO reference, batch, etc.',
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Submit Button
                PpButton(
                  label: theme.translate('confirm'),
                  onPressed: _submit,
                  isLoading: _isLoading,
                  icon: Icons.check,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
