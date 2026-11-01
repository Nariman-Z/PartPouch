import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/pp_card.dart';
import '../data/reports_repository.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int _selectedDays = 30; // 7, 30, 90, 0 (all)

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final summaryAsync = ref
        .watch(reportsRepositoryProvider)
        .watchDashboardSummary();
    final categoriesAsync = ref
        .watch(reportsRepositoryProvider)
        .watchCategoryBreakdown();
    final topUsedAsync = ref
        .watch(reportsRepositoryProvider)
        .watchTopUsedComponents(days: _selectedDays);

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
              theme.translate('reports_and_analytics'),
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
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Time Period Filter
              Row(
                children: [
                  _buildPeriodTab(7, theme.translate('period_7d'), theme),
                  const SizedBox(width: 8),
                  _buildPeriodTab(30, theme.translate('period_30d'), theme),
                  const SizedBox(width: 8),
                  _buildPeriodTab(90, theme.translate('period_90d'), theme),
                  const SizedBox(width: 8),
                  _buildPeriodTab(0, theme.translate('period_all'), theme),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Total Inventory Valuation Card
              StreamBuilder<DashboardSummary>(
                stream: summaryAsync,
                builder: (context, snapshot) {
                  final summary = snapshot.data;
                  final val = summary?.totalValuationCents ?? 0;
                  final units = summary?.totalUnits ?? 0;
                  final parts = summary?.totalComponents ?? 0;

                  return PpCard(
                    padding: const EdgeInsets.all(20),
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
                                color: AppColors.successContainer,
                                borderRadius: AppSpacing.roundedSm,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_rounded,
                                color: AppColors.success,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              theme.translate('inventory_value'),
                              style: theme.textStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          CurrencyFormatter.formatCents(val),
                          style: theme.textStyle(
                            color: theme.activeColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          theme
                              .translate('active_parts_stat')
                              .replaceAll('{parts}', theme.formatNumber(parts))
                              .replaceAll('{units}', theme.formatNumber(units)),
                          style: theme.textStyle(
                            fontSize: 12,
                            color: theme.subTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Stock by Category
              Text(
                theme.translate('category_breakdown'),
                style: theme.textStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textColor),
              ),
              const SizedBox(height: AppSpacing.sm),

              StreamBuilder<List<CategoryBreakdownItem>>(
                stream: categoriesAsync,
                builder: (context, snapshot) {
                  final categories = snapshot.data ?? [];

                  if (categories.isEmpty) {
                    return PpCard(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: theme.secondaryColor,
                      borderColor: theme.borderColor,
                      child: Center(
                        child: Text(
                          theme.translate('no_categories_stock'),
                          style: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                        ),
                      ),
                    );
                  }

                  // Color palette for chart
                  final colors = [
                    theme.activeColor,
                    AppColors.accentBlue,
                    AppColors.success,
                    AppColors.warning,
                    AppColors.info,
                    const Color(0xFF9B59B6),
                    const Color(0xFF1ABC9C),
                    const Color(0xFFE67E22),
                  ];

                  return Column(
                    children: [
                      // Pie/Donut Chart
                      SizedBox(
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50,
                            sections: categories.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final item = entry.value;
                              final color = colors[idx % colors.length];

                              return PieChartSectionData(
                                color: color,
                                value: item.percentage,
                                title: '${theme.formatNumber(item.percentage.toStringAsFixed(0))}%',
                                radius: 30,
                                titleStyle: theme.textStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Category Breakdown Table
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final item = categories[index];
                          final color = colors[index % colors.length];

                          return PpCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            backgroundColor: theme.secondaryColor,
                            borderColor: theme.borderColor,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item.category,
                                    style: theme.textStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: theme.textColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${theme.formatNumber(item.totalUnits)} pcs (${theme.formatNumber(item.percentage.toStringAsFixed(1))}%)',
                                  style: theme.textStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  CurrencyFormatter.formatCents(
                                    item.totalValuationCents,
                                  ),
                                  style: theme.textStyle(
                                    fontSize: 12,
                                    color: theme.subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Top Used Components
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    theme.translate('top_used_components'),
                    style: theme.textStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textColor),
                  ),
                  Text(
                    _selectedDays == 0
                        ? theme.translate('all_time')
                        : theme.translate('past_days').replaceAll(
                            '{days}',
                            theme.formatNumber(_selectedDays),
                          ),
                    style: theme.textStyle(
                      fontSize: 12,
                      color: theme.subTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              StreamBuilder<List<TopUsedComponentItem>>(
                stream: topUsedAsync,
                builder: (context, snapshot) {
                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return PpCard(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: theme.secondaryColor,
                      borderColor: theme.borderColor,
                      child: Center(
                        child: Text(
                          theme.translate('no_usage_recorded'),
                          style: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return PpCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        backgroundColor: theme.secondaryColor,
                        borderColor: theme.borderColor,
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: theme.activeColor.withValues(alpha: 0.15),
                                borderRadius: AppSpacing.roundedSm,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                theme.formatNumber(index + 1),
                                style: theme.textStyle(
                                  color: theme.activeColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.component.name,
                                    style: theme.textStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textColor,
                                    ),
                                  ),
                                  Text(
                                    item.component.category,
                                    style: theme.textStyle(
                                      fontSize: 12,
                                      color: theme.subTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warningContainer,
                                borderRadius: AppSpacing.roundedSm,
                              ),
                              child: Text(
                                '${theme.formatNumber(item.unitsUsed)} ${item.component.unitOfMeasure} ${theme.currentLanguage == "Persian" ? "مصرف" : "used"}',
                                style: theme.textStyle(
                                  fontSize: 11,
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodTab(int days, String label, ThemeProvider theme) {
    final isSelected = _selectedDays == days;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDays = days),
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
            style: theme.textStyle(
              fontSize: 12,
              color: isSelected ? theme.activeColor : theme.subTextColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
