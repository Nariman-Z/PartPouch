import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/formatting/date_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_corner_ribbon.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../../core/widgets/pp_icon_picker.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../data/projects_repository.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  String _selectedStatusFilter = 'All'; // All, inProgress, planning, completed
  String _sortBy = 'updated_desc';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddProjectDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    final projectsStream = ref
        .watch(projectsRepositoryProvider)
        .watchAllProjects(
          statusFilter: _selectedStatusFilter == 'All'
              ? null
              : _selectedStatusFilter,
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
              theme.translate('projects_and_bom'),
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
                    value: 'updated_desc',
                    child: Text(
                      theme.currentLanguage == 'Persian' ? 'آخرین تغییرات' : 'Recently Updated',
                      style: theme.textStyle(fontSize: 13, color: theme.textColor),
                    ),
                  ),
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
                    value: 'target_asc',
                    child: Text(
                      theme.currentLanguage == 'Persian' ? 'مهلت تحویل' : 'Due Date',
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
                    style:
                        theme.textStyle(fontSize: 14, color: theme.textColor),
                    decoration: InputDecoration(
                      hintText: theme.translate('projects_search_hint'),
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

              // Filter Tabs
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    _buildFilterChip('All', theme.translate('filter_all'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip('inProgress', theme.translate('in_progress'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip('planning', theme.translate('planning'), theme),
                    const SizedBox(width: 8),
                    _buildFilterChip('completed', theme.translate('completed'), theme),
                  ],
                ),
              ),

              // Projects List
              Expanded(
                child: StreamBuilder<List<ProjectWithBomSummary>>(
                  stream: projectsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: theme.activeColor),
                      );
                    }

                    final allProjects = snapshot.data ?? [];
                    final query = _searchQuery.trim().toLowerCase();

                    final projects = query.isEmpty
                        ? List<ProjectWithBomSummary>.from(allProjects)
                        : allProjects.where((item) {
                            final name = item.project.name.toLowerCase();
                            final desc = item.project.description?.toLowerCase() ?? '';
                            return name.contains(query) || desc.contains(query);
                          }).toList();

                    if (_sortBy == 'name_asc') {
                      projects.sort((a, b) => a.project.name.compareTo(b.project.name));
                    } else if (_sortBy == 'name_desc') {
                      projects.sort((a, b) => b.project.name.compareTo(a.project.name));
                    } else if (_sortBy == 'target_asc') {
                      projects.sort((a, b) => (a.project.targetDate ?? DateTime(2099)).compareTo(b.project.targetDate ?? DateTime(2099)));
                    }

                    if (allProjects.isEmpty) {
                      return PpEmptyState(
                        icon: Icons.assignment_outlined,
                        title: theme.translate('no_projects_found'),
                        message: theme.currentLanguage == 'Persian'
                            ? 'پروژه‌ای برای مدیریت لیست قطعات (BOM) تعریف کنید.'
                            : 'Create a build project to organize Bills of Materials (BOM) and track component availability.',
                      );
                    }

                    if (projects.isEmpty) {
                      return PpEmptyState(
                        icon: Icons.search_off_rounded,
                        title: theme.translate('no_results_found'),
                        message: theme.translate('no_projects_matched'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      itemCount: projects.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = projects[index];
                        return _ProjectCard(item: item, theme: theme);
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
              heroTag: 'projects_fab',
              backgroundColor: theme.activeColor,
              foregroundColor: Colors.white,
              elevation: 4,
              highlightElevation: 6,
              tooltip: theme.translate('create_project'),
              onPressed: _showAddProjectDialog,
              child: const Icon(Icons.add_rounded),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String status, String label, ThemeProvider theme) {
    final isSelected = _selectedStatusFilter == status;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedStatusFilter = status),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.activeColor.withValues(alpha: 0.15)
                : theme.secondaryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? theme.activeColor : theme.borderColor,
              width: 1.2,
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

class _ProjectCard extends StatelessWidget {
  final ProjectWithBomSummary item;
  final ThemeProvider theme;

  const _ProjectCard({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    final p = item.project;

    final progress = item.totalBomItems > 0
        ? (item.completedBomItems / item.totalBomItems)
        : 0.0;

    return PpCard(
      onTap: () => context.push('/project/${p.id}'),
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      backgroundColor: theme.secondaryColor,
      borderColor: theme.borderColor,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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
                        item.iconData,
                        color: theme.activeColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: theme.textStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: theme.textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (p.targetDate != null) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 11,
                                    color: p.targetDate!.isBefore(DateTime.now()) &&
                                            p.status != 'completed'
                                        ? AppColors.error
                                        : theme.activeColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${theme.currentLanguage == 'Persian' ? 'مهلت تحویل' : 'Due'}: ${DateFormatter.formatDate(p.targetDate!)}',
                                    style: theme.textStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: p.targetDate!.isBefore(DateTime.now()) &&
                                              p.status != 'completed'
                                          ? AppColors.error
                                          : theme.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (p.description != null && p.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    p.description!,
                    style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),

                // BOM Progress Bar & Total Cost
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: AppSpacing.roundedFull,
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: theme.isDark
                              ? const Color(0xFF262A30)
                              : const Color(0xFFEAEFF5),
                          color: item.isFullyStocked
                              ? AppColors.success
                              : theme.activeColor,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${theme.formatNumber(item.completedBomItems)}/${theme.formatNumber(item.totalBomItems)} ${theme.translate('in_stock')}',
                      style: theme.textStyle(
                        fontSize: 11,
                        color: item.isFullyStocked
                            ? AppColors.success
                            : theme.subTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.totalEstimatedCostCents > 0) ...[
                      Text(
                        ' • ',
                        style: theme.textStyle(fontSize: 11, color: theme.subTextColor),
                      ),
                      Text(
                        CurrencyFormatter.formatCents(item.totalEstimatedCostCents),
                        style: theme.textStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.activeColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 0,
            end: 0,
            child: PpCornerRibbon.fromProjectStatus(p.status, theme),
          ),
        ],
      ),
    );
  }
}

class _AddProjectDialog extends ConsumerStatefulWidget {
  const _AddProjectDialog();

  @override
  ConsumerState<_AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends ConsumerState<_AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _status = 'inProgress';
  IconData _selectedIcon = Icons.build_rounded;
  DateTime? _targetDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final theme = ThemeProvider();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final id = await ref
          .read(projectsRepositoryProvider)
          .createProject(
            name: _nameController.text.trim(),
            description: _descController.text.trim().isEmpty
                ? null
                : _descController.text.trim(),
            status: _status,
            targetDate: _targetDate,
            iconCodePoint: _selectedIcon.codePoint,
          );

      if (mounted) {
        Navigator.of(context).pop();
        context.push('/project/$id');
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? 'پروژه جدید با موفقیت ایجاد شد.'
              : 'Project created successfully.',
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

    return AlertDialog(
      backgroundColor: theme.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.borderColor),
      ),
      title: Text(
        theme.translate('create_project'),
        style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.w700, color: theme.textColor),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PpProjectIconSelector(
                selectedIcon: _selectedIcon,
                onChanged: (newIcon) => setState(() => _selectedIcon = newIcon),
                theme: theme,
              ),
              const SizedBox(height: 14),
              PpTextField(
                controller: _nameController,
                label: '${theme.currentLanguage == 'Persian' ? 'نام پروژه' : 'Project Name'} *',
                hint: 'e.g. Smart Sensor Node, USB Charger',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return theme.translate('required_field');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _status,
                dropdownColor: theme.secondaryColor,
                style: theme.textStyle(fontSize: 14, color: theme.textColor),
                decoration: InputDecoration(
                  labelText: theme.translate('status'),
                  labelStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'inProgress',
                    child: Text(theme.translate('in_progress'), style: theme.textStyle(fontSize: 14, color: theme.textColor)),
                  ),
                  DropdownMenuItem(
                    value: 'planning',
                    child: Text(theme.translate('planning'), style: theme.textStyle(fontSize: 14, color: theme.textColor)),
                  ),
                  DropdownMenuItem(
                    value: 'onHold',
                    child: Text(theme.translate('on_hold'), style: theme.textStyle(fontSize: 14, color: theme.textColor)),
                  ),
                  DropdownMenuItem(
                    value: 'completed',
                    child: Text(theme.translate('completed'), style: theme.textStyle(fontSize: 14, color: theme.textColor)),
                  ),
                ],
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _targetDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: _targetDate != null ? theme.activeColor : theme.subTextColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _targetDate != null
                              ? '${theme.translate('target_date')}: ${DateFormatter.formatDate(_targetDate!)}'
                              : '${theme.translate('target_date')} (${theme.currentLanguage == 'Persian' ? 'اختیاری' : 'Optional'})',
                          style: theme.textStyle(
                            fontSize: 13,
                            color: _targetDate != null ? theme.textColor : theme.subTextColor,
                          ),
                        ),
                      ),
                      if (_targetDate != null)
                        GestureDetector(
                          onTap: () => setState(() => _targetDate = null),
                          child: Icon(Icons.close_rounded, size: 18, color: theme.subTextColor),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PpTextField(
                controller: _descController,
                label: theme.translate('notes'),
                hint: theme.currentLanguage == 'Persian'
                    ? 'شرح اهداف پروژه، مشخصات، لینک شماتیک...'
                    : 'Brief goals, schematic link, requirements...',
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
