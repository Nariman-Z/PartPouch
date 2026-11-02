import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../../inventory/data/inventory_repository.dart';
import '../../locations/data/locations_repository.dart';
import '../../stock_movements/data/stock_movements_repository.dart';

class TransferStockDialog extends ConsumerStatefulWidget {
  final Component? initialComponent;
  final String? initialSourceLocationId;

  const TransferStockDialog({
    super.key,
    this.initialComponent,
    this.initialSourceLocationId,
  });

  static Future<void> show(
    BuildContext context, {
    Component? initialComponent,
    String? initialSourceLocationId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransferStockDialog(
        initialComponent: initialComponent,
        initialSourceLocationId: initialSourceLocationId,
      ),
    );
  }

  @override
  ConsumerState<TransferStockDialog> createState() =>
      _TransferStockDialogState();
}

class _TransferStockDialogState extends ConsumerState<TransferStockDialog> {
  final _formKey = GlobalKey<FormState>();
  Component? _selectedComponent;
  String? _sourceLocationId;
  String? _destLocationId;
  int _quantity = 1;
  final _quantityController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedComponent = widget.initialComponent;
    _sourceLocationId = widget.initialSourceLocationId;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit(int maxAvailable) async {
    final theme = ThemeProvider();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedComponent == null ||
        _sourceLocationId == null ||
        _destLocationId == null) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'لطفاً قطعه، مبدا و مقصد را مشخص کنید.'
            : 'Please select component, source, and destination.',
        type: SnackBarType.info,
      );
      return;
    }
    if (_sourceLocationId == _destLocationId) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'مکان مبدا و مقصد نمی‌توانند یکسان باشند.'
            : 'Source and destination locations must be different.',
        type: SnackBarType.info,
      );
      return;
    }
    if (_quantity > maxAvailable) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'موجودی ناکافی: تنها ${theme.formatNumber(maxAvailable)} عدد در مبدا موجود است.'
            : 'Insufficient stock: only $maxAvailable available.',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(stockMovementsRepositoryProvider)
          .transferStock(
            componentId: _selectedComponent!.id,
            sourceLocationId: _sourceLocationId!,
            destinationLocationId: _destLocationId!,
            quantity: _quantity,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? '${theme.formatNumber(_quantity)} ${_selectedComponent!.unitOfMeasure} از ${_selectedComponent!.name} منتقل شد.'
              : 'Transferred $_quantity ${_selectedComponent!.unitOfMeasure} of ${_selectedComponent!.name}',
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

    final allComponentsAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentsWithStock();
    final allLocationsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchAllLocations();

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
                            color: AppColors.warningContainer,
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          child: const Icon(
                            Icons.sync_alt,
                            color: AppColors.warning,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          theme.translate('transfer_stock'),
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

                // Component
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
                          child: Text(
                            _selectedComponent!.name,
                            style: theme.textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPri),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  StreamBuilder<List<ComponentWithStock>>(
                    stream: allComponentsAsync,
                    builder: (context, snapshot) {
                      final items = (snapshot.data ?? [])
                          .where((c) => c.totalStock > 0)
                          .toList();
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
                            _sourceLocationId = null;
                            _destLocationId = null;
                          });
                        },
                        validator: (val) =>
                            val == null ? theme.translate('required_field') : null,
                      );
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.md),

                // Source Location
                if (_selectedComponent != null)
                  StreamBuilder<List<LocationBalanceItem>>(
                    stream: ref
                        .watch(inventoryRepositoryProvider)
                        .watchBalancesForComponent(_selectedComponent!.id),
                    builder: (context, snapshot) {
                      final balances = snapshot.data ?? [];
                      if (_sourceLocationId == null && balances.isNotEmpty) {
                        _sourceLocationId = balances.first.location.id;
                      }

                      final sourceBal = balances
                          .where((b) => b.location.id == _sourceLocationId)
                          .firstOrNull;
                      final maxAvailable = sourceBal?.quantity ?? 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _sourceLocationId,
                            dropdownColor: cardBg,
                            style: theme.textStyle(fontSize: 14, color: textPri),
                            decoration: InputDecoration(
                              labelText: '${theme.translate('source_location')} *',
                              labelStyle: theme.textStyle(fontSize: 13, color: textSec),
                            ),
                            items: balances.map((b) {
                              return DropdownMenuItem(
                                value: b.location.id,
                                child: Text(
                                  '${b.location.name} (${theme.formatNumber(b.quantity)} ${_selectedComponent!.unitOfMeasure} ${theme.translate('in_stock')})',
                                  style: theme.textStyle(fontSize: 14, color: textPri),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _sourceLocationId = val),
                            validator: (val) =>
                                val == null ? theme.translate('required_field') : null,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Destination Location
                          StreamBuilder<List<Location>>(
                            stream: allLocationsAsync,
                            builder: (context, locSnapshot) {
                              final allLocations = locSnapshot.data ?? [];
                              final availableDestinations = allLocations
                                  .where((l) => l.id != _sourceLocationId)
                                  .toList();

                              return DropdownButtonFormField<String>(
                                initialValue: _destLocationId,
                                dropdownColor: cardBg,
                                style: theme.textStyle(fontSize: 14, color: textPri),
                                decoration: InputDecoration(
                                  labelText: '${theme.translate('destination_location')} *',
                                  labelStyle: theme.textStyle(fontSize: 13, color: textSec),
                                ),
                                items: availableDestinations.map((l) {
                                  return DropdownMenuItem(
                                    value: l.id,
                                    child: Text(
                                      l.name,
                                      style: theme.textStyle(fontSize: 14, color: textPri),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => _destLocationId = val),
                                validator: (val) =>
                                    val == null ? theme.translate('required_field') : null,
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Quantity
                          Text(
                            '${theme.translate('quantity')} * (${theme.translate('expected')}: ${theme.formatNumber(maxAvailable)})',
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
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() {
                                      _quantity--;
                                      _quantityController.text = _quantity
                                          .toString();
                                    });
                                  }
                                },
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
                                        _selectedComponent?.unitOfMeasure ??
                                        'pcs',
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
                                    if (parsed > maxAvailable) {
                                      return '<= $maxAvailable';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filledTonal(
                                onPressed: () {
                                  setState(() {
                                    _quantity++;
                                    _quantityController.text = _quantity
                                        .toString();
                                  });
                                },
                                icon: const Icon(Icons.add),
                                style: IconButton.styleFrom(
                                  backgroundColor: theme.isDark ? const Color(0xFF262A30) : const Color(0xFFEAEFF5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Notes
                          PpTextField(
                            controller: _notesController,
                            label: '${theme.translate('notes')} (${theme.translate('none')})',
                            hint: theme.currentLanguage == 'Persian'
                                ? 'جابجایی جعبه، انتقال به سبد پروژه...'
                                : 'Reorganizing workshop, moving to project bin, etc.',
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Submit
                          PpButton(
                            label: theme.translate('confirm'),
                            onPressed: () => _submit(maxAvailable),
                            isLoading: _isLoading,
                            icon: Icons.check,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
