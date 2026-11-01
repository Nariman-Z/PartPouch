import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/theme_provider.dart';

enum BadgeVariant {
  inStock,
  lowStock,
  outOfStock,
  neutral,
  primary,
  info,
  success,
  warning,
  error,
}

class PpBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final IconData? icon;

  const PpBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final (Color bg, Color fg, Color border) = _getColors(theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            theme.formatNumber(label),
            style: theme.textStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, Color) _getColors(ThemeProvider theme) {
    switch (variant) {
      case BadgeVariant.inStock:
      case BadgeVariant.success:
        return (
          AppColors.success.withValues(alpha: 0.15),
          AppColors.success,
          AppColors.success.withValues(alpha: 0.3),
        );
      case BadgeVariant.lowStock:
      case BadgeVariant.warning:
        return (
          AppColors.warning.withValues(alpha: 0.15),
          AppColors.warning,
          AppColors.warning.withValues(alpha: 0.3),
        );
      case BadgeVariant.outOfStock:
      case BadgeVariant.error:
        return (
          AppColors.error.withValues(alpha: 0.15),
          AppColors.error,
          AppColors.error.withValues(alpha: 0.3),
        );
      case BadgeVariant.primary:
        return (
          theme.activeColor.withValues(alpha: 0.15),
          theme.activeColor,
          theme.activeColor.withValues(alpha: 0.3),
        );
      case BadgeVariant.info:
        return (
          AppColors.secondary.withValues(alpha: 0.15),
          AppColors.secondary,
          AppColors.secondary.withValues(alpha: 0.3),
        );
      case BadgeVariant.neutral:
        return (
          theme.elevatedColor,
          theme.subTextColor,
          theme.borderColor,
        );
    }
  }
}
