import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/formatting/date_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_badge.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_empty_state.dart';
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
            title: Text(
              project.name,
              style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            backgroundColor: bg,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: theme.primaryColor,
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
                        // Project Overview Card
                        PpCard(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: cardBg,
                          borderColor: cardBorder,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      project.name,
                                      style: theme.textStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textPri,
                                      ),
                                    ),
                                  ),
                                  PpBadge(
                                    label: _getLocalizedStatus(project.status, theme),
                                    variant: project.status == 'completed'
                                        ? BadgeVariant.success
                                        : (project.status == 'inProgress'
                                              ? BadgeVariant.primary
                                              : BadgeVariant.info),
                                  ),
                                ],
                              ),
                              if (project.targetDate != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${theme.currentLanguage == 'Persian' ? 'مهلت تحویل' : 'Target'}: ${DateFormatter.formatDate(project.targetDate!)}',
                                  style: theme.textStyle(fontSize: 12, color: textSec),
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
                                          fontSize: 14,
                                          color: theme.primaryColor,
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
                        const SizedBox(height: AppSpacing.lg),

                        // BOM Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              theme.translate('projects_and_bom'),
                              style: theme.textStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPri),
                            ),
                            TextButton.icon(
                              icon: Icon(Icons.add, size: 16, color: theme.primaryColor),
                              label: Text(
                                theme.translate('add_line_item'),
                                style: theme.textStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: theme.primaryColor,
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
                                        color: theme.primaryColor.withValues(alpha: 0.15),
                                        borderRadius: AppSpacing.roundedSm,
                                      ),
                                      child: Icon(
                                        Icons.memory,
                                        color: theme.primaryColor,
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
                                            comp.name,
                                            style: theme.textStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: textPri,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${comp.category}${comp.packageFootprint != null ? ' • ${comp.packageFootprint}' : ''}',
                                            style: theme.textStyle(fontSize: 12, color: textSec),
                                          ),
                                          if (item.shortage > 0) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              '${theme.currentLanguage == 'Persian' ? 'کسری موجودی' : 'Shortage'}: ${theme.formatNumber(item.shortage)} ${comp.unitOfMeasure}',
                                              style: theme.textStyle(
                                                fontSize: 11,
                                                color: AppColors.error,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    // Required vs Available Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
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
                                      tooltip: theme.translate('delete'),
                                      onPressed: () async {
                                        await ref
                                            .read(projectsRepositoryProvider)
                                            .removeBomItem(item.bom.id);
                                      },
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

  String _getLocalizedStatus(String status, ThemeProvider theme) {
    switch (status) {
      case 'completed':
        return theme.translate('completed');
      case 'inProgress':
        return theme.translate('in_progress');
      case 'planning':
        return theme.translate('planning');
      case 'onHold':
        return theme.translate('on_hold');
      case 'cancelled':
        return theme.translate('cancelled');
      default:
        return status;
    }
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
