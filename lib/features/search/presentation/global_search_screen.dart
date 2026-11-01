import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../inventory/data/inventory_repository.dart';
import '../../locations/data/locations_repository.dart';
import '../../projects/data/projects_repository.dart';
import '../../suppliers/data/suppliers_repository.dart';

enum SearchEntityType { component, location, project, supplier }

class SearchResultItem {
  final SearchEntityType type;
  final String title;
  final String subtitle;
  final String route;
  final String? badgeText;

  const SearchResultItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.route,
    this.badgeText,
  });
}

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _selectedFilter = 'All'; // All, Components, Locations, Projects, Suppliers

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final componentsAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentsWithStock(query: _query);
    final locationsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchAllLocations();
    final projectsAsync = ref
        .watch(projectsRepositoryProvider)
        .watchAllProjects();
    final suppliersAsync = ref
        .watch(suppliersRepositoryProvider)
        .watchAllSuppliers(query: _query);

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
              theme.translate('global_search'),
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
          body: Column(
            children: [
              // Search Input
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
                    autofocus: true,
                    cursorColor: theme.activeColor,
                    style: theme.textStyle(fontSize: 14, color: theme.textColor),
                    decoration: InputDecoration(
                      hintText: theme.translate('search_workshop_hint'),
                      hintStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                      prefixIcon: Icon(Icons.search_rounded, color: theme.activeColor, size: 20),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: theme.subTextColor,
                                size: 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _query = '';
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
                    onChanged: (val) => setState(() => _query = val),
                  ),
                ),
              ),

              // Filters row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip('All', theme.translate('filter_all'), theme),
                    const SizedBox(width: 6),
                    _buildFilterChip('Components', theme.translate('components'), theme),
                    const SizedBox(width: 6),
                    _buildFilterChip('Locations', theme.translate('locations'), theme),
                    const SizedBox(width: 6),
                    _buildFilterChip('Projects', theme.translate('projects'), theme),
                    const SizedBox(width: 6),
                    _buildFilterChip('Suppliers', theme.translate('supplier'), theme),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Search Results
              Expanded(
                child: _query.trim().isEmpty
                    ? PpEmptyState(
                        icon: Icons.search_rounded,
                        title: theme.translate('search_results'),
                        message: theme.translate('search_workshop_hint'),
                      )
                    : StreamBuilder<List<SearchResultItem>>(
                        stream: _combineResults(
                          componentsAsync,
                          locationsAsync,
                          projectsAsync,
                          suppliersAsync,
                          theme,
                        ),
                        builder: (context, snapshot) {
                          final items = snapshot.data ?? [];

                          if (items.isEmpty) {
                            return PpEmptyState(
                              icon: Icons.search_off_rounded,
                              title: theme.translate('no_results_found'),
                              message: '$_query: ${theme.translate('no_components_found')}',
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            itemCount: items.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _SearchResultTile(item: item, theme: theme);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String filter, String label, ThemeProvider theme) {
    final isSelected = _selectedFilter == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = filter),
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
              color: isSelected ? theme.activeColor : theme.subTextColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  Stream<List<SearchResultItem>> _combineResults(
    Stream<List<ComponentWithStock>> componentsStream,
    Stream<List<dynamic>> locationsStream,
    Stream<List<ProjectWithBomSummary>> projectsStream,
    Stream<List<dynamic>> suppliersStream,
    ThemeProvider theme,
  ) async* {
    final compList = await componentsStream.first;
    final locList = await locationsStream.first;
    final projList = await projectsStream.first;
    final supList = await suppliersStream.first;

    final term = _query.trim().toLowerCase();
    final List<SearchResultItem> results = [];

    // Components
    if (_selectedFilter == 'All' || _selectedFilter == 'Components') {
      for (final c in compList) {
        results.add(
          SearchResultItem(
            type: SearchEntityType.component,
            title: c.component.name,
            subtitle:
                '${c.component.category} • SKU: ${c.component.internalSku ?? '--'}',
            route: '/component/${c.component.id}',
            badgeText: '${theme.formatNumber(c.totalStock)} ${c.component.unitOfMeasure}',
          ),
        );
      }
    }

    // Locations
    if (_selectedFilter == 'All' || _selectedFilter == 'Locations') {
      for (final l in locList) {
        if (l.name.toLowerCase().contains(term) ||
            (l.code?.toLowerCase().contains(term) ?? false)) {
          results.add(
            SearchResultItem(
              type: SearchEntityType.location,
              title: l.name,
              subtitle: l.code ?? theme.translate('location'),
              route: '/location/${l.id}',
              badgeText: theme.translate('location'),
            ),
          );
        }
      }
    }

    // Projects
    if (_selectedFilter == 'All' || _selectedFilter == 'Projects') {
      for (final p in projList) {
        if (p.project.name.toLowerCase().contains(term)) {
          results.add(
            SearchResultItem(
              type: SearchEntityType.project,
              title: p.project.name,
              subtitle: p.project.status,
              route: '/project/${p.project.id}',
              badgeText: theme.translate('projects'),
            ),
          );
        }
      }
    }

    // Suppliers
    if (_selectedFilter == 'All' || _selectedFilter == 'Suppliers') {
      for (final s in supList) {
        results.add(
          SearchResultItem(
            type: SearchEntityType.supplier,
            title: s.name,
            subtitle: s.email ?? s.website ?? theme.translate('supplier'),
            route: '/suppliers',
            badgeText: theme.translate('supplier'),
          ),
        );
      }
    }

    yield results;
  }
}

class _SearchResultTile extends StatelessWidget {
  final SearchResultItem item;
  final ThemeProvider theme;

  const _SearchResultTile({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = _getIconAndColor();

    return PpCard(
      onTap: () => context.push(item.route),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      backgroundColor: theme.secondaryColor,
      borderColor: theme.borderColor,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppSpacing.roundedSm,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textColor),
                ),
                Text(
                  item.subtitle,
                  style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
                ),
              ],
            ),
          ),
          if (item.badgeText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.isDark ? const Color(0xFF262A30) : const Color(0xFFEAEFF5),
                borderRadius: AppSpacing.roundedSm,
              ),
              child: Text(
                item.badgeText!,
                style: theme.textStyle(
                  fontSize: 11,
                  color: theme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  (IconData, Color) _getIconAndColor() {
    switch (item.type) {
      case SearchEntityType.component:
        return (Icons.memory_rounded, theme.activeColor);
      case SearchEntityType.location:
        return (Icons.place_rounded, AppColors.accentBlue);
      case SearchEntityType.project:
        return (Icons.build_outlined, AppColors.warning);
      case SearchEntityType.supplier:
        return (Icons.storefront_rounded, AppColors.info);
    }
  }
}
