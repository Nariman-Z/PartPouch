import 'package:flutter/material.dart';
import '../../../../core/theme/theme_provider.dart';

/// Neumorphic card container for grouping settings tiles matching Ambinet styling.
class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const SettingsCard({super.key, required this.children, this.padding});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final isDark = theme.isDark;

    List<Widget> separatedChildren = [];
    for (int i = 0; i < children.length; i++) {
      separatedChildren.add(children[i]);
      if (i < children.length - 1) {
        separatedChildren.add(
          Divider(
            height: 1,
            thickness: 1,
            color: theme.textColor.withValues(alpha: 0.04),
            indent: 60,
          ),
        );
      }
    }

    final List<BoxShadow> neumorphicShadows = isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(4, 8),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(-2, -2),
            ),
          ]
        : [
            BoxShadow(
              color: const Color(0xFFCAD6E4).withValues(alpha: 0.65),
              blurRadius: 16,
              offset: const Offset(5, 7),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 14,
              offset: Offset(-3, -3),
            ),
          ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.secondaryColor : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE2E8F0),
          width: 1.1,
        ),
        boxShadow: neumorphicShadows,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: separatedChildren,
          ),
        ),
      ),
    );
  }
}
