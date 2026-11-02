import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/formatting/date_formatter.dart';
import '../../../core/theme/category_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_corner_ribbon.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../../core/widgets/pp_icon_picker.dart';
import '../../../core/widgets/pp_text_field.dart';
import '../../inventory/data/inventory_repository.dart';
import '../data/projects_repository.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  void _showAddBomItemDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _AddBomItemDialog(projectId: projectId),
    );
  }

  void _showEditProjectDialog(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) {
    showDialog(
      context: context,
      builder: (context) => _EditProjectDialog(project: project),
    );
  }

  void _showIssueToProjectDialog(
    BuildContext context,
    WidgetRef ref,
    List<ProjectBomItemDetail> boms,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _IssueToProjectSheet(projectId: projectId, boms: boms),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeProvider();

    final projectAsync = ref
        .watch(projectsRepositoryProvider)
        .watchProjectById(projectId);
    final bomsAsync = ref
        .watch(projectsRepositoryProvider)
        .watchProjectBoms(projectId);

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        final bg = theme.primaryColor;
        final cardBg = theme.secondaryColor;
        final cardBorder = theme.borderColor;
        final textPri = theme.textColor;
        final textSec = theme.subTextColor;

        return StreamBuilder<Project?>(
      stream: projectAsync,
      builder: (context, projSnapshot) {
        final project = projSnapshot.data;

        if (projSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: bg,
            body: Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            ),
          );
        }

        if (project == null) {
          return Scaffold(
            backgroundColor: bg,
            appBar: AppBar(backgroundColor: bg, elevation: 0),
            body: PpEmptyState(
              icon: Icons.error_outline,
              title: theme.translate('no_projects_found'),
              message: theme.translate('no_results_found'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: theme.activeColor,
                ),
                tooltip: theme.translate('edit_project'),
                onPressed: () => _showEditProjectDialog(context, ref, project),
              ),
              IconButton(
                icon: Icon(
                  Icons.palette_outlined,
                  color: theme.activeColor,
                ),
                tooltip: theme.translate('change_icon'),
                onPressed: () async {
                  final curCodePoint = await ref
                      .read(projectsRepositoryProvider)
                      .getProjectIcon(project.id);
                  final currentIcon = curCodePoint != null
                      // ignore: non_const_argument_for_const_parameter
                      ? IconData(curCodePoint, fontFamily: 'MaterialIcons')
                      : Icons.build_outlined;
                  if (context.mounted) {
                    PpIconPicker.show(
                      context: context,
                      theme: theme,
                      selectedIcon: currentIcon,
                      onSelect: (newIcon) async {
                        await ref
                            .read(projectsRepositoryProvider)
                            .setProjectIcon(project.id, newIcon.codePoint);
                        if (context.mounted) {
                          AppSnackBar.show(
                            context,
                            message: theme.translate('icon_updated_success'),
                            type: SnackBarType.success,
                          );
                        }
                      },
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: theme.activeColor,
                ),
                tooltip: theme.translate('add_line_item'),
                onPressed: () => _showAddBomItemDialog(context, ref),
              ),
            ],
          ),
          body: StreamBuilder<List<ProjectBomItemDetail>>(
            stream: bomsAsync,
            builder: (context, bomSnapshot) {
              final boms = bomSnapshot.data ?? [];
              final totalCost = boms.fold<int>(
                0,
                (sum, b) => sum + b.estimatedCostCents,
              );
              final inStockCount = boms.where((b) => b.isSatisfied).length;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Section Header: Project Overview
                        Text(
                          theme.translate('project_overview'),
                          style: theme.textStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textPri,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Project Overview Card
                        PpCard(
                          padding: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          backgroundColor: cardBg,
                          borderColor: cardBorder,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        StreamBuilder<int?>(
                                          stream: ref
                                              .watch(projectsRepositoryProvider)
                                              .watchProjectIcon(project.id),
                                          builder: (context, iconSnap) {
                                            final iconCodePoint = iconSnap.data;
                                            final iconData = iconCodePoint != null
                                                // ignore: non_const_argument_for_const_parameter
                                                ? IconData(iconCodePoint,
                                                    fontFamily: 'MaterialIcons')
                                                : Icons.build_outlined;

                                            return Tooltip(
                                              message: theme.translate('change_icon'),
                                              child: InkWell(
                                                onTap: () {
                                                  PpIconPicker.show(
                                                    context: context,
                                                    theme: theme,
                                                    selectedIcon: iconData,
                                                    onSelect: (newIcon) async {
                                                      await ref
                                                          .read(projectsRepositoryProvider)
                                                          .setProjectIcon(project.id,
                                                              newIcon.codePoint);
                                                      if (context.mounted) {
                                                        AppSnackBar.show(
                                                          context,
                                                          message: theme.translate(
                                                              'icon_updated_success'),
                                                          type: SnackBarType.success,
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                child: Container(
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: theme.activeColor
                                                        .withValues(alpha: 0.15),
                                                    borderRadius:
                                                        BorderRadius.circular(14),
                                                    border: Border.all(
                                                      color: theme.activeColor
                                                          .withValues(alpha: 0.3),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Icon(
                                                        iconData,
                                                        color: theme.activeColor,
                                                        size: 24,
                                                      ),
                                                      Positioned(
                                                        right: -4,
                                                        bottom: -4,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                            color: theme.activeColor,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                            size: 8,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.only(
                                                end: 36),
                                            child: Text(
                                              project.name,
                                              style: theme.textStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: textPri,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              if (project.targetDate != null) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 13,
                                      color: project.targetDate!.isBefore(DateTime.now()) &&
                                              project.status != 'completed'
                                          ? AppColors.error
                                          : theme.activeColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        '${theme.currentLanguage == 'Persian' ? 'مهلت تحویل' : 'Deadline'}: ${DateFormatter.formatDate(project.targetDate!)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: project.targetDate!.isBefore(DateTime.now()) &&
                                                  project.status != 'completed'
                                              ? AppColors.error
                                              : textPri,
                                        ),
                                      ),
                                    ),
                                    if (project.targetDate!.isBefore(DateTime.now()) &&
                                        project.status != 'completed') ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        '(${theme.currentLanguage == 'Persian' ? 'گذشته' : 'Overdue'})',
                                        style: theme.textStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                              if (project.description != null &&
                                  project.description!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  project.description!,
                                  style: theme.textStyle(fontSize: 13, color: textPri),
                                ),
                              ],
                              Divider(height: 24, color: cardBorder),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        theme.translate('bom_readiness'),
                                        style: theme.textStyle(fontSize: 11, color: textSec),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${theme.formatNumber(inStockCount)} / ${theme.formatNumber(boms.length)} ${theme.translate('in_stock')}',
                                        style: theme.textStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: inStockCount == boms.length &&
                                                  boms.isNotEmpty
                                              ? AppColors.success
                                              : textPri,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        theme.translate('total_cost'),
                                        style: theme.textStyle(fontSize: 11, color: textSec),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        CurrencyFormatter.formatCents(
                                          totalCost,
                                        ),
                                        style: theme.textStyle(
                                          fontSize: 15,
                                          color: theme.activeColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          top: 0,
                          end: 0,
                          child: PpCornerRibbon.fromProjectStatus(
                            project.status,
                            theme,
                          ),
                        ),
                      ],
                    ),
                  ),
                        const SizedBox(height: AppSpacing.lg),

                        // BOM Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              theme.translate('bill_of_materials_bom'),
                              style: theme.textStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPri),
                            ),
                            TextButton.icon(
                              icon: Icon(Icons.add, size: 16, color: theme.activeColor),
                              label: Text(
                                theme.translate('add_line_item'),
                                style: theme.textStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: theme.activeColor,
                                ),
                              ),
                              onPressed: () =>
                                  _showAddBomItemDialog(context, ref),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // BOM Items List
                        if (boms.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: PpEmptyState(
                              icon: Icons.list_alt,
                              title: theme.currentLanguage == 'Persian'
                                  ? 'لیست قطعات خالی است'
                                  : 'No BOM Components',
                              message: theme.currentLanguage == 'Persian'
                                  ? 'قطعات الکترونیکی مورد نیاز برای ساخت این پروژه را اضافه کنید.'
                                  : 'Add electronic components required for this project build.',
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: boms.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = boms[index];
                              final comp = item.component;

                              return PpCard(
                                padding: const EdgeInsets.all(12),
                                backgroundColor: cardBg,
                                borderColor: cardBorder,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: CategoryColors.getContainerColor(
                                          comp.category,
                                          isDark: theme.isDark,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: CategoryColors.getColor(
                                            comp.category,
                                          ).withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(comp.category),
                                        color: CategoryColors.getForegroundColor(
                                          comp.category,
                                          isDark: theme.isDark,
                                        ),
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Line 1: Category Name in its color & Readiness Badge & Delete button
                                          Row(
                                            children: [
                                              Text(
                                                comp.category,
                                                style: theme.textStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: CategoryColors.getColor(comp.category),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: item.isSatisfied
                                                      ? AppColors.successContainer
                                                      : AppColors.errorContainer,
                                                  borderRadius: AppSpacing.roundedSm,
                                                  border: Border.all(
                                                    color: item.isSatisfied
                                                        ? AppColors.success
                                                        : AppColors.error,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  '${theme.formatNumber(item.availableStock)} / ${theme.formatNumber(item.bom.quantityRequired)}',
                                                  style: theme.textStyle(
                                                    fontSize: 11,
                                                    color: item.isSatisfied
                                                        ? AppColors.success
                                                        : AppColors.error,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  size: 18,
                                                  color: textSec,
                                                ),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(
                                                  minWidth: 28,
                                                  minHeight: 28,
                                                ),
                                                tooltip: theme.translate('delete'),
                                                onPressed: () async {
                                                  await ref
                                                      .read(projectsRepositoryProvider)
                                                      .removeBomItem(item.bom.id);
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          // Line 2: Component Name
                                          Text(
                                            comp.name,
                                            style: theme.textStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: textPri,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // Line 3: Description (if present)
                                          if (comp.description != null &&
                                              comp.description!.trim().isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              comp.description!,
                                              style: theme.textStyle(
                                                fontSize: 12,
                                                color: textSec,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                          // Line 4: Package Footprint (if present)
                                          if (comp.packageFootprint != null &&
                                              comp.packageFootprint!.trim().isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              comp.packageFootprint!,
                                              style: theme.textStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w500,
                                                color: textSec,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                          const SizedBox(height: 4),
                                          // Line 5: Shortage / Required on left, Cost on right
                                          Row(
                                            children: [
                                              if (item.shortage > 0)
                                                Text(
                                                  '${theme.currentLanguage == 'Persian' ? 'کسری موجودی' : 'Shortage'}: ${theme.formatNumber(item.shortage)} ${comp.unitOfMeasure}',
                                                  style: theme.textStyle(
                                                    fontSize: 11.5,
                                                    color: AppColors.error,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              else
                                                Text(
                                                  '${theme.translate('required_parts')}: ${theme.formatNumber(item.bom.quantityRequired)} ${comp.unitOfMeasure}',
                                                  style: theme.textStyle(
                                                    fontSize: 11.5,
                                                    color: textSec,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              const Spacer(),
                                              if (item.estimatedCostCents > 0)
                                                Text(
                                                  CurrencyFormatter.formatCents(
                                                    item.estimatedCostCents,
                                                    compact: true,
                                                  ),
                                                  style: theme.textStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
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
                            },
                          ),
                      ],
                    ),
                  ),

                  // Bottom Button: Issue to Project
                  if (boms.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        border: Border(
                          top: BorderSide(color: cardBorder, width: 1),
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: PpButton(
                          label: theme.translate('build_project'),
                          icon: Icons.upload,
                          onPressed: () =>
                              _showIssueToProjectDialog(context, ref, boms),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  },
);
  }
}

class _AddBomItemDialog extends ConsumerStatefulWidget {
  final String projectId;

  const _AddBomItemDialog({required this.projectId});

  @override
  ConsumerState<_AddBomItemDialog> createState() => _AddBomItemDialogState();
}

class _AddBomItemDialogState extends ConsumerState<_AddBomItemDialog> {
  final _formKey = GlobalKey<FormState>();
  Component? _selectedComponent;
  final _qtyController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final theme = ThemeProvider();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedComponent == null) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'لطفاً قطعه را انتخاب کنید.'
            : 'Please select a component.',
        type: SnackBarType.info,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final qty = int.parse(_qtyController.text);
      await ref
          .read(projectsRepositoryProvider)
          .addBomItem(
            projectId: widget.projectId,
            componentId: _selectedComponent!.id,
            quantityRequired: qty,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? 'قطعه به لیست BOM اضافه شد.'
              : 'BOM item added.',
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

    final componentsAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentsWithStock();

    return AlertDialog(
      backgroundColor: theme.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.borderColor),
      ),
      title: Text(
        theme.translate('add_line_item'),
        style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textColor),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<List<ComponentWithStock>>(
                stream: componentsAsync,
                builder: (context, snapshot) {
                  final components = snapshot.data ?? [];
                  return DropdownButtonFormField<Component>(
                    initialValue: _selectedComponent,
                    dropdownColor: theme.secondaryColor,
                    style: theme.textStyle(fontSize: 14, color: theme.textColor),
                    decoration: InputDecoration(
                      labelText: '${theme.translate('components')} *',
                      labelStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                    ),
                    items: components.map((c) {
                      return DropdownMenuItem(
                        value: c.component,
                        child: Text(
                          '${c.component.name} (${theme.formatNumber(c.totalStock)} ${theme.translate('in_stock')})',
                          style: theme.textStyle(fontSize: 14, color: theme.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedComponent = val),
                    validator: (val) => val == null ? theme.translate('required_field') : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              PpTextField(
                controller: _qtyController,
                label: '${theme.translate('quantity')} *',
                hint: '1',
                keyboardType: TextInputType.number,
                validator: (val) {
                  final parsed = int.tryParse(val ?? '');
                  if (parsed == null || parsed <= 0) return '> 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              PpTextField(
                controller: _notesController,
                label: theme.currentLanguage == 'Persian' ? 'نام مرجع فنی / شماره قطعه' : 'Reference / Designator',
                hint: 'e.g. R1, C2, U3, main controller',
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

class _IssueToProjectSheet extends ConsumerStatefulWidget {
  final String projectId;
  final List<ProjectBomItemDetail> boms;

  const _IssueToProjectSheet({required this.projectId, required this.boms});

  @override
  ConsumerState<_IssueToProjectSheet> createState() =>
      _IssueToProjectSheetState();
}

class _IssueToProjectSheetState extends ConsumerState<_IssueToProjectSheet> {
  ProjectBomItemDetail? _selectedBom;
  String? _selectedLocationId;
  int _quantity = 1;
  final _qtyController = TextEditingController(text: '1');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.boms.isNotEmpty) {
      _selectedBom = widget.boms.first;
      _quantity = _selectedBom!.bom.quantityRequired;
      _qtyController.text = _quantity.toString();
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _submit(int maxAvailable) async {
    final theme = ThemeProvider();
    if (_selectedBom == null || _selectedLocationId == null) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'قطعه و مکان را انتخاب کنید.'
            : 'Select part and location.',
        type: SnackBarType.info,
      );
      return;
    }
    if (_quantity > maxAvailable) {
      AppSnackBar.show(
        context,
        message: theme.currentLanguage == 'Persian'
            ? 'موجودی ناکافی: تنها ${theme.formatNumber(maxAvailable)} عدد موجود است.'
            : 'Insufficient stock: only $maxAvailable available.',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(projectsRepositoryProvider)
          .issueBomItemStock(
            projectId: widget.projectId,
            componentId: _selectedBom!.component.id,
            sourceLocationId: _selectedLocationId!,
            quantity: _quantity,
          );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? '${theme.formatNumber(_quantity)} عدد از ${_selectedBom!.component.name} به پروژه اختصاص یافت.'
              : 'Issued $_quantity of ${_selectedBom!.component.name} to project.',
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

    if (_selectedBom == null) return const SizedBox.shrink();

    final balancesAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchBalancesForComponent(_selectedBom!.component.id);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    theme.translate('build_project'),
                    style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: theme.subTextColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // BOM Component Selector
              DropdownButtonFormField<ProjectBomItemDetail>(
                initialValue: _selectedBom,
                dropdownColor: theme.secondaryColor,
                style: theme.textStyle(fontSize: 14, color: theme.textColor),
                decoration: InputDecoration(
                  labelText: '${theme.translate('components')} *',
                  labelStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                ),
                items: widget.boms.map((b) {
                  return DropdownMenuItem(
                    value: b,
                    child: Text(
                      '${b.component.name} (${theme.currentLanguage == 'Persian' ? 'نیاز' : 'Req'}: ${theme.formatNumber(b.bom.quantityRequired)})',
                      style: theme.textStyle(fontSize: 14, color: theme.textColor),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedBom = val;
                    _selectedLocationId = null;
                    if (val != null) {
                      _quantity = val.bom.quantityRequired;
                      _qtyController.text = _quantity.toString();
                    }
                  });
                },
              ),
              const SizedBox(height: 12),

              // Location with stock
              StreamBuilder<List<LocationBalanceItem>>(
                stream: balancesAsync,
                builder: (context, snapshot) {
                  final balances = snapshot.data ?? [];
                  if (_selectedLocationId == null && balances.isNotEmpty) {
                    _selectedLocationId = balances.first.location.id;
                  }

                  final curBal = balances
                      .where((b) => b.location.id == _selectedLocationId)
                      .firstOrNull;
                  final maxAvailable = curBal?.quantity ?? 0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _selectedLocationId,
                        dropdownColor: theme.secondaryColor,
                        style: theme.textStyle(fontSize: 14, color: theme.textColor),
                        decoration: InputDecoration(
                          labelText: '${theme.translate('source_location')} *',
                          labelStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                        ),
                        items: balances.map((b) {
                          return DropdownMenuItem(
                            value: b.location.id,
                            child: Text(
                              '${b.location.name} (${theme.formatNumber(b.quantity)} ${theme.translate('in_stock')})',
                              style: theme.textStyle(fontSize: 14, color: theme.textColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => _selectedLocationId = val),
                      ),
                      const SizedBox(height: 12),
                      PpTextField(
                        controller: _qtyController,
                        label: '${theme.translate('quantity')} * (${theme.translate('expected')}: ${theme.formatNumber(maxAvailable)})',
                        hint: '1',
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null && parsed > 0) _quantity = parsed;
                        },
                      ),
                      const SizedBox(height: 20),
                      PpButton(
                        label: theme.translate('confirm'),
                        isLoading: _isLoading,
                        onPressed: () => _submit(maxAvailable),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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

class _EditProjectDialog extends ConsumerStatefulWidget {
  final Project project;

  const _EditProjectDialog({required this.project});

  @override
  ConsumerState<_EditProjectDialog> createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends ConsumerState<_EditProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late String _status;
  late DateTime? _targetDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _descController =
        TextEditingController(text: widget.project.description ?? '');
    _status = widget.project.status;
    _targetDate = widget.project.targetDate;
  }

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
      await ref.read(projectsRepositoryProvider).updateProject(
            id: widget.project.id,
            name: _nameController.text.trim(),
            description: _descController.text.trim().isEmpty
                ? null
                : _descController.text.trim(),
            status: _status,
            targetDate: _targetDate,
          );

      if (mounted) {
        Navigator.of(context).pop();
        AppSnackBar.show(
          context,
          message: theme.translate('edit_project_success'),
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
        theme.translate('edit_project'),
        style: theme.textStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: theme.textColor,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PpTextField(
                controller: _nameController,
                label:
                    '${theme.currentLanguage == 'Persian' ? 'نام پروژه' : 'Project Name'} *',
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
                  labelStyle:
                      theme.textStyle(fontSize: 13, color: theme.subTextColor),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'inProgress',
                    child: Text(theme.translate('in_progress'),
                        style: theme.textStyle(
                            fontSize: 14, color: theme.textColor)),
                  ),
                  DropdownMenuItem(
                    value: 'planning',
                    child: Text(theme.translate('planning'),
                        style: theme.textStyle(
                            fontSize: 14, color: theme.textColor)),
                  ),
                  DropdownMenuItem(
                    value: 'onHold',
                    child: Text(theme.translate('on_hold'),
                        style: theme.textStyle(
                            fontSize: 14, color: theme.textColor)),
                  ),
                  DropdownMenuItem(
                    value: 'completed',
                    child: Text(theme.translate('completed'),
                        style: theme.textStyle(
                            fontSize: 14, color: theme.textColor)),
                  ),
                  DropdownMenuItem(
                    value: 'cancelled',
                    child: Text(theme.translate('cancelled'),
                        style: theme.textStyle(
                            fontSize: 14, color: theme.textColor)),
                  ),
                ],
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _targetDate ??
                        DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    builder: (context, child) =>
                        _buildDatePickerTheme(context, child!, theme),
                  );
                  if (picked != null) {
                    setState(() => _targetDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.elevatedColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _targetDate != null
                          ? theme.activeColor.withValues(alpha: 0.5)
                          : theme.borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: _targetDate != null
                            ? theme.activeColor
                            : theme.subTextColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _targetDate != null
                              ? '${theme.translate('target_date')}: ${DateFormatter.formatDate(_targetDate!)}'
                              : '${theme.translate('target_date')} (${theme.currentLanguage == 'Persian' ? 'اختیاری' : 'Optional'})',
                          style: theme.textStyle(
                            fontSize: 13,
                            color: _targetDate != null
                                ? theme.textColor
                                : theme.subTextColor,
                          ),
                        ),
                      ),
                      if (_targetDate != null)
                        GestureDetector(
                          onTap: () => setState(() => _targetDate = null),
                          child: Icon(Icons.close_rounded,
                              size: 18, color: theme.subTextColor),
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
                maxLines: 3,
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
                        theme.translate('save'),
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

  Widget _buildDatePickerTheme(
    BuildContext context,
    Widget child,
    ThemeProvider theme,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: theme.isDark
            ? ColorScheme.dark(
                primary: theme.activeColor,
                onPrimary: Colors.white,
                surface: theme.secondaryColor,
                onSurface: theme.textColor,
                surfaceContainerHighest: theme.elevatedColor,
              )
            : ColorScheme.light(
                primary: theme.activeColor,
                onPrimary: Colors.white,
                surface: theme.secondaryColor,
                onSurface: theme.textColor,
                surfaceContainerHighest: theme.elevatedColor,
              ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: theme.secondaryColor,
          headerBackgroundColor: theme.secondaryColor,
          headerForegroundColor: theme.textColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: theme.borderColor),
          ),
          dayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            if (states.contains(WidgetState.disabled)) {
              return theme.subTextColor.withValues(alpha: 0.4);
            }
            return theme.textColor;
          }),
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return theme.activeColor;
            return null;
          }),
          todayForegroundColor: WidgetStateProperty.all(theme.activeColor),
          todayBorder: BorderSide(color: theme.activeColor, width: 1.5),
          cancelButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(theme.subTextColor),
          ),
          confirmButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(theme.activeColor),
          ),
        ),
      ),
      child: child,
    );
  }
}
