import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/theme_provider.dart';
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
  String _selectedStatus = 'All'; // All, ordered, partiallyReceived, received, draft

  void _showCreatePoDialog() {
    context.push('/purchasing/new');
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
              IconButton(
                icon: Icon(Icons.add_rounded, color: theme.activeColor),
                tooltip: theme.translate('create_po'),
                onPressed: _showCreatePoDialog,
              ),
            ],
          ),
          body: Column(
            children: [
              // Filter Tabs
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    _buildFilterChip('All', theme.translate('filter_all'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip('ordered', theme.translate('ordered'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip('partiallyReceived', theme.translate('partially_received'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip('received', theme.translate('received'), theme),
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
                        child: CircularProgressIndicator(color: theme.activeColor),
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
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      itemCount: orders.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = orders[index];
                        return _PurchaseOrderCard(item: item, theme: theme);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
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

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedStatus = status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.activeColor.withValues(alpha: 0.15)
                : theme.secondaryColor,
            borderRadius: AppSpacing.roundedSm,
            border: Border.all(
              color: isSelected ? theme.activeColor : theme.borderColor,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyle(
              fontSize: 11,
              color: isSelected ? theme.activeColor : theme.subTextColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderWithDetails item;
  final ThemeProvider theme;

  const _PurchaseOrderCard({required this.item, required this.theme});

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
                        fontWeight: FontWeight.w600,
                        color: theme.textColor,
                      ),
                    ),
                    Text(
                      item.supplier?.name ?? (theme.currentLanguage == 'Persian' ? 'بدون تأمین‌کننده' : 'No Supplier'),
                      style: theme.textStyle(
                        fontSize: 12,
                        color: theme.subTextColor,
                      ),
                    ),
                  ],
                ),
              ),
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
        return (BadgeVariant.primary, theme.translate('ordered'));
      case 'partiallyReceived':
        return (BadgeVariant.warning, theme.translate('partially_received'));
      case 'received':
        return (BadgeVariant.success, theme.translate('received'));
      case 'cancelled':
        return (BadgeVariant.error, theme.translate('cancelled'));
      case 'draft':
      default:
        return (BadgeVariant.neutral, theme.translate('draft'));
    }
  }
}
