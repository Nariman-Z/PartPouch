import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

/// Ambinet-style Neumorphic card with dual-shadow depth and smooth rounded geometry.
class PpCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final bool isNeumorphic;
  final Clip clipBehavior;

  const PpCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.isNeumorphic = true,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(22);
    final effectiveBg = backgroundColor ?? theme.secondaryColor;

    final List<BoxShadow> shadows = [];
    if (isNeumorphic) {
      if (theme.isDark) {
        // Neumorphic Dark: Deep bottom shadow + subtle top specular highlight
        shadows.addAll([
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(3, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ]);
      } else {
        // Neumorphic Light: Soft clay shadow + crisp top-left highlight
        shadows.addAll([
          BoxShadow(
            color: const Color(0xFFCAD6E4).withValues(alpha: 0.6),
            blurRadius: 14,
            offset: const Offset(4, 6),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 12,
            offset: Offset(-3, -3),
          ),
        ]);
      }
    }

    final effectiveBorder = borderColor ??
        (theme.isDark
            ? Colors.white.withValues(alpha: 0.06)
            : const Color(0xFFE2E8F0));

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      clipBehavior: clipBehavior,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: effectiveBorderRadius,
        border: Border.all(color: effectiveBorder, width: 1.1),
        boxShadow: shadows,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          splashColor: theme.activeColor.withValues(alpha: 0.12),
          highlightColor: theme.elevatedColor.withValues(alpha: 0.2),
          child: content,
        ),
      );
    }

    return content;
  }
}
