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

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final locationsStream =
        ref.watch(locationsRepositoryProvider).watchAllLocations();

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
                    value: 'code_asc',
                    child: Text(
                      theme.currentLanguage == 'Persian' ? 'کد مکان' : 'Location Code',
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

              // Hierarchy Tree
              Expanded(
                child: StreamBuilder<List<Location>>(
                  stream: locationsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: theme.activeColor),
                      );
                    }

                    final allLocations = snapshot.data ?? [];

                    if (allLocations.isEmpty) {
                      return PpEmptyState(
                        icon: Icons.account_tree_outlined,
                        title: theme.translate('no_locations_configured'),
                        message: theme.translate('onboarding_desc_3'),
                      );
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
                        filtered.sort((a, b) => (a.code ?? '').compareTo(b.code ?? ''));
                      } else {
                        filtered.sort((a, b) => a.name.compareTo(b.name));
                      }

                      if (filtered.isEmpty) {
                        return PpEmptyState(
                          icon: Icons.search_off_rounded,
                          title: theme.translate('no_results_found'),
                          message: theme.translate('locations_search_hint'),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final loc = filtered[index];
                          return _LocationTreeTile(
                            location: loc,
                            depth: 0,
                            theme: theme,
                          );
                        },
                      );
                    }

                    // Build Hierarchical Tree
                    final rootLocations = allLocations
                        .where((l) => l.parentId == null)
                        .toList();

                    if (_sortBy == 'name_desc') {
                      rootLocations.sort((a, b) => b.name.compareTo(a.name));
                    } else if (_sortBy == 'code_asc') {
                      rootLocations.sort((a, b) => (a.code ?? '').compareTo(b.code ?? ''));
                    } else {
                      rootLocations.sort((a, b) => a.name.compareTo(b.name));
                    }

                    final Map<String, List<Location>> childrenMap = {};
                    for (final loc in allLocations) {
                      if (loc.parentId != null) {
                        childrenMap.putIfAbsent(loc.parentId!, () => []).add(loc);
                      }
                    }

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      children: rootLocations.map((root) {
                        return _buildLocationBranch(root, childrenMap, 0, theme);
                      }).toList(),
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

  Widget _buildLocationBranch(
    Location node,
    Map<String, List<Location>> childrenMap,
    int depth,
    ThemeProvider theme,
  ) {
    final children = childrenMap[node.id] ?? [];

    if (children.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _LocationTreeTile(
          location: node,
          depth: depth,
          theme: theme,
          onAddChild: () => _showAddLocationDialog(node.id),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            tilePadding: EdgeInsets.only(
              left: theme.isRtl ? 12 : 12.0 + (depth * 16),
              right: theme.isRtl ? 12.0 + (depth * 16) : 12,
            ),
            leading: Icon(
              depth == 0
                  ? Icons.home_work_outlined
                  : Icons.folder_outlined,
              color: theme.activeColor,
              size: 20,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    node.name,
                    style: theme.textStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor,
                    ),
                  ),
                ),
                if (node.code != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.isDark
                          ? const Color(0xFF0F1A24)
                          : const Color(0xFFEDF2F7),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: theme.borderColor),
                    ),
                    child: Text(
                      node.code!,
                      style: theme.textStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: theme.subTextColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: theme.subTextColor,
                  ),
                  tooltip: theme.translate('add_sub_location'),
                  onPressed: () => _showAddLocationDialog(node.id),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: theme.subTextColor,
                  ),
                  tooltip: theme.translate('open_location'),
                  onPressed: () => context.push('/location/${node.id}'),
                ),
              ],
            ),
            children: children.map((child) {
              return _buildLocationBranch(child, childrenMap, depth + 1, theme);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _LocationTreeTile extends ConsumerWidget {
  final Location location;
  final int depth;
  final ThemeProvider theme;
  final VoidCallback? onAddChild;

  const _LocationTreeTile({
    required this.location,
    required this.depth,
    required this.theme,
    this.onAddChild,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchLocationStockStats(location.id);

    return Padding(
      padding: EdgeInsets.only(
        left: theme.isRtl ? 0 : depth * 14.0,
        right: theme.isRtl ? depth * 14.0 : 0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.borderColor, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => context.push('/location/${location.id}'),
            borderRadius: BorderRadius.circular(16),
            splashColor: theme.activeColor.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    location.parentId == null
                        ? Icons.home_work_outlined
                        : Icons.inventory_2_outlined,
                    color: theme.activeColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              location.name,
                              style: theme.textStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.textColor,
                              ),
                            ),
                            if (location.code != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.isDark
                                      ? const Color(0xFF0F1A24)
                                      : const Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: theme.borderColor),
                                ),
                                child: Text(
                                  location.code!,
                                  style: theme.textStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: theme.subTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (location.description != null &&
                            location.description!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            location.description!,
                            style: theme.textStyle(
                              fontSize: 12,
                              color: theme.subTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  StreamBuilder<LocationStockStats>(
                    stream: statsAsync,
                    builder: (context, snapshot) {
                      final stats = snapshot.data;
                      if (stats == null || stats.totalUnits == 0) {
                        return Text(
                          theme.translate('empty_location'),
                          style: theme.textStyle(
                            fontSize: 12,
                            color: theme.subTextColor.withValues(alpha: 0.7),
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.activeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${theme.formatNumber(stats.totalUnits)} pcs',
                          style: theme.textStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.activeColor,
                          ),
                        ),
                      );
                    },
                  ),
                  if (onAddChild != null) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      icon: Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: theme.subTextColor,
                      ),
                      tooltip: theme.translate('add_sub_location'),
                      onPressed: onAddChild,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.activeColor,
                foregroundColor: Colors.white,
                elevation: 0,
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
          ],
        ),
      ],
    );
  }
}
