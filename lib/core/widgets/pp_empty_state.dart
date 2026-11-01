import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import 'pp_button.dart';

class PpEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const PpEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: theme.elevatedColor,
                shape: BoxShape.circle,
                border: Border.all(color: theme.borderColor, width: 1.5),
              ),
              child: Icon(icon, size: 40, color: theme.activeColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: theme.subTextColor,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              PpButton(
                label: actionLabel!,
                onPressed: onAction,
                fullWidth: false,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
