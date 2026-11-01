import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/database/database.dart';
import '../../../core/formatting/date_formatter.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../inventory/data/inventory_repository.dart';
import '../data/stock_movements_repository.dart';

class ActivityHistoryScreen extends ConsumerStatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  ConsumerState<ActivityHistoryScreen> createState() =>
      _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends ConsumerState<ActivityHistoryScreen> {
  String _selectedType = 'All'; // All, received, issued, transfer, adjustment, stocktake

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    final movementsAsync = ref
        .watch(stockMovementsRepositoryProvider)
        .watchRecentMovements(limit: 100);

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
              theme.translate('activity_ledger'),
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
              // Filter Chips
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTypeChip('All', theme.translate('all_movements'), theme),
                      const SizedBox(width: 8),
                      _buildTypeChip('received', theme.translate('receive_stock'), theme),
                      const SizedBox(width: 8),
                      _buildTypeChip('issued', theme.translate('use_stock'), theme),
                      const SizedBox(width: 8),
                      _buildTypeChip('transfer', theme.translate('transfer_stock'), theme),
                      const SizedBox(width: 8),
                      _buildTypeChip('positiveAdjustment', theme.translate('adjust_stock'), theme),
                      const SizedBox(width: 8),
                      _buildTypeChip('stocktakeReconciliation', theme.translate('stocktake_desc'), theme),
                    ],
                  ),
                ),
              ),

              // Movements List
              Expanded(
                child: StreamBuilder<List<StockMovement>>(
                  stream: movementsAsync,
                  builder: (context, snapshot) {
                    final allMovements = snapshot.data ?? [];

                    final filtered = allMovements.where((m) {
                      if (_selectedType == 'All') return true;
                      if (_selectedType == 'positiveAdjustment') {
                        return m.movementType == 'positiveAdjustment' ||
                            m.movementType == 'negativeAdjustment';
                      }
                      return m.movementType == _selectedType;
                    }).toList();

                    if (filtered.isEmpty) {
                      return PpEmptyState(
                        icon: Icons.history_rounded,
                        title: theme.translate('activity_ledger'),
                        message: theme.translate('activity_ledger_desc'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final m = filtered[index];
                        return _ActivityTile(movement: m, theme: theme);
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

  Widget _buildTypeChip(String type, String label, ThemeProvider theme) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
        child: Text(
          label,
          style: theme.textStyle(
            fontSize: 11,
            color: isSelected ? theme.activeColor : theme.subTextColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends ConsumerWidget {
  final StockMovement movement;
  final ThemeProvider theme;

  const _ActivityTile({required this.movement, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compAsync = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentById(movement.componentId);

    return StreamBuilder<Component?>(
      stream: compAsync,
      builder: (context, snapshot) {
        final comp = snapshot.data;
        final name = comp?.name ?? theme.translate('components');
        final uom = comp?.unitOfMeasure ?? 'pcs';

        final (IconData icon, Color color, String typeLabel, String deltaText) =
            _getMovementStyle(uom, theme);

        return PpCard(
          onTap: () {
            if (comp != null) context.push('/component/${comp.id}');
          },
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
                      name,
                      style: theme.textStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textColor,
                      ),
                    ),
                    Text(
                      '$typeLabel • ${DateFormatter.formatDateTime(movement.createdAt)}',
                      style: theme.textStyle(fontSize: 12, color: theme.subTextColor),
                    ),
                    if (movement.notes != null &&
                        movement.notes!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        movement.notes!,
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
              Text(
                deltaText,
                style: theme.textStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  (IconData, Color, String, String) _getMovementStyle(String uom, ThemeProvider theme) {
    switch (movement.movementType) {
      case 'received':
      case 'purchaseOrderReceipt':
        return (
          Icons.download_rounded,
          AppColors.success,
          theme.translate('receive_stock'),
          '+${theme.formatNumber(movement.quantityDelta)} $uom',
        );
      case 'issued':
        return (
          Icons.upload_rounded,
          AppColors.warning,
          theme.translate('use_stock'),
          '${theme.formatNumber(movement.quantityDelta)} $uom',
        );
      case 'transfer':
        return (
          Icons.sync_alt_rounded,
          AppColors.accentBlue,
          theme.translate('transfer_stock'),
          '${theme.formatNumber(movement.quantityDelta)} $uom',
        );
      case 'positiveAdjustment':
        return (
          Icons.arrow_upward_rounded,
          AppColors.success,
          theme.translate('adjust_stock'),
          '+${theme.formatNumber(movement.quantityDelta)} $uom',
        );
      case 'negativeAdjustment':
        return (
          Icons.arrow_downward_rounded,
          AppColors.error,
          theme.translate('adjust_stock'),
          '${theme.formatNumber(movement.quantityDelta)} $uom',
        );
      case 'stocktakeReconciliation':
        return (
          Icons.fact_check_rounded,
          AppColors.info,
          theme.translate('reconcile'),
          '${movement.quantityDelta > 0 ? '+' : ''}${theme.formatNumber(movement.quantityDelta)} $uom',
        );
      case 'initialStock':
      default:
        return (
          Icons.add_box_outlined,
          theme.activeColor,
          theme.currentLanguage == 'Persian' ? 'موجودی اولیه' : 'Initial Stock',
          '+${theme.formatNumber(movement.quantityDelta)} $uom',
        );
    }
  }
}
