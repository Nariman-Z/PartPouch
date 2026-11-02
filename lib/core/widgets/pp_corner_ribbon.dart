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
    this.size = 84,
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
      child: ClipRect(
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              PositionedDirectional(
                top: 14,
                end: -26,
                child: Transform.rotate(
                  angle: isRtl ? -math.pi / 4 : math.pi / 4,
                  child: Container(
                    width: 110,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      theme.formatNumber(label),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        color: textColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
