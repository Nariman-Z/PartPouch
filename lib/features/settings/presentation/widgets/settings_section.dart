import 'package:flutter/material.dart';
import '../../../../core/theme/theme_provider.dart';

/// Section header widget for grouping settings cards matching Ambinet design rules.
class SettingsSection extends StatelessWidget {
  final String title;

  const SettingsSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
      child: Text(
        title,
        style: theme.textStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: theme.textColor,
        ),
      ),
    );
  }
}
