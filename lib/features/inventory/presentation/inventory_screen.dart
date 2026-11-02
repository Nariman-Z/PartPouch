import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/category_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/pp_badge.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../data/inventory_repository.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStockFilter = 'All'; // All, In Stock, Low Stock, Out of Stock
  String? _selectedCategory;
  String _sortBy = 'name_asc';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    final categoriesAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchAllCategories();

    final componentsStream = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentsWithStock(
          query: _searchQuery,
          category: _selectedCategory,
          inStockOnly: _selectedStockFilter == 'In Stock',
          lowStockOnly: _selectedStockFilter == 'Low Stock',
          outOfStockOnly: _selectedStockFilter == 'Out of Stock',
          sortBy: _sortBy,
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
              theme.translate('inventory'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.sort_rounded, color: theme.activeColor),
                tooltip: theme.currentLanguage == 'Persian' ? 'مرتب‌سازی' : 'Sort by',
                color: theme.secondaryColor,
                onSelected: (val) => setState(() => _sortBy = val),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'name_asc',
                    child: Text(
                      theme.currentLanguage == 'Persian' ? 'نام (الف - ی)' : 'Name (A-Z)',
                      style: theme.textStyle(fontSize: 13, color: theme.textColor),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'name_desc',
                    child: Text(
                      theme.currentLanguage == 'Persian' ? 'نام (ی - الف)' : 'Name (Z-A)',
                      style: theme.textStyle(fontSize: 13, color: theme.textColor),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'stock_desc',
                    child: Text(
                      theme.currentLanguage == 'Persian' ? 'بیشترین موجودی' : 'Highest Stock',
                      style: theme.textStyle(fontSize: 13, color: theme.textColor),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'stock_asc',
                    child: Text(
                      theme.currentLanguage == 'Persian' ? 'کمترین موجودی' : 'Lowest Stock',
                      style: theme.textStyle(fontSize: 13, color: theme.textColor),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'updated_desc',
                    child: Text(
                      theme.currentLanguage == 'Persian' ? 'آخرین تغییرات' : 'Recently Updated',
                      style: theme.textStyle(fontSize: 13, color: theme.textColor),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: theme.activeColor,
                ),
                onPressed: () => context.push('/scan'),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.borderColor, width: 1),
                  ),
                  child: TextField(
                    controller: _searchController,
                    cursorColor: theme.activeColor,
                    style: theme.textStyle(fontSize: 14, color: theme.textColor),
                    decoration: InputDecoration(
                      hintText: theme.translate('search_components_hint'),
                      hintStyle: theme.textStyle(
                        fontSize: 13,
                        color: theme.subTextColor,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.subTextColor,
                        size: 20,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: theme.subTextColor,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
              ),

              // Stock Status Filter Chips (All, In Stock, Low Stock, Out)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStockFilterChip('All', theme.translate('filter_all'), theme),
                    const SizedBox(width: 8),
                    _buildStockFilterChip('In Stock', theme.translate('in_stock'), theme),
                    const SizedBox(width: 8),
                    _buildStockFilterChip('Low Stock', theme.translate('filter_low_stock'), theme),
                    const SizedBox(width: 8),
                    _buildStockFilterChip('Out of Stock', theme.translate('filter_out_of_stock'), theme),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Category Pills
              StreamBuilder<List<String>>(
                stream: categoriesAsync,
                builder: (context, snapshot) {
                  final categories = snapshot.data ?? [];
                  if (categories.isEmpty) return const SizedBox.shrink();

                  return SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        final isAll = index == 0;
                        final cat = isAll ? null : categories[index - 1];
                        final isSelected = isAll
                            ? _selectedCategory == null
                            : _selectedCategory == cat;
                        final label =
                            isAll ? theme.translate('all_categories') : cat!;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isAll) {
                                _selectedCategory = null;
                              } else {
                                _selectedCategory = isSelected ? null : cat;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.activeColor.withValues(alpha: 0.15)
                                  : theme.secondaryColor,
                              borderRadius: AppSpacing.roundedSm,
                              border: Border.all(
                                color: isSelected
                                    ? theme.activeColor
                                    : theme.borderColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              label,
                              style: theme.textStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? theme.activeColor
                                    : theme.subTextColor,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Component List Stream
              Expanded(
                child: StreamBuilder<List<ComponentWithStock>>(
                  stream: componentsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: theme.activeColor),
                      );
                    }

                    final components = snapshot.data ?? [];

                    if (components.isEmpty) {
                      return PpEmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: _searchQuery.isNotEmpty
                            ? theme.translate('no_results_found')
                            : theme.translate('no_components_found'),
                        message: _searchQuery.isNotEmpty
                            ? '$_searchQuery: ${theme.translate('no_results_found')}'
                            : theme.translate('onboarding_desc_2'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                      itemCount: components.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = components[index];
                        return _ComponentListItem(item: item, theme: theme);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 84),
            child: FloatingActionButton(
              heroTag: 'inventory_fab',
              backgroundColor: theme.activeColor,
              foregroundColor: Colors.white,
              elevation: 4,
              highlightElevation: 6,
              tooltip: theme.translate('add_component'),
              onPressed: () => context.push('/component/add'),
              child: const Icon(Icons.add_rounded),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStockFilterChip(String filterKey, String label, ThemeProvider theme) {
    final isSelected = _selectedStockFilter == filterKey;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedStockFilter = filterKey),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
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

class _ComponentListItem extends StatelessWidget {
  final ComponentWithStock item;
  final ThemeProvider theme;

  const _ComponentListItem({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    final comp = item.component;

    final (BadgeVariant badgeVariant, String badgeText) = _getStockStatus();

    return PpCard(
      onTap: () => context.push('/component/${comp.id}'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      backgroundColor: theme.secondaryColor,
      borderColor: theme.borderColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Component Icon with Category Color
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: CategoryColors.getContainerColor(comp.category,
                  isDark: theme.isDark),
              borderRadius: AppSpacing.roundedSm,
              border: Border.all(
                color: CategoryColors.getBorderColor(comp.category,
                    isDark: theme.isDark),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              _getCategoryIcon(comp.category),
              color: CategoryColors.getForegroundColor(comp.category,
                  isDark: theme.isDark),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        comp.category,
                        style: theme.textStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: CategoryColors.getForegroundColor(
                            comp.category,
                            isDark: theme.isDark,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PpBadge(label: badgeText, variant: badgeVariant),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  comp.name,
                  style: theme.textStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: theme.textColor,
                    height: 1.25,
                  ),
                ),
                if (comp.description != null &&
                    comp.description!.trim().isNotEmpty &&
                    comp.description!.trim() != comp.name.trim()) ...[
                  const SizedBox(height: 2),
                  Text(
                    comp.description!,
                    style: theme.textStyle(
                      fontSize: 11.5,
                      color: theme.subTextColor,
                      height: 1.2,
                    ),
                  ),
                ],
                if (comp.packageFootprint != null &&
                    comp.packageFootprint!.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    comp.packageFootprint!,
                    style: theme.textStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: theme.subTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '${theme.formatNumber(item.totalStock)} ${comp.unitOfMeasure}',
                      style: theme.textStyle(
                        fontSize: 12.5,
                        color: item.totalStock > 0
                            ? theme.textColor
                            : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.locationDisplay.isNotEmpty) ...[
                      Flexible(
                        child: Text(
                          ' • ${item.locationDisplay}',
                          style: theme.textStyle(
                            fontSize: 11,
                            color: theme.subTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (comp.unitCostCents != null)
                      Text(
                        CurrencyFormatter.formatCents(
                          comp.unitCostCents,
                          compact: true,
                        ),
                        style: theme.textStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.activeColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (BadgeVariant, String) _getStockStatus() {
    if (item.isOutOfStock) {
      return (BadgeVariant.outOfStock, theme.translate('out_of_stock'));
    } else if (item.isLowStock) {
      return (BadgeVariant.lowStock, theme.translate('low_stock'));
    } else {
      return (BadgeVariant.inStock, theme.translate('in_stock'));
    }
  }

  IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('micro') ||
        lower.contains('mcu') ||
        lower.contains('esp') ||
        lower.contains('cpu') ||
        lower.contains('arduino') ||
        lower.contains('stm32')) {
      return Icons.developer_board_rounded;
    } else if (lower.contains('resistor')) {
      return Icons.linear_scale_rounded;
    } else if (lower.contains('display') ||
        lower.contains('screen') ||
        lower.contains('oled') ||
        lower.contains('lcd') ||
        lower.contains('tft')) {
      return Icons.tv_rounded;
    } else if (lower.contains('cap')) {
      return Icons.battery_charging_full_rounded;
    } else if (lower.contains('inductor') || lower.contains('coil')) {
      return Icons.waves_rounded;
    } else if (lower.contains('diode') || lower.contains('rectifier')) {
      return Icons.arrow_forward_rounded;
    } else if (lower.contains('led') || lower.contains('opto')) {
      return Icons.lightbulb_outline_rounded;
    } else if (lower.contains('sensor')) {
      return Icons.sensors_rounded;
    } else if (lower.contains('transistor') || lower.contains('mosfet')) {
      return Icons.schema_rounded;
    } else if (lower.contains('power') ||
        lower.contains('regulator') ||
        lower.contains('converter')) {
      return Icons.bolt_rounded;
    } else if (lower.contains('switch') || lower.contains('relay')) {
      return Icons.toggle_on_rounded;
    } else if (lower.contains('module') || lower.contains('shield')) {
      return Icons.extension_rounded;
    } else if (lower.contains('connector') ||
        lower.contains('header') ||
        lower.contains('terminal')) {
      return Icons.cable_rounded;
    } else if (lower.contains('hardware') || lower.contains('screw')) {
      return Icons.build_rounded;
    }
    return Icons.memory_rounded;
  }
}
