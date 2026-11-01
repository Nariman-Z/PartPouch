import 'package:flutter/material.dart';
import '../../../../core/theme/theme_provider.dart';

/// Reusable toggle tile for settings screens matching Ambinet styling.
class ToggleSettingsTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;
  final Color? iconBgColor;

  const ToggleSettingsTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final effectiveIconColor = iconColor ?? theme.activeColor;
    final effectiveIconBgColor =
        iconBgColor ?? effectiveIconColor.withValues(alpha: 0.12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: effectiveIconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: effectiveIconColor, size: 20),
            ),
            const SizedBox(width: 14),
          ],
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
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              activeTrackColor: theme.activeColor,
              activeThumbColor: Colors.white,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
