import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../theme/theme_provider.dart';

enum PpButtonVariant { primary, secondary, outline, danger, ghost }

/// Neumorphic embossed action button with dynamic active gradients and haptics.
class PpButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final PpButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final BorderRadius? borderRadius;

  const PpButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PpButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = 50,
    this.borderRadius,
  });

  @override
  State<PpButton> createState() => _PpButtonState();
}

class _PpButtonState extends State<PpButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final effectiveRadius = widget.borderRadius ?? BorderRadius.circular(18);

    final (Color bg, Color fg, BorderSide border, List<BoxShadow> shadows, Gradient? gradient) =
        _getStyling(theme);

    final textWidget = Text(
      widget.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        color: fg,
      ),
    );

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final canFlex = constraints.hasBoundedWidth;
        return Row(
          mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading) ...[
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              ),
              const SizedBox(width: 8),
            ] else if (widget.icon != null) ...[
              Icon(widget.icon, size: 19, color: fg),
              const SizedBox(width: 8),
            ],
            if (canFlex)
              Flexible(child: textWidget)
            else
              textWidget,
          ],
        );
      },
    );

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        height: widget.height,
        width: widget.fullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: gradient == null ? (widget.onPressed == null ? bg.withValues(alpha: 0.4) : bg) : null,
          gradient: widget.onPressed == null ? null : gradient,
          borderRadius: effectiveRadius,
          border: Border.fromBorderSide(border),
          boxShadow: widget.onPressed == null ? null : shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (widget.isLoading || widget.onPressed == null)
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    widget.onPressed!();
                  },
            onHighlightChanged: (val) {
              setState(() => _isPressed = val);
            },
            borderRadius: effectiveRadius,
            splashColor: fg.withValues(alpha: 0.16),
            highlightColor: fg.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  (Color, Color, BorderSide, List<BoxShadow>, Gradient?) _getStyling(
    ThemeProvider theme,
  ) {
    switch (widget.variant) {
      case PpButtonVariant.primary:
        return (
          theme.activeColor,
          Colors.white,
          BorderSide.none,
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.isDark ? 0.35 : 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          null,
        );
      case PpButtonVariant.secondary:
        return (
          theme.elevatedColor,
          theme.textColor,
          BorderSide(
            color: theme.isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE2E8F0),
            width: 1.1,
          ),
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.isDark ? 0.35 : 0.08),
              blurRadius: 12,
              offset: const Offset(3, 5),
            ),
            BoxShadow(
              color: theme.isDark
                  ? Colors.white.withValues(alpha: 0.035)
                  : Colors.white,
              blurRadius: 10,
              offset: const Offset(-2, -2),
            ),
          ],
          null,
        );
      case PpButtonVariant.outline:
        return (
          Colors.transparent,
          theme.textColor,
          BorderSide(color: theme.borderColor, width: 1.2),
          [],
          null,
        );
      case PpButtonVariant.danger:
        return (
          AppColors.error,
          Colors.white,
          BorderSide.none,
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.isDark ? 0.35 : 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          null,
        );
      case PpButtonVariant.ghost:
        return (
          Colors.transparent,
          theme.subTextColor,
          BorderSide.none,
          [],
          null,
        );
    }
  }
}
