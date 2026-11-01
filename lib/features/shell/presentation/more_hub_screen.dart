import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/pp_card.dart';

class MoreHubScreen extends StatelessWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

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
              theme.translate('more_tools'),
              style: theme.textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              _HubSectionHeader(
                title: theme.translate('procurement_and_stock'),
                theme: theme,
              ),
              _HubTile(
                icon: Icons.local_shipping_outlined,
                iconColor: theme.activeColor,
                title: theme.translate('purchase_orders'),
                subtitle: theme.translate('purchase_orders_desc'),
                onTap: () => context.push('/purchasing'),
                theme: theme,
              ),
              const SizedBox(height: 10),
              _HubTile(
                icon: Icons.storefront_outlined,
                iconColor: AppColors.secondary,
                title: theme.translate('suppliers_and_vendors'),
                subtitle: theme.translate('suppliers_desc'),
                onTap: () => context.push('/suppliers'),
                theme: theme,
              ),
              const SizedBox(height: 10),
              _HubTile(
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.warning,
                title: theme.translate('low_stock_alerts'),
                subtitle: theme.translate('low_stock_alerts_desc'),
                onTap: () => context.push('/low-stock'),
                theme: theme,
              ),
              const SizedBox(height: 22),

              _HubSectionHeader(
                title: theme.translate('auditing_and_intelligence'),
                theme: theme,
              ),
              _HubTile(
                icon: Icons.insights_outlined,
                iconColor: AppColors.success,
                title: theme.translate('reports_and_analytics'),
                subtitle: theme.translate('reports_desc'),
                onTap: () => context.push('/reports'),
                theme: theme,
              ),
              const SizedBox(height: 10),
              _HubTile(
                icon: Icons.fact_check_outlined,
                iconColor: AppColors.info,
                title: theme.translate('stocktake_and_reconciliation'),
                subtitle: theme.translate('stocktake_desc'),
                onTap: () => context.push('/stocktake'),
                theme: theme,
              ),
              const SizedBox(height: 10),
              _HubTile(
                icon: Icons.history_rounded,
                iconColor: theme.textColor,
                title: theme.translate('activity_ledger'),
                subtitle: theme.translate('activity_ledger_desc'),
                onTap: () => context.push('/activity'),
                theme: theme,
              ),
              const SizedBox(height: 22),

              _HubSectionHeader(
                title: theme.translate('system_and_storage'),
                theme: theme,
              ),
              _HubTile(
                icon: Icons.qr_code_scanner_rounded,
                iconColor: theme.activeColor,
                title: theme.translate('scan_qr_barcode'),
                subtitle: theme.translate('scan_qr_desc'),
                onTap: () => context.push('/scan'),
                theme: theme,
              ),
              const SizedBox(height: 10),
              _HubTile(
                icon: Icons.settings_outlined,
                iconColor: theme.subTextColor,
                title: theme.translate('settings_and_portability'),
                subtitle: theme.translate('settings_desc'),
                onTap: () => context.push('/settings'),
                theme: theme,
              ),
              const SizedBox(height: 120),
            ],
          ),
        );
      },
    );
  }
}

class _HubSectionHeader extends StatelessWidget {
  final String title;
  final ThemeProvider theme;

  const _HubSectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: theme.subTextColor.withValues(alpha: 0.8),
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final ThemeProvider theme;

  const _HubTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return PpCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
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
          Icon(
            Icons.chevron_right_rounded,
            color: theme.subTextColor.withValues(alpha: 0.4),
            size: 20,
          ),
        ],
      ),
    );
  }
}
