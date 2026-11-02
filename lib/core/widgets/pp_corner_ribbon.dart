import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/theme_provider.dart';

/// A diagonal corner ribbon banner (e.g. "\" shape in top-trailing corner)
/// used for showing project status, promotions, or indicators.
class PpCornerRibbon extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final double size;

  const PpCornerRibbon({
    super.key,
    required this.label,
    required this.color,
    this.textColor = Colors.white,
    this.size = 78,
  });

  /// Factory helper that automatically picks color & localized label from project status
  factory PpCornerRibbon.fromProjectStatus(String status, ThemeProvider theme) {
    Color ribbonColor;
    String statusText;

    switch (status) {
      case 'inProgress':
      case 'in_progress':
        ribbonColor = theme.activeColor;
        statusText = theme.translate('in_progress');
        break;
      case 'planning':
        ribbonColor = AppColors.accentBlue;
        statusText = theme.translate('planning');
        break;
      case 'completed':
        ribbonColor = AppColors.success;
        statusText = theme.translate('completed');
        break;
      case 'onHold':
      case 'on_hold':
        ribbonColor = AppColors.warning;
        statusText = theme.translate('on_hold');
        break;
      case 'cancelled':
        ribbonColor = AppColors.error;
        statusText = theme.translate('cancelled');
        break;
      default:
        ribbonColor = theme.subTextColor;
        statusText = status;
        break;
    }

    return PpCornerRibbon(
      label: statusText,
      color: ribbonColor,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final isRtl = theme.isRtl;

    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          size: Size(size, size),
          painter: _CornerRibbonPainter(
            text: theme.formatNumber(label),
            color: color,
            textColor: textColor,
            isRtl: isRtl,
          ),
        ),
      ),
    );
  }
}

class _CornerRibbonPainter extends CustomPainter {
  final String text;
  final Color color;
  final Color textColor;
  final bool isRtl;

  _CornerRibbonPainter({
    required this.text,
    required this.color,
    required this.textColor,
    required this.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;

    // Geometric offsets for the diagonal ribbon
    const d1 = 14.0;
    const d2 = 66.0;

    final ribbonPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (!isRtl) {
      // Top-right corner in LTR (creates a "\" diagonal ribbon)
      path.moveTo(w - d2, 0);
      path.lineTo(w - d1, 0);
      path.lineTo(w, d1);
      path.lineTo(w, d2);
      path.close();

      // Shadow under ribbon
      canvas.drawShadow(path, Colors.black.withValues(alpha: 0.35), 3.0, true);
      canvas.drawPath(path, ribbonPaint);

      // Subtle edge highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      canvas.drawLine(Offset(w - d1, 0), Offset(w, d1), highlightPaint);

      // Paint centered rotated text
      canvas.save();
      final cx = w - (d1 + d2) / 2;
      final cy = (d1 + d2) / 2;
      canvas.translate(cx, cy);
      canvas.rotate(math.pi / 4);

      _drawText(canvas, availableWidth: 52);
      canvas.restore();
    } else {
      // Top-left corner in RTL (creates a "/" diagonal ribbon)
      path.moveTo(d1, 0);
      path.lineTo(d2, 0);
      path.lineTo(0, d2);
      path.lineTo(0, d1);
      path.close();

      canvas.drawShadow(path, Colors.black.withValues(alpha: 0.35), 3.0, true);
      canvas.drawPath(path, ribbonPaint);

      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      canvas.drawLine(Offset(d1, 0), Offset(0, d1), highlightPaint);

      canvas.save();
      final cx = (d1 + d2) / 2;
      final cy = (d1 + d2) / 2;
      canvas.translate(cx, cy);
      canvas.rotate(-math.pi / 4);

      _drawText(canvas, availableWidth: 52);
      canvas.restore();
    }
  }

  void _drawText(Canvas canvas, {required double availableWidth}) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'Vazirmatn',
        color: textColor,
        fontSize: 10.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    // Auto-scale text down if it exceeds the available diagonal width
    if (textPainter.width > availableWidth) {
      final scale = availableWidth / textPainter.width;
      canvas.scale(scale, scale);
    }

    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CornerRibbonPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.color != color ||
        oldDelegate.textColor != textColor ||
        oldDelegate.isRtl != isRtl;
  }
}
