import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/currency_formatter.dart';
import '../../../core/theme/category_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../stock_movements/presentation/adjust_stock_dialog.dart';
import '../../stock_movements/presentation/transfer_stock_dialog.dart';
import '../data/locations_repository.dart';

class LocationDetailScreen extends ConsumerWidget {
  final String locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeProvider();
    final locationAsync = ref
        .watch(locationsRepositoryProvider)
        .watchLocationById(locationId);
    final statsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchLocationStockStats(locationId);
    final componentsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchComponentsInLocation(locationId);
    final subLocationsAsync = ref
        .watch(locationsRepositoryProvider)
        .watchSubLocations(locationId);

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        return StreamBuilder<Location?>(
          stream: locationAsync,
          builder: (context, locSnapshot) {
            final location = locSnapshot.data;

            if (locSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: theme.primaryColor,
                body: Center(
                  child: CircularProgressIndicator(color: theme.activeColor),
                ),
              );
            }

            if (location == null) {
              return Scaffold(
                backgroundColor: theme.primaryColor,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: theme.textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: PpEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: theme.translate('location_not_found'),
                  message: theme.translate('location_not_found_desc'),
                ),
              );
            }

            return Scaffold(
              backgroundColor: theme.primaryColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: theme.textColor),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  location.name,
                  style: theme.textStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
                actions: [
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded, color: theme.textColor),
                    color: theme.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: theme.borderColor),
                    ),
                    onSelected: (val) async {
                      if (val == 'archive') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: theme.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide(color: theme.borderColor),
                            ),
                            title: Text(
                              theme.translate('archive_location'),
                              style: theme.textStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                            content: Text(
                              theme.translate('archive_location_confirm'),
                              style: theme.textStyle(
                                fontSize: 13,
                                color: theme.subTextColor,
                              ),
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
                                      backgroundColor: AppColors.error,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text(
                                      theme.translate('archive_location'),
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

                        if (confirm == true && context.mounted) {
                          try {
                            await ref
                                .read(locationsRepositoryProvider)
                                .archiveLocation(location.id);
                            if (context.mounted) {
                              context.pop();
                              AppSnackBar.show(
                                context,
                                message:
                                    theme.translate('location_archived_success'),
                                type: SnackBarType.success,
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppSnackBar.show(
                                context,
                                message: e.toString(),
                                type: SnackBarType.error,
                              );
                            }
                          }
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.archive_outlined,
                              size: 18,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              theme.translate('archive_location'),
                              style: theme.textStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      children: [
                        // Location Banner
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.borderColor, width: 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: theme.activeColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.place_rounded,
                                  color: theme.activeColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      location.name,
                                      style: theme.textStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: theme.textColor,
                                      ),
                                    ),
                                    if (location.code != null &&
                                        location.code!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.activeColor
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: theme.activeColor
                                                .withValues(alpha: 0.35),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.qr_code_2_rounded,
                                              size: 14,
                                              color: theme.activeColor,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              location.code!,
                                              style: theme.textStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: theme.activeColor,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    if (location.parentId != null) ...[
                                      const SizedBox(height: 6),
                                      StreamBuilder<Location?>(
                                        stream: ref
                                            .watch(locationsRepositoryProvider)
                                            .watchParentLocation(
                                              location.parentId,
                                            ),
                                        builder: (context, pSnapshot) {
                                          final parent = pSnapshot.data;
                                          if (parent == null) {
                                            return const SizedBox.shrink();
                                          }
                                          return InkWell(
                                            onTap: () => context
                                                .push('/location/${parent.id}'),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .subdirectory_arrow_right_rounded,
                                                  size: 14,
                                                  color: theme.subTextColor,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${theme.translate('parent_location')}: ',
                                                  style: theme.textStyle(
                                                    fontSize: 12,
                                                    color: theme.subTextColor,
                                                  ),
                                                ),
                                                Text(
                                                  parent.name,
                                                  style: theme.textStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.activeColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (location.description != null &&
                            location.description!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              location.description!,
                              style: theme.textStyle(
                                fontSize: 13,
                                color: theme.subTextColor,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),

                        // 3 Stat Cards: Components, Units, Total Value
                        StreamBuilder<LocationStockStats>(
                          stream: statsAsync,
                          builder: (context, statsSnapshot) {
                            final stats = statsSnapshot.data ??
                                const LocationStockStats(
                                  componentCount: 0,
                                  totalUnits: 0,
                                  totalValueCents: 0,
                                );

                            return Row(
                              children: [
                                Expanded(
                                  child: _buildSmallStatCard(
                                    label: theme.translate('components'),
                                    value: theme
                                        .formatNumber(stats.componentCount),
                                    theme: theme,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildSmallStatCard(
                                    label: theme.translate('total_units_label'),
                                    value: theme.formatNumber(stats.totalUnits),
                                    theme: theme,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildSmallStatCard(
                                    label: theme.translate('total_cost'),
                                    value: theme.formatNumber(
                                      CurrencyFormatter.formatCents(
                                        stats.totalValueCents,
                                      ),
                                    ),
                                    theme: theme,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Sub-locations Section (if any)
                        StreamBuilder<List<Location>>(
                          stream: subLocationsAsync,
                          builder: (context, subSnapshot) {
                            final subs = subSnapshot.data ?? [];
                            if (subs.isEmpty) return const SizedBox.shrink();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      theme.translate('sub_locations'),
                                      style: theme.textStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: theme.textColor,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.activeColor
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        theme.formatNumber(subs.length),
                                        style: theme.textStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: theme.activeColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: subs.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final sub = subs[index];
                                    final subStatsAsync = ref
                                        .watch(locationsRepositoryProvider)
                                        .watchLocationStockStats(sub.id);

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: theme.secondaryColor,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: theme.borderColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(14),
                                        child: InkWell(
                                          onTap: () => context
                                              .push('/location/${sub.id}'),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .subdirectory_arrow_right_rounded,
                                                  color: theme.activeColor,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        sub.name,
                                                        style: theme.textStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              theme.textColor,
                                                        ),
                                                      ),
                                                      if (sub.code != null) ...[
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          sub.code!,
                                                          style: theme.textStyle(
                                                            fontSize: 11,
                                                            color: theme
                                                                .subTextColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                StreamBuilder<
                                                  LocationStockStats
                                                >(
                                                  stream: subStatsAsync,
                                                  builder: (context, snap) {
                                                    final u =
                                                        snap.data?.totalUnits ??
                                                        0;
                                                    if (u == 0) {
                                                      return Text(
                                                        theme.translate(
                                                          'empty_location',
                                                        ),
                                                        style: theme.textStyle(
                                                          fontSize: 12,
                                                          color:
                                                              theme.subTextColor,
                                                        ),
                                                      );
                                                    }
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                            horizontal: 8,
                                                            vertical: 3,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: theme.activeColor
                                                            .withValues(
                                                              alpha: 0.12,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Text(
                                                        '${theme.formatNumber(u)} pcs',
                                                        style: theme.textStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              theme.activeColor,
                                                        ),
                                                      ),
                                                    );
                                                  },
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
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Components Header
                        Text(
                          theme.translate('components_stored_here'),
                          style: theme.textStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.textColor,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Components List
                        StreamBuilder<List<LocationComponentItem>>(
                          stream: componentsAsync,
                          builder: (context, compSnapshot) {
                            final items = compSnapshot.data ?? [];

                            if (items.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40),
                                child: PpEmptyState(
                                  icon: Icons.inbox_rounded,
                                  title: theme.translate('no_stock_in_location'),
                                  message: theme.translate(
                                    'no_stock_in_location_desc',
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                final comp = item.component;

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
                                      onTap: () => context
                                          .push('/component/${comp.id}'),
                                      borderRadius: BorderRadius.circular(16),
                                      splashColor: theme.activeColor
                                          .withValues(alpha: 0.1),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: CategoryColors
                                                    .getContainerColor(
                                                  comp.category,
                                                  isDark: theme.isDark,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: CategoryColors
                                                      .getBorderColor(
                                                    comp.category,
                                                    isDark: theme.isDark,
                                                  ),
                                                  width: 1,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(
                                                CategoryColors.getCategoryIcon(
                                                    comp.category),
                                                color: CategoryColors
                                                    .getForegroundColor(
                                                  comp.category,
                                                  isDark: theme.isDark,
                                                ),
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  CategoryColors
                                                      .buildTitleRichText(
                                                    name: comp.name,
                                                    category: comp.category,
                                                    textColor: theme.textColor,
                                                    subTextColor:
                                                        theme.subTextColor,
                                                    fontSize: 14,
                                                    isPersian:
                                                        theme.currentLanguage ==
                                                            'Persian',
                                                  ),
                                                  if (comp.packageFootprint !=
                                                          null &&
                                                      comp.packageFootprint!
                                                          .trim()
                                                          .isNotEmpty) ...[
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      comp.packageFootprint!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: theme.textStyle(
                                                        fontSize: 11.5,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            theme.subTextColor,
                                                      ),
                                                    ),
                                                  ] else if (comp.description !=
                                                          null &&
                                                      comp.description!
                                                          .trim()
                                                          .isNotEmpty) ...[
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      comp.description!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: theme.textStyle(
                                                        fontSize: 11.5,
                                                        color:
                                                            theme.subTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '${theme.formatNumber(item.quantity)} ${comp.unitOfMeasure}',
                                              style: theme.textStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: theme.textColor,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: Icon(
                                                Icons.tune_rounded,
                                                color: theme.subTextColor,
                                                size: 18,
                                              ),
                                              tooltip: theme.translate(
                                                'calibrate_adjust',
                                              ),
                                              onPressed: () =>
                                                  AdjustStockDialog.show(
                                                context,
                                                component: comp,
                                                location: location,
                                                currentQuantity: item.quantity,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Bottom Button: Transfer Stock
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      color: theme.secondaryColor,
                      border: Border(
                        top: BorderSide(color: theme.borderColor, width: 1),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.activeColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.sync_alt_rounded, size: 20),
                          label: Text(
                            theme.translate('transfer_stock_from_here'),
                            style: theme.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => TransferStockDialog.show(
                            context,
                            initialSourceLocationId: location.id,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSmallStatCard({
    required String label,
    required String value,
    required ThemeProvider theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: theme.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textStyle(fontSize: 11, color: theme.subTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
