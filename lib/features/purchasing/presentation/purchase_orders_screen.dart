import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/formatting/date_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_badge.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../data/purchasing_repository.dart';

class PurchaseOrdersScreen extends ConsumerStatefulWidget {
  const PurchaseOrdersScreen({super.key});

  @override
  ConsumerState<PurchaseOrdersScreen> createState() =>
      _PurchaseOrdersScreenState();
}

class _PurchaseOrdersScreenState extends ConsumerState<PurchaseOrdersScreen> {
  String _selectedStatus =
      'All'; // All, ordered, partiallyReceived, received, draft

  void _showCreatePoDialog() {
    context.push('/purchasing/new');
  }

  Future<void> _exportPurchaseOrders() async {
    final theme = ThemeProvider();
    try {
      final jsonString = await ref
          .read(purchasingRepositoryProvider)
          .exportPurchaseOrdersToJson();

      await SharePlus.instance.share(
        ShareParams(
          text: jsonString,
          subject:
              'PartPouch_PurchaseOrders_${DateTime.now().toIso8601String().substring(0, 10)}.json',
        ),
      );

      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.translate('pos_exported_success'),
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Export failed: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _importPurchaseOrdersFromFile() async {
    final theme = ThemeProvider();
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (files.isEmpty) return;

      final file = files.first;
      final jsonString = await file.xFile.readAsString();

      final count = await ref
          .read(purchasingRepositoryProvider)
          .importPurchaseOrdersFromJson(jsonString);

      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? '${theme.formatNumber(count)} سفارش خرید با موفقیت وارد شدند.'
              : '$count purchase orders imported successfully.',
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Import failed: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    }
  }

  void _showPasteImportDialog() {
    final theme = ThemeProvider();
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: theme.borderColor),
        ),
        title: Text(
          theme.translate('paste_pos_json'),
          style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              theme.currentLanguage == 'Persian'
                  ? 'متن JSON حاوی لیست سفارش‌های خرید را در کادر زیر وارد کنید:'
                  : 'Paste the purchase orders JSON data in the box below:',
              style: theme.textStyle(fontSize: 13, color: theme.subTextColor),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              maxLines: 8,
              style: theme.textStyle(fontSize: 12, color: theme.textColor),
              decoration: InputDecoration(
                hintText:
                    '{\n  "purchaseOrders": [\n    {"orderNumber": "PO-2026-001"}\n  ]\n}',
                hintStyle:
                    theme.textStyle(fontSize: 12, color: theme.subTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.borderColor),
                ),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  theme.translate('cancel'),
                  style: theme.textStyle(
                    fontSize: 14,
                    color: theme.subTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.activeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final text = textController.text.trim();
                  if (text.isEmpty) return;

                  Navigator.of(context).pop();

                  try {
                    final count = await ref
                        .read(purchasingRepositoryProvider)
                        .importPurchaseOrdersFromJson(text);
                    if (mounted) {
                      AppSnackBar.show(
                        context,
                        message: theme.currentLanguage == 'Persian'
                            ? '${theme.formatNumber(count)} سفارش خرید با موفقیت وارد شدند.'
                            : '$count purchase orders imported successfully.',
                        type: SnackBarType.success,
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      AppSnackBar.show(
                        context,
                        message: 'Import failed: ${e.toString()}',
                        type: SnackBarType.error,
                      );
                    }
                  }
                },
                child: Text(
                  theme.translate('import_pos'),
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
      ),
    );
  }

  Future<void> _loadDemoPurchaseOrders() async {
    final theme = ThemeProvider();
    try {
      final count = await ref
          .read(purchasingRepositoryProvider)
          .seedDefaultPurchaseOrders();

      if (mounted) {
        AppSnackBar.show(
          context,
          message: count > 0
              ? (theme.currentLanguage == 'Persian'
                  ? '${theme.formatNumber(count)} سفارش خرید نمونه به لیست اضافه شد.'
                  : '$count demo purchase orders added to list.')
              : (theme.currentLanguage == 'Persian'
                  ? 'سفارش‌های نمونه از قبل در لیست وجود دارند.'
                  : 'Demo purchase orders are already in your list.'),
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: 'Error: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    final posStream = ref
        .watch(purchasingRepositoryProvider)
        .watchAllPurchaseOrders(
          statusFilter: _selectedStatus == 'All' ? null : _selectedStatus,
        );

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
              theme.translate('purchase_orders'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            actions: [
              // Floppy Disk Icon for Import / Export
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.save_rounded,
                  color: theme.activeColor,
                  size: 24,
                ),
                tooltip: theme.translate('import_export_pos'),
                color: theme.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.borderColor),
                ),
                onSelected: (val) {
                  switch (val) {
                    case 'export':
                      _exportPurchaseOrders();
                      break;
                    case 'import_file':
                      _importPurchaseOrdersFromFile();
                      break;
                    case 'import_paste':
                      _showPasteImportDialog();
                      break;
                    case 'demo':
                      _loadDemoPurchaseOrders();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'export',
                    child: Row(
                      children: [
                        Icon(
                          Icons.share_rounded,
                          size: 18,
                          color: theme.activeColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          theme.translate('export_pos'),
                          style: theme.textStyle(
                            fontSize: 13,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'import_file',
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          size: 18,
                          color: theme.activeColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          theme.translate('import_from_file'),
                          style: theme.textStyle(
                            fontSize: 13,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'import_paste',
                    child: Row(
                      children: [
                        Icon(
                          Icons.content_paste_rounded,
                          size: 18,
                          color: theme.activeColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          theme.translate('paste_pos_json'),
                          style: theme.textStyle(
                            fontSize: 13,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'demo',
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 18,
                          color: theme.activeColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          theme.translate('load_demo_pos'),
                          style: theme.textStyle(
                            fontSize: 13,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Filter Tabs with generous side margins for long labels like "Partially Received"
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                child: Row(
                  children: [
                    _buildFilterChip(
                        'All', theme.translate('filter_all'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'draft', theme.translate('draft'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip('partiallyReceived',
                        theme.translate('partially_received'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'received', theme.translate('received'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'cancelled', theme.translate('cancelled'), theme),
                  ],
                ),
              ),

              // POs List
              Expanded(
                child: StreamBuilder<List<PurchaseOrderWithDetails>>(
                  stream: posStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child:
                            CircularProgressIndicator(color: theme.activeColor),
                      );
                    }

                    final orders = snapshot.data ?? [];

                    if (orders.isEmpty) {
                      return PpEmptyState(
                        icon: Icons.local_shipping_outlined,
                        title: theme.translate('purchase_orders'),
                        message: theme.translate('purchase_orders_desc'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: orders.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = orders[index];
                        return _PurchaseOrderCard(
                          item: item,
                          theme: theme,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'purchase_orders_fab',
            backgroundColor: theme.activeColor,
            foregroundColor: Colors.white,
            tooltip: theme.translate('create_po'),
            onPressed: _showCreatePoDialog,
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String status, String label, ThemeProvider theme) {
    final isSelected = _selectedStatus == status;

    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.activeColor.withValues(alpha: 0.15)
              : theme.secondaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.activeColor : theme.borderColor,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textStyle(
            fontSize: 12,
            color: isSelected ? theme.activeColor : theme.subTextColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderWithDetails item;
  final ThemeProvider theme;

  const _PurchaseOrderCard({
    required this.item,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final po = item.order;
    final (BadgeVariant variant, String statusLabel) = _getStatusBadge(
      po.status,
    );

    return PpCard(
      onTap: () => context.push('/purchase-order/${po.id}'),
      padding: const EdgeInsets.all(16),
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
                  color: theme.activeColor.withValues(alpha: 0.15),
                  borderRadius: AppSpacing.roundedSm,
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: theme.activeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      po.orderNumber,
                      style: theme.textStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Purchase Date & Supplier info
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 11,
                          color: theme.activeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.formatDate(po.orderDate),
                          style: theme.textStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.textColor,
                          ),
                        ),
                        if (item.supplier != null) ...[
                          Text(
                            ' • ',
                            style: theme.textStyle(
                              fontSize: 12,
                              color: theme.subTextColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.supplier!.name,
                              style: theme.textStyle(
                                fontSize: 12,
                                color: theme.subTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (po.expectedArrivalDate != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.event_available_rounded,
                            size: 11,
                            color: theme.subTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${theme.currentLanguage == 'Persian' ? 'تحویل احتمالی' : 'Expected'}: ${DateFormatter.formatDate(po.expectedArrivalDate!)}',
                            style: theme.textStyle(
                              fontSize: 11,
                              color: theme.subTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PpBadge(label: statusLabel, variant: variant),
            ],
          ),
          Divider(
            height: 20,
            color: theme.borderColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${theme.formatNumber(item.items.length)} ${theme.translate('line_items')} (${theme.formatNumber(item.totalReceivedUnits)}/${theme.formatNumber(item.totalOrderedUnits)})',
                style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
              ),
              Text(
                CurrencyFormatter.formatCents(item.totalCostCents),
                style: theme.textStyle(
                  fontSize: 14,
                  color: theme.activeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  (BadgeVariant, String) _getStatusBadge(String status) {
    switch (status) {
      case 'ordered':
      case 'submitted':
      case 'draft':
        return (BadgeVariant.neutral, theme.translate('draft'));
      case 'partiallyReceived':
      case 'partially_received':
        return (BadgeVariant.warning, theme.translate('partially_received'));
      case 'received':
      case 'completed':
        return (BadgeVariant.success, theme.translate('received'));
      case 'cancelled':
        return (BadgeVariant.error, theme.translate('cancelled'));
      default:
        return (BadgeVariant.neutral, theme.translate('draft'));
    }
  }
}
