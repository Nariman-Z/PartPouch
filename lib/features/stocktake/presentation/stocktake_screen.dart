import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../locations/data/locations_repository.dart';
import '../data/stocktake_repository.dart';

class StocktakeScreen extends ConsumerStatefulWidget {
  const StocktakeScreen({super.key});

  @override
  ConsumerState<StocktakeScreen> createState() => _StocktakeScreenState();
}

class _StocktakeScreenState extends ConsumerState<StocktakeScreen> {
  String? _selectedLocationId;
  String? _activeSessionId;
  bool _isStarting = false;
  bool _isReconciling = false;

  Future<void> _startCounting() async {
    setState(() => _isStarting = true);
    try {
      final sessionId = await ref
          .read(stocktakeRepositoryProvider)
          .startSession(
            locationId: _selectedLocationId,
            notes: 'Physical audit count',
          );
      setState(() => _activeSessionId = sessionId);
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: e.toString(),
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isStarting = false);
    }
  }

  Future<void> _reconcile() async {
    if (_activeSessionId == null) return;
    final theme = ThemeProvider();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: theme.borderColor),
        ),
        title: Text(
          theme.translate('reconcile'),
          style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textColor),
        ),
        content: Text(
          theme.currentLanguage == 'Persian'
              ? 'موجودی‌های فعلی بر اساس این شمارش فیزیکی به‌روزرسانی می‌شوند و مغایرت‌ها در دفتر کل ثبت خواهند شد.'
              : 'This will update current inventory quantities to match your physical count. Discrepancies will be logged in the stock movement ledger.',
          style: theme.textStyle(fontSize: 14, color: theme.subTextColor),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
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
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  theme.translate('confirm'),
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
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isReconciling = true);

    try {
      await ref
          .read(stocktakeRepositoryProvider)
          .reconcileSession(_activeSessionId!);
      if (mounted) {
        AppSnackBar.show(
          context,
          message: theme.currentLanguage == 'Persian'
              ? 'موجودی با موفقیت اصلاح و ثبت شد.'
              : 'Stocktake reconciled. Inventory balances updated.',
          type: SnackBarType.success,
        );
        setState(() => _activeSessionId = null);
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
      if (mounted) setState(() => _isReconciling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    final locationsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchAllLocations();

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        if (_activeSessionId != null) {
          final sessionAsync = ref
              .watch(stocktakeRepositoryProvider)
              .watchSessionById(_activeSessionId!);
          final entriesAsync = ref
              .watch(stocktakeRepositoryProvider)
              .watchSessionEntries(_activeSessionId!);

          return Scaffold(
            backgroundColor: theme.primaryColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                theme.translate('active_sessions'),
                style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textColor),
              ),
              leading: IconButton(
                icon: Icon(Icons.close_rounded, color: theme.textColor),
                onPressed: () => setState(() => _activeSessionId = null),
              ),
            ),
            body: StreamBuilder<StocktakeSessionWithDetails?>(
              stream: sessionAsync,
              builder: (context, sessionSnapshot) {
                final sessionDetail = sessionSnapshot.data;

                return StreamBuilder<List<StocktakeEntryDetail>>(
                  stream: entriesAsync,
                  builder: (context, entriesSnapshot) {
                    final entries = entriesSnapshot.data ?? [];
                    final discrepancyCount = entries
                        .where((e) => e.hasDiscrepancy)
                        .length;

                    return Column(
                      children: [
                        // Summary Banner
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: _StocktakeMetricBox(
                                  label: theme.translate('total_items'),
                                  value: theme.formatNumber(entries.length),
                                  color: theme.textColor,
                                  theme: theme,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _StocktakeMetricBox(
                                  label: theme.translate('discrepancy'),
                                  value: theme.formatNumber(discrepancyCount),
                                  color: discrepancyCount > 0
                                      ? AppColors.warning
                                      : AppColors.success,
                                  theme: theme,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _StocktakeMetricBox(
                                  label: theme.translate('location'),
                                  value: sessionDetail?.location?.name ??
                                      (theme.currentLanguage == 'Persian'
                                          ? 'کل کارگاه'
                                          : 'All Workshop'),
                                  color: AppColors.accentBlue,
                                  theme: theme,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Entries List
                        Expanded(
                          child: entries.isEmpty
                              ? PpEmptyState(
                                  icon: Icons.inventory_2_outlined,
                                  title: theme.translate('no_components_found'),
                                  message: theme.translate('no_categories_stock'),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  itemCount: entries.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final entry = entries[index];
                                    final comp = entry.component;

                                    return PpCard(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      backgroundColor: theme.secondaryColor,
                                      borderColor: theme.borderColor,
                                      child: Row(
                                        children: [
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
                                                    color: theme.textColor,
                                                  ),
                                                ),
                                                Text(
                                                  '${theme.translate('expected')}: ${theme.formatNumber(entry.entry.expectedQuantity)} ${comp.unitOfMeasure}',
                                                  style: theme.textStyle(
                                                    fontSize: 12,
                                                    color: theme.subTextColor,
                                                  ),
                                                ),
                                                if (entry.hasDiscrepancy) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '${theme.translate('discrepancy')}: ${entry.discrepancy > 0 ? '+' : ''}${theme.formatNumber(entry.discrepancy)} ${comp.unitOfMeasure}',
                                                    style: theme.textStyle(
                                                      fontSize: 11,
                                                      color: entry.discrepancy > 0
                                                          ? AppColors.success
                                                          : AppColors.error,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),

                                          // Counter
                                          Row(
                                            children: [
                                              IconButton.filledTonal(
                                                onPressed: () {
                                                  if (entry.entry.countedQuantity > 0) {
                                                    ref
                                                        .read(
                                                          stocktakeRepositoryProvider,
                                                        )
                                                        .updateCountedQuantity(
                                                          entry.entry.id,
                                                          entry
                                                                  .entry
                                                                  .countedQuantity -
                                                              1,
                                                        );
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.remove_rounded,
                                                  size: 16,
                                                ),
                                                style: IconButton.styleFrom(
                                                  backgroundColor: theme.isDark
                                                      ? const Color(0xFF262A30)
                                                      : const Color(0xFFEAEFF5),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
                                                child: Text(
                                                  theme.formatNumber(
                                                    entry.entry.countedQuantity,
                                                  ),
                                                  style: theme.textStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: theme.textColor,
                                                  ),
                                                ),
                                              ),
                                              IconButton.filledTonal(
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                        stocktakeRepositoryProvider,
                                                      )
                                                      .updateCountedQuantity(
                                                        entry.entry.id,
                                                        entry
                                                                .entry
                                                                .countedQuantity +
                                                            1,
                                                      );
                                                },
                                                icon: const Icon(
                                                  Icons.add_rounded,
                                                  size: 16,
                                                ),
                                                style: IconButton.styleFrom(
                                                  backgroundColor: theme.isDark
                                                      ? const Color(0xFF262A30)
                                                      : const Color(0xFFEAEFF5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),

                        // Reconcile Button
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            border: Border(
                              top: BorderSide(color: theme.borderColor, width: 1),
                            ),
                          ),
                          child: SafeArea(
                            top: false,
                            child: PpButton(
                              label: theme.translate('reconcile'),
                              icon: Icons.check_rounded,
                              isLoading: _isReconciling,
                              onPressed: _reconcile,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        }

        // New Session Setup
        return Scaffold(
          backgroundColor: theme.primaryColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              theme.translate('stocktake_and_reconciliation'),
              style: theme.textStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textColor),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: theme.textColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PpCard(
                padding: const EdgeInsets.all(20),
                backgroundColor: theme.secondaryColor,
                borderColor: theme.borderColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.activeColor.withValues(alpha: 0.15),
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          child: Icon(
                            Icons.fact_check_rounded,
                            color: theme.activeColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          theme.translate('start_stocktake'),
                          style: theme.textStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      theme.translate('stocktake_desc'),
                      style: theme.textStyle(
                        fontSize: 13,
                        color: theme.subTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Location selector
                    StreamBuilder<List<Location>>(
                      stream: locationsAsync,
                      builder: (context, snapshot) {
                        final locations = snapshot.data ?? [];
                        return DropdownButtonFormField<String?>(
                          initialValue: _selectedLocationId,
                          dropdownColor: theme.secondaryColor,
                          style: theme.textStyle(fontSize: 14, color: theme.textColor),
                          decoration: InputDecoration(
                            labelText: theme.translate('audit_locations'),
                            labelStyle: theme.textStyle(fontSize: 13, color: theme.subTextColor),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text(
                                theme.currentLanguage == 'Persian'
                                    ? 'کل کارگاه (شمارش کامل)'
                                    : 'All Workshop (Full Count)',
                                style: theme.textStyle(fontSize: 14, color: theme.textColor),
                              ),
                            ),
                            ...locations.map(
                              (l) => DropdownMenuItem(
                                value: l.id,
                                child: Text(
                                  l.name,
                                  style: theme.textStyle(fontSize: 14, color: theme.textColor),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedLocationId = val),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    PpButton(
                      label: theme.translate('start_stocktake'),
                      icon: Icons.play_arrow_rounded,
                      isLoading: _isStarting,
                      onPressed: _startCounting,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StocktakeMetricBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final ThemeProvider theme;

  const _StocktakeMetricBox({
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return PpCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      backgroundColor: theme.secondaryColor,
      borderColor: theme.borderColor,
      child: Column(
        children: [
          Text(
            value,
            style: theme.textStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textStyle(
              fontSize: 10,
              color: theme.subTextColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
