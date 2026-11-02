import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/theme/category_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/pp_button.dart';
import '../../../core/widgets/pp_card.dart';
import '../../../core/widgets/pp_empty_state.dart';
import '../../stock_movements/presentation/receive_stock_dialog.dart';
import '../data/inventory_repository.dart';

class LowStockScreen extends ConsumerWidget {
  const LowStockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeProvider();

    final lowStockStream = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentsWithStock(lowStockOnly: true);
    final outOfStockStream = ref
        .watch(inventoryRepositoryProvider)
        .watchComponentsWithStock(outOfStockOnly: true);

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
              theme.translate('low_stock_alerts'),
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
          body: StreamBuilder<List<ComponentWithStock>>(
            stream: lowStockStream,
            builder: (context, lowSnapshot) {
              return StreamBuilder<List<ComponentWithStock>>(
                stream: outOfStockStream,
                builder: (context, outSnapshot) {
                  final lowItems = lowSnapshot.data ?? [];
                  final outItems = outSnapshot.data ?? [];
                  final allAttentionItems = [...outItems, ...lowItems];

                  if (allAttentionItems.isEmpty) {
                    return PpEmptyState(
                      icon: Icons.check_circle_outline_rounded,
                      title: theme.currentLanguage == 'Persian'
                          ? 'وضعیت موجودی قطعات مطلوب است'
                          : 'All Stock Levels Healthy',
                      message: theme.currentLanguage == 'Persian'
                          ? 'موجودی هیچ قطعه‌ای به زیر حد آستانه حداقل نرسیده است.'
                          : 'No components are currently below their minimum stock thresholds.',
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: allAttentionItems.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = allAttentionItems[index];
                            final comp = item.component;

                            return PpCard(
                              onTap: () => context.push('/component/${comp.id}'),
                              padding: const EdgeInsets.all(14),
                              backgroundColor: theme.secondaryColor,
                              borderColor: theme.borderColor,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: item.isOutOfStock
                                          ? AppColors.errorContainer
                                          : AppColors.warningContainer,
                                      borderRadius: AppSpacing.roundedSm,
                                    ),
                                    child: Icon(
                                      item.isOutOfStock
                                          ? Icons.error_outline_rounded
                                          : Icons.warning_amber_rounded,
                                      color: item.isOutOfStock
                                          ? AppColors.error
                                          : AppColors.warning,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          comp.category,
                                          style: theme.textStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: CategoryColors.getColor(
                                              comp.category,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          comp.name,
                                          style: theme.textStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: theme.textColor,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (comp.description != null &&
                                            comp.description!
                                                .trim()
                                                .isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            comp.description!,
                                            style: theme.textStyle(
                                              fontSize: 12,
                                              color: theme.subTextColor,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        if (comp.packageFootprint != null &&
                                            comp.packageFootprint!
                                                .trim()
                                                .isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            comp.packageFootprint!,
                                            style: theme.textStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w500,
                                              color: theme.subTextColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ] else if (comp.internalSku != null &&
                                            comp.internalSku!
                                                .trim()
                                                .isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            comp.internalSku!,
                                            style: theme.textStyle(
                                              fontSize: 11.5,
                                              color: theme.subTextColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        const SizedBox(height: 4),
                                        Text(
                                          '${theme.translate('quantity')}: ${theme.formatNumber(item.totalStock)} / ${theme.formatNumber(comp.minStockThreshold)} ${comp.unitOfMeasure}',
                                          style: theme.textStyle(
                                            fontSize: 11.5,
                                            color: item.isOutOfStock
                                                ? AppColors.error
                                                : AppColors.warning,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  PpButton(
                                    label: theme.translate('receive'),
                                    height: 36,
                                    fullWidth: false,
                                    icon: Icons.download_rounded,
                                    onPressed: () => ReceiveStockDialog.show(
                                      context,
                                      initialComponent: comp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Bottom Docked Order Button
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
                            label: theme.translate('create_po'),
                            icon: Icons.add_shopping_cart_rounded,
                            onPressed: () => context.push('/purchasing/new'),
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
      },
    );
  }
}
