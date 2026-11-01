import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

enum SnackBarType { success, error, info }

/// Global utility for displaying consistent floating SnackBars matching the Ambinet design system.
class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.success,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = ThemeProvider();

    IconData leadingIcon = icon ?? Icons.check_circle_outline_rounded;
    Color iconColor = theme.activeColor;

    if (type == SnackBarType.error) {
      leadingIcon = icon ?? Icons.error_outline_rounded;
      iconColor = Colors.redAccent;
    } else if (type == SnackBarType.info) {
      leadingIcon = icon ?? Icons.info_outline_rounded;
      iconColor = Colors.amber;
    }

    final snackBar = SnackBar(
      backgroundColor: theme.secondaryColor,
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.borderColor.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      duration: duration,
      content: Row(
        children: [
          Icon(leadingIcon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.textColor,
              ),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
