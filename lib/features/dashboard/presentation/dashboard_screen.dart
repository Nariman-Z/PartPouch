import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/formatting/date_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/partpouch_logo_title.dart';
import '../../../core/widgets/pp_card.dart';
import '../../inventory/data/inventory_repository.dart';
import '../../reports/data/reports_repository.dart';
import '../../stock_movements/data/stock_movements_repository.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeProvider();
    final summaryAsync =
        ref.watch(reportsRepositoryProvider).watchDashboardSummary();
    final recentMovementsAsync = ref
        .watch(stockMovementsRepositoryProvider)
        .watchRecentMovements(limit: 15);

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.primaryColor,
          body: SafeArea(
            child: StreamBuilder<DashboardSummary>(
              stream: summaryAsync,
              builder: (context, summarySnapshot) {
                final summary = summarySnapshot.data ??
                    const DashboardSummary(
                      totalComponents: 0,
                      totalUnits: 0,
                      lowStockCount: 0,
                      outOfStockCount: 0,
                      totalValuationCents: 0,
                    );

                return CustomScrollView(
                  slivers: [
                    // 1. Centered Header: Logo icon, PartPouch brand, subtitle
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/icons/app_icon_512.webp',
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),

                            const PartPouchBrandTitle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                            const SizedBox(height: 4),

                            Text(
                              theme.translate('dashboard_title'),
                              style: theme.textStyle(
                                color: theme.subTextColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 2. Search Bar: At the top of the cards
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: PpCard(
                          onTap: () => context.push('/search'),
                          backgroundColor: theme.secondaryColor,
                          borderColor: theme.borderColor,
                          borderRadius: BorderRadius.circular(16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: theme.subTextColor,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  theme.currentLanguage == 'Persian'
                                      ? 'جستجوی قطعه، مکان نگهداری، SKU...'
                                      : 'Search components, locations, SKU...',
                                  style: theme.textStyle(
                                    fontSize: 14,
                                    color: theme.subTextColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 3. 6 Stat Cards in a 2-Column Grid
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.42,
                        children: [
                          // Card 1: Total Items
                          _DashboardStatCard(
                            title: theme.translate('total_items'),
                            value: theme.formatNumber(summary.totalComponents),
                            iconWidget: Icon(
                              Icons.crop_free,
                              color: theme.subTextColor,
                              size: 20,
                            ),
                            onTap: () => context.push('/inventory'),
                            theme: theme,
                          ),

                          // Card 2: Total Quantity
                          _DashboardStatCard(
                            title: theme.translate('total_quantity'),
                            value: theme.formatNumber(
                              NumberFormat('#,###').format(summary.totalUnits),
                            ),
                            iconWidget: Icon(
                              Icons.all_inbox_outlined,
                              color: theme.subTextColor,
                              size: 20,
                            ),
                            onTap: () => context.push('/inventory'),
                            theme: theme,
                          ),

                          // Card 3: Inventory Value
                          _DashboardStatCard(
                            title: theme.translate('inventory_value'),
                            value: theme.formatNumber(
                              CurrencyFormatter.formatCents(
                                summary.totalValuationCents,
                              ),
                            ),
                            iconWidget: Icon(
                              Icons.donut_large_rounded,
                              color: AppColors.secondary,
                              size: 20,
                            ),
                            onTap: () => context.push('/reports'),
                            theme: theme,
                          ),

                          // Card 4: Low Stock
                          _DashboardStatCard(
                            title: theme.translate('low_stock'),
                            value: theme.formatNumber(summary.lowStockCount),
                            iconWidget: const Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.warning,
                              size: 20,
                            ),
                            onTap: () => context.push('/low-stock'),
                            theme: theme,
                          ),

                          // Card 5: Out of Stock
                          _DashboardStatCard(
                            title: theme.translate('out_of_stock'),
                            value: theme.formatNumber(summary.outOfStockCount),
                            iconWidget: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.priority_high,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                            onTap: () => context.push('/low-stock'),
                            theme: theme,
                          ),

                          // Card 6: To Reorder
                          _DashboardStatCard(
                            title: theme.translate('to_reorder'),
                            value: theme.formatNumber(
                              summary.lowStockCount + summary.outOfStockCount,
                            ),
                            iconWidget: const Icon(
                              Icons.sync,
                              color: AppColors.success,
                              size: 20,
                            ),
                            onTap: () => context.push('/purchasing'),
                            theme: theme,
                          ),
                        ],
                      ),
                    ),

                    // 4. Section Title: Recent Activity
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                        child: Text(
                          theme.translate('recent_activity'),
                          style: theme.textStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: theme.textColor,
                          ),
                        ),
                      ),
                    ),

                    // 5. Recent Movements List
                    StreamBuilder<List<StockMovement>>(
                      stream: recentMovementsAsync,
                      builder: (context, movSnapshot) {
                        final movements = movSnapshot.data ?? [];

                        if (movements.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 36,
                              ),
                              child: Center(
                                child: Text(
                                  theme.currentLanguage == 'Persian'
                                      ? 'هنوز فعالیتی ثبت نشده است.'
                                      : 'No recent activity yet.',
                                  style: theme.textStyle(
                                    fontSize: 14,
                                    color: theme.subTextColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              final movement = movements[index];
                              return _RecentMovementTile(
                                movement: movement,
                                theme: theme,
                              );
                            }, childCount: movements.length),
                          ),
                        );
                      },
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget iconWidget;
  final VoidCallback? onTap;
  final ThemeProvider theme;

  const _DashboardStatCard({
    required this.title,
    required this.value,
    required this.iconWidget,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> shadows = theme.isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.42),
              blurRadius: 14,
              offset: const Offset(4, 6),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.035),
              blurRadius: 8,
              offset: const Offset(-2, -2),
            ),
          ]
        : [
            BoxShadow(
              color: const Color(0xFFCAD6E4).withValues(alpha: 0.65),
              blurRadius: 14,
              offset: const Offset(4, 6),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 12,
              offset: Offset(-3, -3),
            ),
          ];

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE2E8F0),
          width: 1.1,
        ),
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: theme.activeColor.withValues(alpha: 0.14),
          highlightColor: theme.elevatedColor.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textStyle(
                    color: theme.subTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: theme.textStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: theme.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: theme.isDark
                            ? const Color(0xFF101B26)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: theme.isDark ? 0.3 : 0.06,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(child: iconWidget),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentMovementTile extends ConsumerWidget {
  final StockMovement movement;
  final ThemeProvider theme;

  const _RecentMovementTile({
    required this.movement,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentById(movement.componentId);

    return StreamBuilder<Component?>(
      stream: compAsync,
      builder: (context, snapshot) {
        final component = snapshot.data;
        final name = component?.name ??
            (theme.currentLanguage == 'Persian' ? 'قطعه' : 'Component');

        final (IconData icon, Color color, String actionVerb) =
            _getMovementStyle(theme);

        final quantity = theme.formatNumber(movement.quantityDelta.abs());
        final relativeTime = DateFormatter.formatRelative(movement.createdAt);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: theme.secondaryColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.borderColor, width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                if (component != null) {
                  context.push('/component/${component.id}');
                }
              },
              borderRadius: BorderRadius.circular(16),
              splashColor: theme.activeColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // Circular icon badge
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$actionVerb ',
                              style: theme.textStyle(
                                color: theme.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: '$quantity × $name',
                              style: theme.textStyle(
                                color: theme.subTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      relativeTime,
                      style: theme.textStyle(
                        color: theme.subTextColor.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  (IconData, Color, String) _getMovementStyle(ThemeProvider theme) {
    final isFa = theme.currentLanguage == 'Persian';

    switch (movement.movementType) {
      case 'received':
      case 'purchaseOrderReceipt':
        return (
          Icons.arrow_downward_rounded,
          AppColors.success,
          isFa ? 'ورود' : 'Received',
        );
      case 'issued':
        return (
          Icons.arrow_upward_rounded,
          AppColors.error,
          isFa ? 'مصرف' : 'Used',
        );
      case 'transfer':
        return (
          Icons.swap_horiz_rounded,
          AppColors.secondary,
          isFa ? 'انتقال' : 'Moved',
        );
      case 'positiveAdjustment':
        return (
          Icons.add_circle_outline_rounded,
          AppColors.success,
          isFa ? 'تنظیم مثبت' : 'Adjusted',
        );
      case 'negativeAdjustment':
      case 'stocktake_reconciliation':
      default:
        return (
          Icons.tune_rounded,
          AppColors.warning,
          isFa ? 'اصلاح موجودی' : 'Adjusted',
        );
    }
  }
}
