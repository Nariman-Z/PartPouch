import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_badge.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../../stock_movements/data/stock_movements_repository.dart';

class AdjustStockDialog extends ConsumerStatefulWidget {
  final Component component;
  final Location location;
  final int currentQuantity;

  const AdjustStockDialog({
    super.key,
    required this.component,
    required this.location,
    required this.currentQuantity,
  });

  static Future<void> show(
    BuildContext context, {
    required Component component,
    required Location location,
    required int currentQuantity,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdjustStockDialog(
        component: component,
        location: location,
        currentQuantity: currentQuantity,
      ),
    );
  }

  @override
  ConsumerState<AdjustStockDialog> createState() => _AdjustStockDialogState();
}

class _AdjustStockDialogState extends ConsumerState<AdjustStockDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _newQuantity;
  late final TextEditingController _quantityController;
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _newQuantity = widget.currentQuantity;
    _quantityController = TextEditingController(
      text: widget.currentQuantity.toString(),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final theme = ThemeProvider();
    if (!_formKey.currentState!.validate()) return;
    if (_newQuantity == widget.currentQuantity) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(stockMovementsRepositoryProvider)
          .adjustStock(
            componentId: widget.component.id,
            locationId: widget.location.id,
            newQuantity: _newQuantity,
            reason: _reasonController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? 'موجودی به ${theme.formatNumber(_newQuantity)} ${widget.component.unitOfMeasure} اصلاح شد.'
              : 'Stock calibrated to $_newQuantity ${widget.component.unitOfMeasure}',
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
    final cardBorder = theme.isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPri = theme.isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSec = theme.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final delta = _newQuantity - widget.currentQuantity;

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
                            Icons.tune,
                            color: AppColors.warning,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          theme.translate('adjust_stock'),
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

                // Component & Location Banner
                PpCard(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: theme.isDark ? const Color(0xFF1E2126) : const Color(0xFFF1F5F9),
                  borderColor: cardBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.component.name,
                        style: theme.textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPri),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            size: 14,
                            color: textSec,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.location.name,
                            style: theme.textStyle(fontSize: 12, color: textSec),
                          ),
                          const Spacer(),
                          Text(
                            '${theme.translate('expected')}: ${theme.formatNumber(widget.currentQuantity)} ${widget.component.unitOfMeasure}',
                            style: theme.textStyle(
                              fontSize: 12,
                              color: textSec,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // New Quantity & Discrepancy Indicator
                Text(
                  '${theme.translate('counted')} *',
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
                        if (_newQuantity > 0) {
                          setState(() {
                            _newQuantity--;
                            _quantityController.text = _newQuantity.toString();
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
                          suffixText: widget.component.unitOfMeasure,
                          suffixStyle: theme.textStyle(fontSize: 12, color: textSec),
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null && parsed >= 0) {
                            setState(() => _newQuantity = parsed);
                          }
                        },
                        validator: (val) {
                          final parsed = int.tryParse(val ?? '');
                          if (parsed == null || parsed < 0) {
                            return '>= 0';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () {
                        setState(() {
                          _newQuantity++;
                          _quantityController.text = _newQuantity.toString();
                        });
                      },
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.isDark ? const Color(0xFF262A30) : const Color(0xFFEAEFF5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Delta readout
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${theme.translate('discrepancy')}: ', style: theme.textStyle(fontSize: 12, color: textSec)),
                    if (delta == 0)
                      PpBadge(
                        label: theme.currentLanguage == 'Persian' ? 'بدون تغییر' : 'No Change',
                        variant: BadgeVariant.neutral,
                      )
                    else if (delta > 0)
                      PpBadge(
                        label: '+${theme.formatNumber(delta)} ${widget.component.unitOfMeasure}',
                        variant: BadgeVariant.inStock,
                        icon: Icons.arrow_upward,
                      )
                    else
                      PpBadge(
                        label: '${theme.formatNumber(delta)} ${widget.component.unitOfMeasure}',
                        variant: BadgeVariant.outOfStock,
                        icon: Icons.arrow_downward,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Reason (Required)
                PpTextField(
                  controller: _reasonController,
                  label: '${theme.translate('reason_or_notes')} *',
                  hint: theme.currentLanguage == 'Persian'
                      ? 'شمارش مجدد، قطعه خراب، قطعه جامانده و غیره...'
                      : 'Physical recount, spoiled parts, found misplaced stock, etc.',
                  maxLines: 2,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return theme.translate('required_field');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // Submit
                PpButton(
                  label: theme.translate('save'),
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
