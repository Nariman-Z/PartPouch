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
import '../../projects/data/projects_repository.dart';
import '../../stock_movements/data/stock_movements_repository.dart';

class UseStockDialog extends ConsumerStatefulWidget {
  final Component? initialComponent;
  final String? initialLocationId;

  const UseStockDialog({
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
      builder: (context) => UseStockDialog(
        initialComponent: initialComponent,
        initialLocationId: initialLocationId,
      ),
    );
  }

  @override
  ConsumerState<UseStockDialog> createState() => _UseStockDialogState();
}

class _UseStockDialogState extends ConsumerState<UseStockDialog> {
  final _formKey = GlobalKey<FormState>();
  Component? _selectedComponent;
  String? _selectedLocationId;
  String? _selectedProjectId;
  int _quantity = 1;
  final _quantityController = TextEditingController(text: '1');
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedComponent = widget.initialComponent;
    _selectedLocationId = widget.initialLocationId;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
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

  Future<void> _submit(int maxAvailable) async {
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
            ? 'لطفاً مکان مبدا را انتخاب کنید.'
            : 'Please select a source location.',
        type: SnackBarType.info,
      );
      return;
    }
    if (_quantity > maxAvailable) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'موجودی ناکافی: تنها ${theme.formatNumber(maxAvailable)} عدد موجود است.'
            : 'Insufficient stock: only $maxAvailable available.',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(stockMovementsRepositoryProvider)
          .issueStock(
            componentId: _selectedComponent!.id,
            sourceLocationId: _selectedLocationId!,
            quantity: _quantity,
            projectId: _selectedProjectId,
            notes: _reasonController.text.trim().isEmpty
                ? null
                : _reasonController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? '${theme.formatNumber(_quantity)} ${_selectedComponent!.unitOfMeasure} از ${_selectedComponent!.name} مصرف شد.'
              : 'Issued $_quantity ${_selectedComponent!.unitOfMeasure} of ${_selectedComponent!.name}',
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
    final projectsAsync = ref
        .watch(projectsRepositoryProvider)
        .watchAllProjects();

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
                            color: AppColors.secondaryContainer,
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          child: const Icon(
                            Icons.upload,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          theme.translate('use_stock'),
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
                            _selectedLocationId = null;
                          });
                        },
                        validator: (val) =>
                            val == null ? theme.translate('required_field') : null,
                      );
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.md),

                // Source Location & Available Stock
                if (_selectedComponent != null)
                  StreamBuilder<List<LocationBalanceItem>>(
                    stream: ref
                        .watch(inventoryRepositoryProvider)
                        .watchBalancesForComponent(_selectedComponent!.id),
                    builder: (context, snapshot) {
                      final balances = snapshot.data ?? [];
                      if (_selectedLocationId == null && balances.isNotEmpty) {
                        _selectedLocationId = balances.first.location.id;
                      }

                      final currentSelectedBal = balances
                          .where((b) => b.location.id == _selectedLocationId)
                          .firstOrNull;
                      final maxAvailable = currentSelectedBal?.quantity ?? 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _selectedLocationId,
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
                                setState(() => _selectedLocationId = val),
                            validator: (val) =>
                                val == null ? theme.translate('required_field') : null,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Quantity Counter
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
                                onPressed: _increment,
                                icon: const Icon(Icons.add),
                                style: IconButton.styleFrom(
                                  backgroundColor: theme.isDark ? const Color(0xFF262A30) : const Color(0xFFEAEFF5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Optional Project Dropdown
                          StreamBuilder<List<ProjectWithBomSummary>>(
                            stream: projectsAsync,
                            builder: (context, projSnapshot) {
                              final projects = projSnapshot.data ?? [];
                              return DropdownButtonFormField<String?>(
                                initialValue: _selectedProjectId,
                                dropdownColor: cardBg,
                                style: theme.textStyle(fontSize: 14, color: textPri),
                                decoration: InputDecoration(
                                  labelText: '${theme.translate('projects')} (${theme.translate('none')})',
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
                                  ...projects.map(
                                    (p) => DropdownMenuItem(
                                      value: p.project.id,
                                      child: Text(
                                        p.project.name,
                                        style: theme.textStyle(fontSize: 14, color: textPri),
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (val) =>
                                    setState(() => _selectedProjectId = val),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Reason
                          PpTextField(
                            controller: _reasonController,
                            label: '${theme.translate('reason_or_notes')} (${theme.translate('none')})',
                            hint: theme.currentLanguage == 'Persian'
                                ? 'پروتوتایپ، تعمیر، آزمایش...'
                                : 'Prototyping, repair, experiment, etc.',
                            maxLines: 2,
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
