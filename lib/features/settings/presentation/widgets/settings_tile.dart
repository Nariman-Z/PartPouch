import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/theme_provider.dart';

/// Standard navigation and action tile for settings screens matching Ambinet design rules.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? iconBgColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final effectiveIconColor = iconColor ?? theme.activeColor;
    final effectiveIconBgColor =
        iconBgColor ?? effectiveIconColor.withValues(alpha: 0.12);

    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onTap!();
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Neumorphic icon pod
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: effectiveIconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(icon, color: effectiveIconColor, size: 20),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.textColor,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textStyle(
                        fontSize: 12,
                        color: theme.subTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing!,
            ] else if (onTap != null) ...[
              Icon(
                Icons.chevron_right_rounded,
                color: theme.subTextColor.withValues(alpha: 0.4),
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
