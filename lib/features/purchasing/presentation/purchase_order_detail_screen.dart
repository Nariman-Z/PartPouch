import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/formatting/date_formatter.dart';
import '../../../core/theme/category_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_badge.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../../locations/data/locations_repository.dart';
import '../data/purchasing_repository.dart';

class PurchaseOrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const PurchaseOrderDetailScreen({super.key, required this.orderId});

  void _showReceiveItemDialog(
    BuildContext context,
    WidgetRef ref,
    PurchaseOrderItemDetail itemDetail,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _ReceivePoItemSheet(orderId: orderId, itemDetail: itemDetail),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeProvider();

    final poAsync = ref
        .watch(purchasingRepositoryProvider)
        .watchPurchaseOrder(orderId);

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        return StreamBuilder<PurchaseOrderWithDetails?>(
          stream: poAsync,
          builder: (context, snapshot) {
            final poDetail = snapshot.data;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: theme.primaryColor,
                body: Center(
                  child: CircularProgressIndicator(color: theme.activeColor),
                ),
              );
            }

            if (poDetail == null) {
              return Scaffold(
                backgroundColor: theme.primaryColor,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: theme.textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: PpEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: theme.translate('error'),
                  message: theme.translate('no_results_found'),
                ),
              );
            }

            final po = poDetail.order;

            return Scaffold(
              backgroundColor: theme.primaryColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                title: Text(
                  po.orderNumber,
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
                actions: [
                  if (po.status != 'cancelled' && po.status != 'received')
                    TextButton.icon(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 16,
                        color: AppColors.error,
                      ),
                      label: Text(
                        theme.currentLanguage == 'Persian'
                            ? 'لغو سفارش'
                            : 'Cancel Order',
                        style: theme.textStyle(
                          fontSize: 12,
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () =>
                          _confirmCancelOrder(context, ref, po.id, theme),
                    ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header Card
                  PpCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: theme.secondaryColor,
                    borderColor: theme.borderColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                po.orderNumber,
                                style: theme.textStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textColor,
                                ),
                              ),
                            ),
                            PpBadge(
                              label: _getLocalizedStatus(po.status, theme),
                              variant: po.status == 'received'
                                  ? BadgeVariant.success
                                  : (po.status == 'cancelled'
                                      ? BadgeVariant.error
                                      : (po.status == 'partiallyReceived'
                                          ? BadgeVariant.warning
                                          : BadgeVariant.neutral)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${theme.translate('supplier')}: ${poDetail.supplier?.name ?? theme.translate('none')}',
                          style: theme.textStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: theme.subTextColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${theme.translate('order_date')}: ${DateFormatter.formatDate(po.orderDate)}',
                          style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
                        ),
                        if (po.expectedArrivalDate != null)
                          Text(
                            '${theme.translate('expected_date')}: ${DateFormatter.formatDate(po.expectedArrivalDate!)}',
                            style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
                          ),
                        if (po.notes != null && po.notes!.isNotEmpty) ...[
                          Divider(height: 20, color: theme.borderColor),
                          Text(
                            po.notes!,
                            style: theme.textStyle(fontSize: 13, color: theme.textColor),
                          ),
                        ],
                        Divider(height: 20, color: theme.borderColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${theme.translate('total_quantity')}: ${theme.formatNumber(poDetail.totalReceivedUnits)} / ${theme.formatNumber(poDetail.totalOrderedUnits)}',
                              style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
                            ),
                            Text(
                              '${theme.translate('order_total')}: ${CurrencyFormatter.formatCents(poDetail.totalCostCents)}',
                              style: theme.textStyle(
                                fontSize: 15,
                                color: theme.activeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Line Items Header
                  Text(
                    theme.translate('line_items'),
                    style: theme.textStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Items List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: poDetail.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final itemDetail = poDetail.items[index];
                      final comp = itemDetail.component;
                      final item = itemDetail.item;

                      return PpCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        backgroundColor: theme.secondaryColor,
                        borderColor: theme.borderColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: CategoryColors.getContainerColor(
                                      comp.category,
                                      isDark: theme.isDark,
                                    ),
                                    borderRadius: AppSpacing.roundedSm,
                                    border: Border.all(
                                      color: CategoryColors.getBorderColor(
                                        comp.category,
                                        isDark: theme.isDark,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    CategoryColors.getCategoryIcon(comp.category),
                                    color: CategoryColors.getForegroundColor(
                                      comp.category,
                                      isDark: theme.isDark,
                                    ),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comp.category,
                                        style: theme.textStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: CategoryColors.getColor(
                                            comp.category,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        comp.name,
                                        style: theme.textStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: theme.textColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (comp.description != null &&
                                          comp.description!
                                              .trim()
                                              .isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          comp.description!,
                                          style: theme.textStyle(
                                            fontSize: 12,
                                            color: theme.subTextColor,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                      const SizedBox(height: 3),
                                      Text(
                                        '${comp.packageFootprint != null && comp.packageFootprint!.trim().isNotEmpty ? '${comp.packageFootprint!} • ' : ''}${theme.translate('unit_cost')}: ${CurrencyFormatter.formatCents(item.unitCostCents)}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w500,
                                          color: theme.subTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${theme.translate('counted')}: ${theme.formatNumber(item.receivedQuantity)} / ${theme.formatNumber(item.orderedQuantity)} ${comp.unitOfMeasure}',
                                        style: theme.textStyle(
                                          fontSize: 11,
                                          color: itemDetail.isFullyReceived
                                              ? AppColors.success
                                              : theme.subTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (itemDetail.isFullyReceived)
                                  PpBadge(
                                    label: theme.translate('done'),
                                    variant: BadgeVariant.success,
                                    icon: Icons.check,
                                  ),
                              ],
                            ),
                            if (!itemDetail.isFullyReceived &&
                                po.status != 'cancelled') ...[
                              const SizedBox(height: 10),
                              PpButton(
                                label: theme.translate('receive_items'),
                                height: 38,
                                fullWidth: true,
                                icon: Icons.input_rounded,
                                onPressed: () => _showReceiveItemDialog(
                                  context,
                                  ref,
                                  itemDetail,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmCancelOrder(
    BuildContext context,
    WidgetRef ref,
    String orderId,
    ThemeProvider theme,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          theme.currentLanguage == 'Persian'
              ? 'لغو سفارش خرید'
              : 'Cancel Purchase Order',
          style: theme.textStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textColor,
          ),
        ),
        content: Text(
          theme.currentLanguage == 'Persian'
              ? 'آیا از لغو این سفارش خرید اطمینان دارید؟'
              : 'Are you sure you want to cancel this purchase order?',
          style: theme.textStyle(fontSize: 13, color: theme.subTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              theme.translate('cancel'),
              style: theme.textStyle(color: theme.subTextColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              theme.currentLanguage == 'Persian' ? 'لغو سفارش' : 'Cancel Order',
              style: theme.textStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref
          .read(purchasingRepositoryProvider)
          .updateOrderStatus(orderId, 'cancelled');
      if (context.mounted) {
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? 'سفارش خرید لغو شد'
              : 'Purchase order cancelled',
          type: SnackBarType.info,
        );
      }
    }
  }

  String _getLocalizedStatus(String status, ThemeProvider theme) {
    switch (status) {
      case 'ordered':
      case 'submitted':
      case 'draft':
        return theme.translate('draft');
      case 'partiallyReceived':
      case 'partially_received':
        return theme.translate('partially_received');
      case 'received':
      case 'completed':
        return theme.translate('received');
      case 'cancelled':
        return theme.translate('cancelled');
      default:
        return theme.translate('draft');
    }
  }
}

class _ReceivePoItemSheet extends ConsumerStatefulWidget {
  final String orderId;
  final PurchaseOrderItemDetail itemDetail;

  const _ReceivePoItemSheet({required this.orderId, required this.itemDetail});

  @override
  ConsumerState<_ReceivePoItemSheet> createState() =>
      _ReceivePoItemSheetState();
}

class _ReceivePoItemSheetState extends ConsumerState<_ReceivePoItemSheet> {
  String? _selectedLocationId;
  int _quantity = 1;
  late final TextEditingController _qtyController;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.itemDetail.remainingQuantity;
    _qtyController = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final theme = ThemeProvider();
    if (_selectedLocationId == null) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'لطفاً مکان مقصد ذخیره‌سازی را انتخاب کنید.'
            : 'Please select a destination location.',
        type: SnackBarType.info,
      );
      return;
    }
    if (_quantity <= 0 || _quantity > widget.itemDetail.remainingQuantity) {
      AppSnackBar.show(
        context,
        message:
            '${theme.translate('quantity')} (1 - ${theme.formatNumber(widget.itemDetail.remainingQuantity)})',
        type: SnackBarType.info,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(purchasingRepositoryProvider)
          .receivePurchaseOrderItem(
            purchaseOrderId: widget.orderId,
            itemId: widget.itemDetail.item.id,
            destinationLocationId: _selectedLocationId!,
            quantityToReceive: _quantity,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? '${theme.formatNumber(_quantity)} ${widget.itemDetail.component.unitOfMeasure} با موفقیت به انبار وارد شد.'
              : 'Received $_quantity ${widget.itemDetail.component.unitOfMeasure} into inventory.',
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

    final locationsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchAllLocations();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    theme.translate('receive_items'),
                    style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.subTextColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.itemDetail.component.name,
                style: theme.textStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.activeColor,
                ),
              ),
              Text(
                '${theme.translate('expected')}: ${theme.formatNumber(widget.itemDetail.remainingQuantity)} ${widget.itemDetail.component.unitOfMeasure}',
                style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
              ),
              const SizedBox(height: 16),

              // Location Dropdown
              StreamBuilder<List<Location>>(
                stream: locationsAsync,
                builder: (context, snapshot) {
                  final locations = snapshot.data ?? [];
                  if (_selectedLocationId == null && locations.isNotEmpty) {
                    _selectedLocationId = locations.first.id;
                  }

                  return DropdownButtonFormField<String>(
                    initialValue: _selectedLocationId,
                    dropdownColor: theme.secondaryColor,
                    style: theme.textStyle(fontSize: 14, color: theme.textColor),
                    decoration: InputDecoration(
                      labelText: '${theme.translate('destination_location')} *',
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
                        setState(() => _selectedLocationId = val),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Quantity
              PpTextField(
                controller: _qtyController,
                label: '${theme.translate('quantity')} *',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null && parsed > 0) _quantity = parsed;
                },
              ),
              const SizedBox(height: 12),

              PpTextField(
                controller: _notesController,
                label: '${theme.translate('notes')} (${theme.translate('none')})',
                hint: theme.currentLanguage == 'Persian'
                    ? 'شماره بارنامه، یادداشت رسید...'
                    : 'Packing slip #, batch note...',
              ),
              const SizedBox(height: 20),

              PpButton(
                label: theme.translate('confirm'),
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
