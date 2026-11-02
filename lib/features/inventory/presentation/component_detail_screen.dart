import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../../../core/widgets/pp_stat_card.dart';
import '../../scanning/presentation/component_qr_sheet.dart';
import '../../stock_movements/data/stock_movements_repository.dart';
import '../../stock_movements/presentation/adjust_stock_dialog.dart';
import '../../stock_movements/presentation/receive_stock_dialog.dart';
import '../../stock_movements/presentation/transfer_stock_dialog.dart';
import '../../stock_movements/presentation/use_stock_dialog.dart';
import '../../suppliers/data/suppliers_repository.dart';
import '../data/inventory_repository.dart';

class ComponentDetailScreen extends ConsumerStatefulWidget {
  final String componentId;

  const ComponentDetailScreen({super.key, required this.componentId});

  @override
  ConsumerState<ComponentDetailScreen> createState() =>
      _ComponentDetailScreenState();
}

class _ComponentDetailScreenState extends ConsumerState<ComponentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    final componentAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentById(widget.componentId);
    final totalStockAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentTotalStock(widget.componentId);
    final balancesAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchBalancesForComponent(widget.componentId);
    final movementsAsync = ref
        .watch(stockMovementsRepositoryProvider)
        .watchMovementsForComponent(widget.componentId);

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        final bg = theme.primaryColor;
        final cardBg = theme.secondaryColor;
        final cardBorder = theme.borderColor;
        final textPri = theme.textColor;
        final textSec = theme.subTextColor;

    return StreamBuilder<Component?>(
      stream: componentAsync,
      builder: (context, compSnapshot) {
        final component = compSnapshot.data;

        if (compSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: bg,
            body: Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            ),
          );
        }

        if (component == null) {
          return Scaffold(
            backgroundColor: bg,
            appBar: AppBar(backgroundColor: bg, elevation: 0),
            body: PpEmptyState(
              icon: Icons.error_outline,
              title: theme.translate('no_components_found'),
              message: theme.translate('no_results_found'),
            ),
          );
        }

        return StreamBuilder<int>(
          stream: totalStockAsync,
          builder: (context, stockSnapshot) {
            final totalStock = stockSnapshot.data ?? 0;
            final isLowStock =
                totalStock > 0 && totalStock <= component.minStockThreshold;
            final isOutOfStock = totalStock <= 0;
            final totalValuation = totalStock * (component.unitCostCents ?? 0);

            return Scaffold(
              backgroundColor: bg,
              appBar: AppBar(
                title: Text(
                  component.internalSku ?? theme.translate('component_detail'),
                  style: theme.textStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                backgroundColor: bg,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.qr_code),
                    tooltip: theme.translate('qr_label'),
                    onPressed: () => ComponentQrSheet.show(context, component),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: theme.translate('edit_component'),
                    onPressed: () =>
                        context.push('/component/${component.id}/edit'),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    color: cardBg,
                    onSelected: (val) async {
                      if (val == 'archive') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              theme.translate('archive_component'),
                              style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            content: Text(
                              '${theme.translate('archive_confirm')} ("${component.name}")',
                              style: theme.textStyle(fontSize: 14),
                            ),
                            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
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
                                      backgroundColor: AppColors.error,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text(
                                      theme.translate('delete'),
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

                        if (confirm == true && context.mounted) {
                          await ref
                              .read(inventoryRepositoryProvider)
                              .archiveComponent(component.id);
                          if (context.mounted) {
                            context.pop();
                            AppSnackBar.show(
                              context,
                              message: theme.translate('archived_success'),
                              type: SnackBarType.success,
                            );
                          }
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.archive_outlined,
                              size: 18,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              theme.translate('archive_component'),
                              style: theme.textStyle(fontSize: 14, color: AppColors.error),
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
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        // Component Header Summary
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        component.name,
                                        style: theme.textStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: textPri,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (isOutOfStock)
                                      PpBadge(
                                        label: theme.translate('out_of_stock'),
                                        variant: BadgeVariant.outOfStock,
                                      )
                                    else if (isLowStock)
                                      PpBadge(
                                        label: theme.translate('low_stock'),
                                        variant: BadgeVariant.lowStock,
                                      )
                                    else
                                      PpBadge(
                                        label: theme.translate('in_stock'),
                                        variant: BadgeVariant.inStock,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    CategoryColors.buildBadge(
                                      component.category,
                                      isDark: theme.isDark,
                                      fontSize: 11,
                                    ),
                                    if (component.manufacturer != null ||
                                        component.manufacturerPartNumber !=
                                            null) ...[
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${component.manufacturer ?? ''}${component.manufacturer != null && component.manufacturerPartNumber != null ? ' • ' : ''}${component.manufacturerPartNumber ?? ''}',
                                          style: theme.textStyle(
                                            fontSize: 12,
                                            color: textSec,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.md),

                                // 4 Stat Cards Grid
                                Row(
                                  children: [
                                    Expanded(
                                      child: PpStatCard(
                                        label: theme.translate('on_hand'),
                                        value:
                                            '${theme.formatNumber(totalStock)} ${component.unitOfMeasure}',
                                        icon: Icons.inventory_2_outlined,
                                        iconColor: isOutOfStock
                                            ? AppColors.error
                                            : (isLowStock
                                                  ? AppColors.warning
                                                  : AppColors.success),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: PpStatCard(
                                        label: theme.translate('min_threshold'),
                                        value:
                                            '${theme.formatNumber(component.minStockThreshold)} ${component.unitOfMeasure}',
                                        icon: Icons.flag_outlined,
                                        iconColor: AppColors.accentBlue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: PpStatCard(
                                        label: theme.translate('avg_cost'),
                                        value: CurrencyFormatter.formatCents(
                                          component.unitCostCents,
                                        ),
                                        icon: Icons.attach_money,
                                        iconColor: textSec,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: PpStatCard(
                                        label: theme.translate('est_value'),
                                        value: CurrencyFormatter.formatCents(
                                          totalValuation,
                                        ),
                                        icon: Icons
                                            .account_balance_wallet_outlined,
                                        iconColor: AppColors.success,
                                        valueColor: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Tab Bar
                        SliverToBoxAdapter(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: cardBorder,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicatorColor: theme.primaryColor,
                              labelColor: theme.primaryColor,
                              unselectedLabelColor: textSec,
                              labelStyle: theme.textStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              unselectedLabelStyle: theme.textStyle(fontSize: 13),
                              tabs: [
                                Tab(text: theme.translate('locations')),
                                Tab(text: theme.translate('specs')),
                                Tab(text: theme.translate('movements')),
                              ],
                            ),
                          ),
                        ),
                      ],
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          // Tab 1: Locations
                          StreamBuilder<List<LocationBalanceItem>>(
                            stream: balancesAsync,
                            builder: (context, balSnapshot) {
                              final balances = balSnapshot.data ?? [];

                              if (balances.isEmpty) {
                                return PpEmptyState(
                                  icon: Icons.location_off_outlined,
                                  title: theme.currentLanguage == 'Persian'
                                      ? 'در هیچ مکانی ذخیره نشده است'
                                      : 'Not Stored In Any Location',
                                  message: theme.currentLanguage == 'Persian'
                                      ? 'موجودی این قطعه را به یکی از قفسه‌ها اضافه یا منتقل کنید.'
                                      : 'Receive or transfer stock into a storage location.',
                                );
                              }

                              return ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: balances.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final b = balances[index];
                                  return PpCard(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    backgroundColor: cardBg,
                                    borderColor: cardBorder,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: theme.activeColor.withValues(alpha: 0.15),
                                            borderRadius: AppSpacing.roundedSm,
                                          ),
                                          child: Icon(
                                            Icons.place,
                                            color: theme.activeColor,
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
                                                b.location.name,
                                                style: theme.textStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: textPri,
                                                ),
                                              ),
                                              if (b.location.code != null)
                                                Text(
                                                  b.location.code!,
                                                  style: theme.textStyle(
                                                    fontSize: 11,
                                                    color: textSec,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${theme.formatNumber(b.quantity)} ${component.unitOfMeasure}',
                                          style: theme.textStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textPri,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: Icon(
                                            Icons.tune,
                                            color: textSec,
                                            size: 18,
                                          ),
                                          tooltip: theme.translate('adjust_stock'),
                                          onPressed: () =>
                                              AdjustStockDialog.show(
                                                context,
                                                component: component,
                                                location: b.location,
                                                currentQuantity: b.quantity,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          // Tab 2: Specs & Metadata
                          _SpecificationsTab(component: component, theme: theme),

                          // Tab 3: Movement Ledger Audit
                          StreamBuilder<List<StockMovement>>(
                            stream: movementsAsync,
                            builder: (context, movSnapshot) {
                              final movements = movSnapshot.data ?? [];

                              if (movements.isEmpty) {
                                return PpEmptyState(
                                  icon: Icons.history,
                                  title: theme.translate('activity_ledger'),
                                  message: theme.translate('activity_ledger_desc'),
                                );
                              }

                              return ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: movements.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final m = movements[index];
                                  final isPositive = m.quantityDelta > 0;
                                  return PpCard(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    backgroundColor: cardBg,
                                    borderColor: cardBorder,
                                    child: Row(
                                      children: [
                                        Icon(
                                          isPositive
                                              ? Icons.add_circle_outline
                                              : Icons.remove_circle_outline,
                                          color: isPositive
                                              ? AppColors.success
                                              : AppColors.warning,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${m.movementType} ${m.notes != null ? '• ${m.notes}' : ''}',
                                                style: theme.textStyle(
                                                  fontSize: 13,
                                                  color: textPri,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                DateFormatter.formatDateTime(
                                                  m.createdAt,
                                                ),
                                                style: theme.textStyle(fontSize: 11, color: textSec),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${isPositive ? '+' : ''}${theme.formatNumber(m.quantityDelta)} ${component.unitOfMeasure}',
                                          style: theme.textStyle(
                                            fontSize: 13,
                                            color: isPositive
                                                ? AppColors.success
                                                : textPri,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Buttons: Use, Receive, Transfer
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: cardBg,
                      border: Border(
                        top: BorderSide(color: cardBorder, width: 1),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: PpButton(
                              label: theme.translate('use'),
                              variant: PpButtonVariant.secondary,
                              icon: Icons.upload,
                              onPressed: totalStock > 0
                                  ? () => UseStockDialog.show(
                                      context,
                                      initialComponent: component,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PpButton(
                              label: theme.translate('receive'),
                              icon: Icons.download,
                              onPressed: () => ReceiveStockDialog.show(
                                context,
                                initialComponent: component,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PpButton(
                              label: theme.translate('transfer'),
                              variant: PpButtonVariant.outline,
                              icon: Icons.sync_alt,
                              onPressed: totalStock > 0
                                  ? () => TransferStockDialog.show(
                                      context,
                                      initialComponent: component,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  },
);
  }
}

class _SpecificationsTab extends ConsumerWidget {
  final Component component;
  final ThemeProvider theme;

  const _SpecificationsTab({required this.component, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplierAsync = component.defaultSupplierId != null
        ? ref
              .watch(suppliersRepositoryProvider)
              .watchSupplierById(component.defaultSupplierId!)
        : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SpecRow(label: theme.translate('sku'), value: component.internalSku ?? '--', theme: theme),
        _SpecRow(label: theme.translate('manufacturer'), value: component.manufacturer ?? '--', theme: theme),
        _SpecRow(
          label: theme.translate('mpn'),
          value: component.manufacturerPartNumber ?? '--',
          theme: theme,
        ),
        _SpecRow(
          label: theme.translate('package'),
          value: component.packageFootprint ?? '--',
          theme: theme,
        ),
        _SpecRow(label: theme.translate('min_stock'), value: '${theme.formatNumber(component.minStockThreshold)} ${component.unitOfMeasure}', theme: theme),
        _SpecRow(
          label: theme.translate('target_stock'),
          value: component.targetStockQuantity != null
              ? '${theme.formatNumber(component.targetStockQuantity)} ${component.unitOfMeasure}'
              : '--',
          theme: theme,
        ),
        if (component.defaultSupplierId != null)
          StreamBuilder<Supplier?>(
            stream: supplierAsync,
            builder: (context, snapshot) {
              return _SpecRow(
                label: theme.translate('default_supplier'),
                value: snapshot.data?.name ?? '--',
                theme: theme,
              );
            },
          ),
        _SpecRow(label: theme.translate('datasheet'), value: component.datasheetUrl ?? '--', theme: theme),
        _SpecRow(label: theme.translate('tags'), value: component.tags ?? '--', theme: theme),
        if (component.description != null &&
            component.description!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            theme.translate('description'),
            style: theme.textStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.subTextColor,
            ),
          ),
          const SizedBox(height: 4),
          PpCard(
            padding: const EdgeInsets.all(12),
            backgroundColor: theme.secondaryColor,
            borderColor: theme.borderColor,
            child: Text(
              component.description!,
              style: theme.textStyle(fontSize: 13, color: theme.textColor),
            ),
          ),
        ],
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeProvider theme;

  const _SpecRow({required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    final textPri = theme.textColor;
    final textSec = theme.subTextColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textStyle(
                fontSize: 12,
                color: textSec,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPri,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
