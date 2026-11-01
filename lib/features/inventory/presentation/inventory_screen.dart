import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/formatting/currency_formatter.dart';
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
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(width: 6),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          final isSelected = _selectedCategory == null;
                          return ChoiceChip(
                            label: Text(theme.translate('all_categories')),
                            selected: isSelected,
                            onSelected: (_) =>
                                setState(() => _selectedCategory = null),
                            selectedColor: theme.activeColor.withValues(alpha: 0.15),
                            backgroundColor: theme.secondaryColor,
                            side: BorderSide(
                              color: isSelected
                                  ? theme.activeColor
                                  : theme.borderColor,
                            ),
                            labelStyle: theme.textStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? theme.activeColor
                                  : theme.subTextColor,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          );
                        }

                        final cat = categories[index - 1];
                        final isSelected = _selectedCategory == cat;

                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (_) => setState(
                            () => _selectedCategory = isSelected ? null : cat,
                          ),
                          selectedColor: theme.activeColor.withValues(alpha: 0.15),
                          backgroundColor: theme.secondaryColor,
                          side: BorderSide(
                            color: isSelected
                                ? theme.activeColor
                                : theme.borderColor,
                          ),
                          labelStyle: theme.textStyle(
                            fontSize: 11,
                            color: isSelected
                                ? theme.activeColor
                                : theme.subTextColor,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

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
          padding: const EdgeInsets.symmetric(vertical: 6),
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
              fontSize: 10,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Component Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.activeColor.withValues(alpha: 0.12),
              borderRadius: AppSpacing.roundedSm,
              border: Border.all(color: theme.borderColor, width: 1),
            ),
            alignment: Alignment.center,
            child: Icon(
              _getCategoryIcon(comp.category),
              color: theme.activeColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comp.name,
                        style: theme.textStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PpBadge(label: badgeText, variant: badgeVariant),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${comp.category}${comp.packageFootprint != null ? ' • ${comp.packageFootprint}' : ''}',
                  style: theme.textStyle(
                    fontSize: 12,
                    color: theme.subTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${theme.formatNumber(item.totalStock)} ${comp.unitOfMeasure}',
                      style: theme.textStyle(
                        fontSize: 13,
                        color: item.totalStock > 0
                            ? theme.textColor
                            : AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.locationCount > 0) ...[
                      Text(
                        ' • ${theme.formatNumber(item.locationCount)} ${theme.currentLanguage == 'Persian' ? 'مکان' : (item.locationCount == 1 ? 'location' : 'locations')}',
                        style: theme.textStyle(
                          fontSize: 11,
                          color: theme.subTextColor,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (comp.unitCostCents != null)
                      Text(
                        CurrencyFormatter.formatCents(comp.unitCostCents),
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
        lower.contains('cpu')) {
      return Icons.developer_board;
    } else if (lower.contains('resistor')) {
      return Icons.linear_scale;
    } else if (lower.contains('cap')) {
      return Icons.battery_charging_full;
    } else if (lower.contains('diode') || lower.contains('led')) {
      return Icons.lightbulb_outline;
    } else if (lower.contains('sensor')) {
      return Icons.sensors;
    } else if (lower.contains('display')) {
      return Icons.tv;
    } else if (lower.contains('transistor') || lower.contains('mosfet')) {
      return Icons.schema;
    } else if (lower.contains('connector') || lower.contains('header')) {
      return Icons.cable;
    }
    return Icons.memory;
  }
}
