import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/category_colors.dart';
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
  int _touchedIndex = -1;

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

              // Category Breakdown Donut Chart (Redesigned per Neumorphic Template)
              StreamBuilder<DashboardSummary>(
                stream: summaryAsync,
                builder: (context, summarySnapshot) {
                  final summary = summarySnapshot.data;
                  final totalValuation = summary?.totalValuationCents ?? 0;
                  final totalParts = summary?.totalComponents ?? 0;

                  return StreamBuilder<List<CategoryBreakdownItem>>(
                    stream: categoriesAsync,
                    builder: (context, catSnapshot) {
                      final categories = catSnapshot.data ?? [];

                      if (categories.isEmpty) {
                        return PpCard(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: theme.secondaryColor,
                          borderColor: theme.borderColor,
                          child: Center(
                            child: Text(
                              theme.translate('no_categories_stock'),
                              style: theme.textStyle(
                                fontSize: 13,
                                color: theme.subTextColor,
                              ),
                            ),
                          ),
                        );
                      }

                      final hasSelection = _touchedIndex >= 0 &&
                          _touchedIndex < categories.length;
                      final selectedItem =
                          hasSelection ? categories[_touchedIndex] : null;

                      return PpCard(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: theme.secondaryColor,
                        borderColor: theme.borderColor,
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Title & Reset Button
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  theme.translate('category_breakdown'),
                                  style: theme.textStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textColor,
                                  ),
                                ),
                                if (hasSelection)
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _touchedIndex = -1),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.activeColor
                                            .withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        theme.currentLanguage == 'Persian'
                                            ? 'نمایش همه'
                                            : 'Show All',
                                        style: theme.textStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: theme.activeColor,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Neumorphic Donut Chart Outer Track (Matching Template)
                            Center(
                              child: Container(
                                width: 232,
                                height: 232,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.isDark
                                      ? const Color(0xFF131C28)
                                      : const Color(0xFFE8EEF5),
                                  border: Border.all(
                                    color: theme.isDark
                                        ? Colors.white.withValues(alpha: 0.06)
                                        : Colors.white.withValues(alpha: 0.8),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.isDark
                                          ? Colors.black.withValues(alpha: 0.6)
                                          : const Color(0x30A8B8CC),
                                      offset: const Offset(4, 6),
                                      blurRadius: 14,
                                      spreadRadius: 1,
                                    ),
                                    BoxShadow(
                                      color: theme.isDark
                                          ? Colors.white.withValues(alpha: 0.03)
                                          : Colors.white,
                                      offset: const Offset(-4, -5),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Donut Chart Slices (Clean & uncrowded without numbers inside slices)
                                    PieChart(
                                      PieChartData(
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event,
                                              pieTouchResponse) {
                                            setState(() {
                                              if (!event
                                                      .isInterestedForInteractions ||
                                                  pieTouchResponse == null ||
                                                  pieTouchResponse
                                                          .touchedSection ==
                                                      null) {
                                                return;
                                              }
                                              final index = pieTouchResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                              if (index >= 0 &&
                                                  index < categories.length) {
                                                _touchedIndex =
                                                    _touchedIndex == index
                                                        ? -1
                                                        : index;
                                              }
                                            });
                                          },
                                        ),
                                        borderData: FlBorderData(show: false),
                                        sectionsSpace: 3.5,
                                        centerSpaceRadius: 65,
                                        startDegreeOffset: -90,
                                        sections: categories
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final i = entry.key;
                                          final item = entry.value;
                                          final isTouched = i == _touchedIndex;
                                          final color =
                                              CategoryColors.getColor(
                                                  item.category);

                                          return PieChartSectionData(
                                            color: color,
                                            value: item.percentage > 0
                                                ? item.percentage
                                                : 0.1,
                                            showTitle: false,
                                            radius: isTouched ? 36.0 : 30.0,
                                          );
                                        }).toList(),
                                      ),
                                    ),

                                    // Floating Neumorphic Center Disc (Matching Template)
                                    Container(
                                      width: 114,
                                      height: 114,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.isDark
                                            ? const Color(0xFF1B2636)
                                            : const Color(0xFFEEF3F8),
                                        border: Border.all(
                                          color: theme.isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.1)
                                              : Colors.white,
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.isDark
                                                ? Colors.black
                                                    .withValues(alpha: 0.7)
                                                : const Color(0x359AAEC4),
                                            offset: const Offset(3, 4),
                                            blurRadius: 8,
                                          ),
                                          BoxShadow(
                                            color: theme.isDark
                                                ? Colors.white
                                                    .withValues(alpha: 0.05)
                                                : Colors.white,
                                            offset: const Offset(-3, -3),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              hasSelection
                                                  ? CategoryColors
                                                      .getSingularCategory(
                                                      selectedItem!.category,
                                                      isPersian: theme
                                                              .currentLanguage ==
                                                          'Persian',
                                                    )
                                                  : (theme.currentLanguage ==
                                                          'Persian'
                                                      ? 'ارزش کل'
                                                      : 'Total Value'),
                                              style: theme.textStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                                color: hasSelection
                                                    ? CategoryColors.getColor(
                                                        selectedItem!.category)
                                                    : theme.subTextColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 2),
                                            Builder(
                                              builder: (_) {
                                                final valParts =
                                                    CurrencyFormatter
                                                        .formatCentsParts(
                                                  hasSelection
                                                      ? selectedItem!
                                                          .totalValuationCents
                                                      : totalValuation,
                                                  compact: true,
                                                );
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      valParts.amount,
                                                      style: theme.textStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: theme.textColor,
                                                        letterSpacing: -0.5,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    if (valParts
                                                        .unit.isNotEmpty)
                                                      Text(
                                                        valParts.unit,
                                                        style: theme.textStyle(
                                                          fontSize: 10.5,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: theme
                                                              .subTextColor,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 1,
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              hasSelection
                                                  ? '${theme.formatNumber(selectedItem!.percentage.toStringAsFixed(1))}% • ${theme.formatNumber(selectedItem.totalUnits)} pcs'
                                                  : '${theme.formatNumber(totalParts)} parts',
                                              style: theme.textStyle(
                                                fontSize: 10,
                                                color: theme.subTextColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Category Breakdown List (Legend matching template bullet style)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categories.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final item = categories[index];
                                final isSelected = index == _touchedIndex;
                                final color =
                                    CategoryColors.getColor(item.category);

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _touchedIndex =
                                          isSelected ? -1 : index;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? color.withValues(
                                              alpha: theme.isDark ? 0.20 : 0.12)
                                          : theme.primaryColor
                                              .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSelected
                                            ? color
                                            : theme.borderColor,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: color
                                                    .withValues(alpha: 0.5),
                                                blurRadius: 4,
                                                spreadRadius: 0.5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            item.category,
                                            style: theme.textStyle(
                                              fontSize: 14,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w600,
                                              color: isSelected
                                                  ? (theme.isDark
                                                      ? Colors.white
                                                      : color)
                                                  : theme.textColor,
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
                                            compact: true,
                                          ),
                                          style: theme.textStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected
                                                ? (theme.isDark
                                                    ? color
                                                    : color)
                                                : theme.subTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
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
