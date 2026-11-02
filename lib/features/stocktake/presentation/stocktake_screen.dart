import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/database/database.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_badge.dart';
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

                                          // Counter - Fixed width alignment so - and + align vertically
                                          SizedBox(
                                            width: 126,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 36,
                                                  height: 36,
                                                  child: IconButton.filledTonal(
                                                    padding: EdgeInsets.zero,
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
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    theme.formatNumber(
                                                      entry.entry.countedQuantity,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: theme.textStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: theme.textColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 36,
                                                  height: 36,
                                                  child: IconButton.filledTonal(
                                                    padding: EdgeInsets.zero,
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
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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

        // Dedicated Stocktake Screen with Ambinet UI/UX and Audit History
        final allSessionsAsync =
            ref.watch(stocktakeRepositoryProvider).watchAllSessions();

        return Scaffold(
          backgroundColor: theme.primaryColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              theme.translate('stocktake_and_reconciliation'),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // 1. Header Hero Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: theme.isDark ? 0.25 : 0.04,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.activeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.fact_check_rounded,
                            color: theme.activeColor,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                theme.translate('start_stocktake'),
                                style: theme.textStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                theme.translate('stocktake_desc'),
                                style: theme.textStyle(
                                  fontSize: 12.5,
                                  color: theme.subTextColor,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Location scope label
                    Text(
                      theme.currentLanguage == 'Persian'
                          ? 'محدوده و مکان انبارگردانی:'
                          : 'Audit Scope / Location:',
                      style: theme.textStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Ambinet-styled Location Dropdown Selector
                    StreamBuilder<List<Location>>(
                      stream: locationsAsync,
                      builder: (context, snapshot) {
                        final locations = snapshot.data ?? [];

                        return Container(
                          decoration: BoxDecoration(
                            color: theme.isDark
                                ? const Color(0xFF101F2C)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.borderColor,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 3,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: _selectedLocationId,
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: theme.textColor,
                              ),
                              dropdownColor: theme.secondaryColor,
                              borderRadius: BorderRadius.circular(16),
                              style: theme.textStyle(
                                fontSize: 14,
                                color: theme.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                              items: [
                                DropdownMenuItem<String?>(
                                  value: null,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.all_inclusive_rounded,
                                        size: 20,
                                        color: theme.activeColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          theme.currentLanguage == 'Persian'
                                              ? 'کل کارگاه (شمارش جامع)'
                                              : 'All Workshop (Full Count)',
                                          style: theme.textStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: theme.textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...locations.map(
                                  (l) => DropdownMenuItem<String?>(
                                    value: l.id,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.place_outlined,
                                          size: 20,
                                          color: theme.subTextColor,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            l.name,
                                            style: theme.textStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: theme.textColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (val) =>
                                  setState(() => _selectedLocationId = val),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    // Primary Start Stocktake Button
                    PpButton(
                      label: theme.translate('start_stocktake'),
                      icon: Icons.play_arrow_rounded,
                      isLoading: _isStarting,
                      onPressed: _startCounting,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Audit Guidelines / Best Practices
              Row(
                children: [
                  Expanded(
                    child: _AuditGuidePill(
                      icon: Icons.qr_code_scanner_rounded,
                      title: theme.currentLanguage == 'Persian'
                          ? 'شمارش بارکد'
                          : 'Scan & Count',
                      desc: theme.currentLanguage == 'Persian'
                          ? 'شمارش دقیق فیزیکی قفسه‌ها'
                          : 'Audit physical bins & drawers',
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _AuditGuidePill(
                      icon: Icons.sync_alt_rounded,
                      title: theme.currentLanguage == 'Persian'
                          ? 'ثبت مغایرت'
                          : 'Reconcile',
                      desc: theme.currentLanguage == 'Persian'
                          ? 'اصلاح خودکار دفتر کل'
                          : 'Auto ledger drift adjustment',
                      theme: theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Past Sessions & History
              Text(
                theme.currentLanguage == 'Persian'
                    ? 'تاریخچه و جلسات انبارگردانی'
                    : 'Stocktake History & Audits',
                style: theme.textStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),
              const SizedBox(height: 12),

              StreamBuilder<List<StocktakeSessionWithDetails>>(
                stream: allSessionsAsync,
                builder: (context, snapshot) {
                  final sessions = snapshot.data ?? [];

                  if (sessions.isEmpty) {
                    return PpCard(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 16,
                      ),
                      backgroundColor: theme.secondaryColor,
                      borderColor: theme.borderColor,
                      child: Column(
                        children: [
                          Icon(
                            Icons.history_toggle_off_rounded,
                            size: 40,
                            color: theme.subTextColor.withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            theme.currentLanguage == 'Persian'
                                ? 'تاکنون جلسه انبارگردانی ثبت نشده است'
                                : 'No prior stocktake sessions recorded',
                            style: theme.textStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            theme.currentLanguage == 'Persian'
                                ? 'برای شروع اولین حسابرسی، دکمه بالا را فشار دهید.'
                                : 'Start your first audit count above to verify inventory balances.',
                            textAlign: TextAlign.center,
                            style: theme.textStyle(
                              fontSize: 12,
                              color: theme.subTextColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sessions.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = sessions[index];
                      final isCompleted = item.session.completedAt != null;
                      final dateStr = DateFormat('MMM d, yyyy • HH:mm')
                          .format(item.session.startedAt);

                      return PpCard(
                        padding: const EdgeInsets.all(14),
                        backgroundColor: theme.secondaryColor,
                        borderColor: theme.borderColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  item.location != null
                                      ? Icons.place_outlined
                                      : Icons.warehouse_outlined,
                                  size: 18,
                                  color: theme.activeColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.location?.name ??
                                        (theme.currentLanguage == 'Persian'
                                            ? 'کل کارگاه'
                                            : 'All Workshop'),
                                    style: theme.textStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: theme.textColor,
                                    ),
                                  ),
                                ),
                                PpBadge(
                                  label: isCompleted
                                      ? (theme.currentLanguage == 'Persian'
                                          ? 'اصلاح‌شده'
                                          : 'Reconciled')
                                      : (theme.currentLanguage == 'Persian'
                                          ? 'در حال شمارش'
                                          : 'In Progress'),
                                  variant: isCompleted
                                      ? BadgeVariant.success
                                      : BadgeVariant.warning,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  dateStr,
                                  style: theme.textStyle(
                                    fontSize: 12,
                                    color: theme.subTextColor,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${theme.translate('total_items')}: ${theme.formatNumber(item.totalEntries)}',
                                  style: theme.textStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textColor,
                                  ),
                                ),
                                if (item.discrepancyCount > 0) ...[
                                  Text(
                                    ' • ${item.discrepancyCount} ${theme.translate('discrepancy')}',
                                    style: theme.textStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.warning,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (!isCompleted) ...[
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  icon: const Icon(Icons.play_arrow_rounded,
                                      size: 18),
                                  label: Text(
                                    theme.currentLanguage == 'Persian'
                                        ? 'ادامه شمارش'
                                        : 'Resume Audit',
                                    style: theme.textStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: theme.activeColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() =>
                                        _activeSessionId = item.session.id);
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
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

class _AuditGuidePill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final ThemeProvider theme;

  const _AuditGuidePill({
    required this.icon,
    required this.title,
    required this.desc,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.activeColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: theme.textStyle(
              fontSize: 11,
              color: theme.subTextColor,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
