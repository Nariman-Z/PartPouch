import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../data/locations_repository.dart';

class LocationsScreen extends ConsumerStatefulWidget {
  const LocationsScreen({super.key});

  @override
  ConsumerState<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends ConsumerState<LocationsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'name_asc';

  // Set of location IDs that are currently expanded
  final Set<String> _expandedLocationIds = {};
  bool _isExpansionInitialized = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddLocationDialog([String? defaultParentId]) {
    showDialog(
      context: context,
      builder: (context) =>
          _AddLocationDialog(defaultParentId: defaultParentId),
    );
  }

  void _toggleExpand(String locationId) {
    setState(() {
      if (_expandedLocationIds.contains(locationId)) {
        _expandedLocationIds.remove(locationId);
      } else {
        _expandedLocationIds.add(locationId);
      }
    });
  }

  LocationStockStats _getCumulativeStats(
    String locationId,
    Map<String, LocationStockStats> directStatsMap,
    Map<String, List<Location>> childrenMap,
  ) {
    final direct = directStatsMap[locationId];
    int count = direct?.componentCount ?? 0;
    int units = direct?.totalUnits ?? 0;
    int value = direct?.totalValueCents ?? 0;

    final children = childrenMap[locationId] ?? [];
    for (final child in children) {
      final childStats =
          _getCumulativeStats(child.id, directStatsMap, childrenMap);
      count += childStats.componentCount;
      units += childStats.totalUnits;
      value += childStats.totalValueCents;
    }

    return LocationStockStats(
      componentCount: count,
      totalUnits: units,
      totalValueCents: value,
    );
  }

  String _buildLocationPath(Location loc, Map<String, Location> locById) {
    final List<String> parts = [];
    String? currentParentId = loc.parentId;
    while (currentParentId != null) {
      final parent = locById[currentParentId];
      if (parent == null) break;
      parts.insert(0, parent.name);
      currentParentId = parent.parentId;
    }
    return parts.join(' > ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final locationsStream =
        ref.watch(locationsRepositoryProvider).watchAllLocations();
    final allStatsStream =
        ref.watch(locationsRepositoryProvider).watchAllLocationStockStats();

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
              theme.translate('locations'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            actions: [
              StreamBuilder<List<Location>>(
                stream: locationsStream,
                builder: (context, snapshot) {
                  final allLocations = snapshot.data ?? [];
                  final branchIds = allLocations
                      .where((l) => allLocations.any((c) => c.parentId == l.id))
                      .map((l) => l.id)
                      .toSet();

                  if (branchIds.isEmpty) return const SizedBox.shrink();

                  final bool allExpanded = branchIds.isNotEmpty &&
                      branchIds.every((id) => _expandedLocationIds.contains(id));

                  return IconButton(
                    icon: Icon(
                      allExpanded
                          ? Icons.unfold_less_rounded
                          : Icons.unfold_more_rounded,
                      color: theme.activeColor,
                    ),
                    tooltip: allExpanded
                        ? theme.translate('collapse_all')
                        : theme.translate('expand_all'),
                    onPressed: () {
                      setState(() {
                        if (allExpanded) {
                          _expandedLocationIds.clear();
                        } else {
                          _expandedLocationIds.addAll(branchIds);
                        }
                      });
                    },
                  );
                },
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.sort_rounded, color: theme.activeColor),
                tooltip: theme.currentLanguage == 'Persian'
                    ? 'مرتب‌سازی'
                    : 'Sort by',
                color: theme.secondaryColor,
                onSelected: (val) => setState(() => _sortBy = val),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'name_asc',
                    child: Text(
                      theme.currentLanguage == 'Persian'
                          ? 'نام (الف - ی)'
                          : 'Name (A-Z)',
                      style: theme.textStyle(
                        fontSize: 13,
                        color: theme.textColor,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'name_desc',
                    child: Text(
                      theme.currentLanguage == 'Persian'
                          ? 'نام (ی - الف)'
                          : 'Name (Z-A)',
                      style: theme.textStyle(
                        fontSize: 13,
                        color: theme.textColor,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'code_asc',
                    child: Text(
                      theme.currentLanguage == 'Persian'
                          ? 'کد مکان'
                          : 'Location Code',
                      style: theme.textStyle(
                        fontSize: 13,
                        color: theme.textColor,
                      ),
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
                    style:
                        theme.textStyle(fontSize: 14, color: theme.textColor),
                    decoration: InputDecoration(
                      hintText: theme.translate('locations_search_hint'),
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

              // Hierarchy Tree & Direct Stats
              Expanded(
                child: StreamBuilder<List<Location>>(
                  stream: locationsStream,
                  builder: (context, locSnapshot) {
                    if (locSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child:
                            CircularProgressIndicator(color: theme.activeColor),
                      );
                    }

                    final allLocations = locSnapshot.data ?? [];

                    if (allLocations.isEmpty) {
                      return PpEmptyState(
                        icon: Icons.account_tree_outlined,
                        title: theme.translate('no_locations_configured'),
                        message: theme.translate('onboarding_desc_3'),
                      );
                    }

                    return StreamBuilder<Map<String, LocationStockStats>>(
                      stream: allStatsStream,
                      builder: (context, statsSnapshot) {
                        final directStatsMap = statsSnapshot.data ?? {};

                        // Map location id -> Location object
                        final Map<String, Location> locById = {
                          for (final l in allLocations) l.id: l,
                        };

                        // Build children map
                        final Map<String, List<Location>> childrenMap = {};
                        for (final loc in allLocations) {
                          if (loc.parentId != null) {
                            childrenMap
                                .putIfAbsent(loc.parentId!, () => [])
                                .add(loc);
                          }
                        }

                        // Auto-expand all branch locations on first load
                        if (!_isExpansionInitialized) {
                          final branchIds = childrenMap.keys.toSet();
                          _expandedLocationIds.addAll(branchIds);
                          _isExpansionInitialized = true;
                        }

                        // If searching, show filtered flat list
                        if (_searchQuery.trim().isNotEmpty) {
                          final filtered = allLocations.where((l) {
                            final term = _searchQuery.trim().toLowerCase();
                            return l.name.toLowerCase().contains(term) ||
                                (l.code?.toLowerCase().contains(term) ?? false);
                          }).toList();

                          if (_sortBy == 'name_desc') {
                            filtered.sort((a, b) => b.name.compareTo(a.name));
                          } else if (_sortBy == 'code_asc') {
                            filtered.sort((a, b) =>
                                (a.code ?? '').compareTo(b.code ?? ''));
                          } else {
                            filtered.sort((a, b) => a.name.compareTo(b.name));
                          }

                          if (filtered.isEmpty) {
                            return PpEmptyState(
                              icon: Icons.search_off_rounded,
                              title: theme.translate('no_results_found'),
                              message:
                                  theme.translate('locations_search_hint'),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final loc = filtered[index];
                              final path = _buildLocationPath(loc, locById);
                              final stats = directStatsMap[loc.id];
                              final units = stats?.totalUnits ?? 0;

                              return Container(
                                decoration: BoxDecoration(
                                  color: theme.secondaryColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    onTap: () =>
                                        context.push('/location/${loc.id}'),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            loc.parentId == null
                                                ? Icons.home_work_outlined
                                                : Icons.inventory_2_outlined,
                                            color: theme.activeColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  loc.name,
                                                  style: theme.textStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: theme.textColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (path.isNotEmpty) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    path,
                                                    style: theme.textStyle(
                                                      fontSize: 12,
                                                      color: theme.subTextColor,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ] else if (loc.description !=
                                                        null &&
                                                    loc.description!
                                                        .isNotEmpty) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    loc.description!,
                                                    style: theme.textStyle(
                                                      fontSize: 12,
                                                      color: theme.subTextColor,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          if (units > 0)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: theme.activeColor
                                                    .withValues(alpha: 0.12),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${theme.formatNumber(units)} pcs',
                                                style: theme.textStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.activeColor,
                                                ),
                                              ),
                                            )
                                          else
                                            Text(
                                              theme
                                                  .translate('empty_location'),
                                              style: theme.textStyle(
                                                fontSize: 12,
                                                color: theme.subTextColor
                                                    .withValues(alpha: 0.7),
                                              ),
                                            ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            size: 18,
                                            color: theme.subTextColor,
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

                        // Build Tree View from Roots
                        final rootLocations = allLocations
                            .where((l) => l.parentId == null)
                            .toList();

                        if (_sortBy == 'name_desc') {
                          rootLocations
                              .sort((a, b) => b.name.compareTo(a.name));
                        } else if (_sortBy == 'code_asc') {
                          rootLocations.sort((a, b) =>
                              (a.code ?? '').compareTo(b.code ?? ''));
                        } else {
                          rootLocations
                              .sort((a, b) => a.name.compareTo(b.name));
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                          itemCount: rootLocations.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final root = rootLocations[index];
                            return _buildRootCard(
                              root,
                              childrenMap,
                              directStatsMap,
                              theme,
                            );
                          },
                        );
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
              heroTag: 'locations_fab',
              backgroundColor: theme.activeColor,
              foregroundColor: Colors.white,
              elevation: 4,
              highlightElevation: 6,
              tooltip: theme.translate('add_location'),
              onPressed: () => _showAddLocationDialog(),
              child: const Icon(Icons.add_rounded),
            ),
          ),
        );
      },
    );
  }

  /// Formats singular / plural pouch count
  String _formatPouchCount(int count, ThemeProvider theme) {
    if (count == 1) {
      return '1 ${theme.translate('pouch')}';
    }
    return '${theme.formatNumber(count)} ${theme.translate('pouches')}';
  }

  /// Builds a top-level root location card with its header and collapsible tree
  Widget _buildRootCard(
    Location root,
    Map<String, List<Location>> childrenMap,
    Map<String, LocationStockStats> directStatsMap,
    ThemeProvider theme,
  ) {
    final children = childrenMap[root.id] ?? [];
    final bool hasChildren = children.isNotEmpty;
    final bool isExpanded = _expandedLocationIds.contains(root.id);
    final cumStats =
        _getCumulativeStats(root.id, directStatsMap, childrenMap);

    // Sort direct children
    if (_sortBy == 'name_desc') {
      children.sort((a, b) => b.name.compareTo(a.name));
    } else if (_sortBy == 'code_asc') {
      children.sort((a, b) => (a.code ?? '').compareTo(b.code ?? ''));
    } else {
      children.sort((a, b) => a.name.compareTo(b.name));
    }

    const double columnWidth = 22.0;
    final Color lineColor = theme.activeColor.withValues(alpha: 0.45);

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.borderColor, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.isDark ? 0.35 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push('/location/${root.id}'),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Expand/Collapse Toggle Button connected to tree connector
                      if (hasChildren)
                        CustomPaint(
                          painter: _TreeDropLinePainter(
                            isExpanded: isExpanded,
                            columnWidth: columnWidth,
                            lineColor: lineColor,
                            isRtl: theme.isRtl,
                            extendBottom: 0.0,
                          ),
                          child: SizedBox(
                            width: columnWidth,
                            child: Center(
                              child: IconButton(
                                icon: AnimatedRotation(
                                  turns: isExpanded ? 0.25 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    theme.isRtl
                                        ? Icons.chevron_left_rounded
                                        : Icons.chevron_right_rounded,
                                    size: 18,
                                    color: theme.activeColor,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: columnWidth,
                                  minHeight: columnWidth,
                                ),
                                tooltip: isExpanded
                                    ? theme.translate('collapse_all')
                                    : theme.translate('expand_all'),
                                onPressed: () => _toggleExpand(root.id),
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: columnWidth),
                      const SizedBox(width: 8),

                      // Mother branch icon
                      Center(
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: theme.activeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.home_work_outlined,
                            color: theme.activeColor,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name & Child/Stock Summary
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              root.name,
                              style: theme.textStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasChildren
                                  ? '${_formatPouchCount(children.length, theme)}${cumStats.totalUnits > 0 ? ' • ${theme.formatNumber(cumStats.totalUnits)} pcs' : ' • ${theme.translate('empty_location')}'}'
                                  : (cumStats.totalUnits > 0
                                      ? '${theme.formatNumber(cumStats.totalUnits)} pcs'
                                      : theme.translate('empty_location')),
                              style: theme.textStyle(
                                fontSize: 12,
                                color: theme.subTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Add Sub-location action
                      IconButton(
                        icon: Icon(
                          Icons.add_rounded,
                          size: 20,
                          color: theme.subTextColor,
                        ),
                        tooltip: theme.translate('add_sub_location'),
                        onPressed: () => _showAddLocationDialog(root.id),
                      ),

                      // Open details navigation chevron
                      IconButton(
                        icon: Icon(
                          theme.isRtl
                              ? Icons.chevron_left_rounded
                              : Icons.chevron_right_rounded,
                          size: 20,
                          color: theme.subTextColor,
                        ),
                        tooltip: theme.translate('open_location'),
                        onPressed: () => context.push('/location/${root.id}'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Collapsible Children Tree
          if (hasChildren && isExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Column(
                children: [
                  for (int i = 0; i < children.length; i++)
                    _buildTreeChildNode(
                      children[i],
                      childrenMap,
                      directStatsMap,
                      1,
                      const [],
                      i == children.length - 1,
                      theme,
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds an indented hierarchical tree node with directory tree connectors and independent collapse
  Widget _buildTreeChildNode(
    Location node,
    Map<String, List<Location>> childrenMap,
    Map<String, LocationStockStats> directStatsMap,
    int depth,
    List<bool> ancestorHasMore,
    bool isLastChild,
    ThemeProvider theme,
  ) {
    final subChildren = childrenMap[node.id] ?? [];
    final bool hasSubChildren = subChildren.isNotEmpty;
    final bool isSubExpanded = _expandedLocationIds.contains(node.id);
    final cumStats =
        _getCumulativeStats(node.id, directStatsMap, childrenMap);

    // Sort sub-children
    if (_sortBy == 'name_desc') {
      subChildren.sort((a, b) => b.name.compareTo(a.name));
    } else if (_sortBy == 'code_asc') {
      subChildren.sort((a, b) => (a.code ?? '').compareTo(b.code ?? ''));
    } else {
      subChildren.sort((a, b) => a.name.compareTo(b.name));
    }

    const double columnWidth = 22.0;
    final Color lineColor = theme.activeColor.withValues(alpha: 0.45);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Node Row with tree connectors
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Ancestor & self tree lines
              CustomPaint(
                painter: _TreeConnectorPainter(
                  depth: depth,
                  ancestorHasMore: ancestorHasMore,
                  isLastChild: isLastChild,
                  columnWidth: columnWidth,
                  lineColor: lineColor,
                  isRtl: theme.isRtl,
                ),
                size: Size(depth * columnWidth, double.infinity),
              ),

              // 2. Expand chevron slot (for folders) or horizontal branch extension (for leaves)
              if (hasSubChildren)
                CustomPaint(
                  painter: _TreeDropLinePainter(
                    isExpanded: isSubExpanded,
                    columnWidth: columnWidth,
                    lineColor: lineColor,
                    isRtl: theme.isRtl,
                  ),
                  child: SizedBox(
                    width: columnWidth,
                    child: Center(
                      child: IconButton(
                        icon: AnimatedRotation(
                          turns: isSubExpanded ? 0.25 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            theme.isRtl
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            size: 16,
                            color: theme.activeColor,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: columnWidth,
                          minHeight: columnWidth,
                        ),
                        tooltip: isSubExpanded
                            ? theme.translate('collapse_all')
                            : theme.translate('expand_all'),
                        onPressed: () => _toggleExpand(node.id),
                      ),
                    ),
                  ),
                )
              else
                CustomPaint(
                  painter: _TreeLeafBranchPainter(
                    columnWidth: columnWidth,
                    lineColor: lineColor,
                    isRtl: theme.isRtl,
                  ),
                  child: const SizedBox(
                    width: columnWidth,
                  ),
                ),

              // 3. Clickable node content
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => context.push('/location/${node.id}'),
                    borderRadius: BorderRadius.circular(10),
                    splashColor: theme.activeColor.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          // Level-aware Icon
                          Icon(
                            hasSubChildren
                                ? Icons.folder_outlined
                                : Icons.inventory_2_outlined,
                            size: 18,
                            color: theme.activeColor,
                          ),
                          const SizedBox(width: 8),

                          // Location Name & Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  node.name,
                                  style: theme.textStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (hasSubChildren) ...[
                                  const SizedBox(height: 1),
                                  Text(
                                    '${_formatPouchCount(subChildren.length, theme)}${cumStats.totalUnits > 0 ? ' • ${theme.formatNumber(cumStats.totalUnits)} pcs' : ' • ${theme.translate('empty_location')}'}',
                                    style: theme.textStyle(
                                      fontSize: 11,
                                      color: theme.subTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ] else ...[
                                  const SizedBox(height: 1),
                                  Text(
                                    cumStats.totalUnits > 0
                                        ? '${theme.formatNumber(cumStats.totalUnits)} pcs'
                                        : theme.translate('empty_location'),
                                    style: theme.textStyle(
                                      fontSize: 11,
                                      color: theme.subTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Quick Add Child action
                          IconButton(
                            icon: Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: theme.subTextColor,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 28,
                              minHeight: 28,
                            ),
                            tooltip: theme.translate('add_sub_location'),
                            onPressed: () => _showAddLocationDialog(node.id),
                          ),

                          // Open Chevron
                          Icon(
                            theme.isRtl
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            size: 16,
                            color: theme.subTextColor.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Recursive Child Nodes (when expanded)
        if (hasSubChildren && isSubExpanded)
          for (int j = 0; j < subChildren.length; j++)
            _buildTreeChildNode(
              subChildren[j],
              childrenMap,
              directStatsMap,
              depth + 1,
              [...ancestorHasMore, !isLastChild],
              j == subChildren.length - 1,
              theme,
            ),
      ],
    );
  }
}

/// Paints directory tree guidelines for ancestor columns and the node's own branch
class _TreeConnectorPainter extends CustomPainter {
  final int depth;
  final List<bool> ancestorHasMore;
  final bool isLastChild;
  final double columnWidth;
  final Color lineColor;
  final bool isRtl;

  const _TreeConnectorPainter({
    required this.depth,
    required this.ancestorHasMore,
    required this.isLastChild,
    required this.columnWidth,
    required this.lineColor,
    required this.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final double totalWidth = size.width;
    final double midY = size.height / 2;

    double getX(int col) {
      if (isRtl) {
        return totalWidth - (col + 0.5) * columnWidth;
      } else {
        return (col + 0.5) * columnWidth;
      }
    }

    // 1. Ancestor vertical lines
    for (int i = 0; i < depth - 1 && i < ancestorHasMore.length; i++) {
      if (ancestorHasMore[i]) {
        final x = getX(i);
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
    }

    // 2. Node's own connector at column (depth - 1)
    if (depth > 0) {
      final ownCol = depth - 1;
      final x = getX(ownCol);

      // Vertical line from top to midY
      canvas.drawLine(Offset(x, 0), Offset(x, midY), paint);

      // If not the last child, continue vertical line to bottom
      if (!isLastChild) {
        canvas.drawLine(Offset(x, midY), Offset(x, size.height), paint);
      }

      // Horizontal branch toward the node item
      final branchTargetX = isRtl ? 0.0 : totalWidth;
      canvas.drawLine(Offset(x, midY), Offset(branchTargetX, midY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TreeConnectorPainter oldDelegate) {
    return oldDelegate.depth != depth ||
        oldDelegate.isLastChild != isLastChild ||
        oldDelegate.columnWidth != columnWidth ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.isRtl != isRtl ||
        oldDelegate.ancestorHasMore != ancestorHasMore;
  }
}

/// Paints a vertical line dropping from an expanded folder's chevron down to the child level
class _TreeDropLinePainter extends CustomPainter {
  final bool isExpanded;
  final double columnWidth;
  final Color lineColor;
  final bool isRtl;
  final double extendBottom;

  const _TreeDropLinePainter({
    required this.isExpanded,
    required this.columnWidth,
    required this.lineColor,
    required this.isRtl,
    this.extendBottom = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isExpanded) return;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final double x = isRtl ? (size.width - columnWidth / 2) : (columnWidth / 2);
    final double midY = size.height / 2;
    canvas.drawLine(Offset(x, midY), Offset(x, size.height + extendBottom), paint);
  }

  @override
  bool shouldRepaint(covariant _TreeDropLinePainter oldDelegate) {
    return oldDelegate.isExpanded != isExpanded ||
        oldDelegate.columnWidth != columnWidth ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.isRtl != isRtl ||
        oldDelegate.extendBottom != extendBottom;
  }
}

/// Paints a horizontal branch line across the leaf icon slot directly into the leaf icon
class _TreeLeafBranchPainter extends CustomPainter {
  final double columnWidth;
  final Color lineColor;
  final bool isRtl;

  const _TreeLeafBranchPainter({
    required this.columnWidth,
    required this.lineColor,
    required this.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final double midY = size.height / 2;
    final double startX = isRtl ? size.width : 0.0;
    final double endX = isRtl ? 0.0 : size.width;
    canvas.drawLine(Offset(startX, midY), Offset(endX, midY), paint);
  }

  @override
  bool shouldRepaint(covariant _TreeLeafBranchPainter oldDelegate) {
    return oldDelegate.columnWidth != columnWidth ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.isRtl != isRtl;
  }
}

class _AddLocationDialog extends ConsumerStatefulWidget {
  final String? defaultParentId;

  const _AddLocationDialog({this.defaultParentId});

  @override
  ConsumerState<_AddLocationDialog> createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends ConsumerState<_AddLocationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedParentId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedParentId = widget.defaultParentId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final theme = ThemeProvider();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await ref.read(locationsRepositoryProvider).createLocation(
            name: _nameController.text.trim(),
            parentId: _selectedParentId,
            code: _codeController.text.trim().isEmpty
                ? null
                : _codeController.text.trim(),
            description: _descController.text.trim().isEmpty
                ? null
                : _descController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.translate('location_created_success'),
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
    final locationsAsync =
        ref.watch(locationsRepositoryProvider).watchAllLocations();

    return AlertDialog(
      backgroundColor: theme.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.borderColor),
      ),
      title: Text(
        theme.translate('new_storage_location'),
        style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PpTextField(
                controller: _nameController,
                label: '${theme.translate('location_name')} *',
                hint: 'e.g. Shelf A, Drawer 02, Bin 01',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return theme.translate('location_name_required');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              PpTextField(
                controller: _codeController,
                label: theme.translate('location_code'),
                hint: 'e.g. LOC-001-02, SH-A',
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<Location>>(
                stream: locationsAsync,
                builder: (context, snapshot) {
                  final locations = snapshot.data ?? [];
                  return DropdownButtonFormField<String?>(
                    initialValue: _selectedParentId,
                    dropdownColor: theme.secondaryColor,
                    style: theme.textStyle(color: theme.textColor),
                    decoration: InputDecoration(
                      labelText: theme.translate('parent_location'),
                      labelStyle: theme.textStyle(color: theme.subTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.borderColor),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(
                          theme.translate('none_root_level'),
                          style: theme.textStyle(color: theme.textColor),
                        ),
                      ),
                      ...locations.map(
                        (l) => DropdownMenuItem(
                          value: l.id,
                          child: Text(
                            l.name,
                            style: theme.textStyle(color: theme.textColor),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => _selectedParentId = val),
                  );
                },
              ),
              const SizedBox(height: 12),
              PpTextField(
                controller: _descController,
                label: theme.translate('description'),
                hint: 'Storage notes, shelf position, contents...',
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                theme.translate('cancel'),
                style: theme.textStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.subTextColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.activeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        theme.translate('add'),
                        style: theme.textStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
