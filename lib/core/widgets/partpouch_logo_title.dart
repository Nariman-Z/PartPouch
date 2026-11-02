import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

/// Reusable brand title where "Part" follows theme.textColor and "Pouch" follows theme.activeColor
class PartPouchBrandTitle extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;

  const PartPouchBrandTitle({
    super.key,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w800,
    this.letterSpacing = -0.5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();

    return ListenableBuilder(
      listenable: theme,
      builder: (context, _) {
        final partColor =
            theme.isDark ? Colors.white : const Color(0xFF0F172A);

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Part',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: partColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  letterSpacing: letterSpacing,
                ),
              ),
              TextSpan(
                text: 'Pouch',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: theme.activeColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  letterSpacing: letterSpacing,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
