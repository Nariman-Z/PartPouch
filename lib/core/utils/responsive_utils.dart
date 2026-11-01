import 'package:flutter/material.dart';

/// Ambinet-style responsive breakpoint helpers for phones, foldables, and tablets.
class ResponsiveUtils {
  ResponsiveUtils._();

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 380;

  static bool isMediumPhone(BuildContext context) =>
      MediaQuery.of(context).size.width >= 380 &&
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double responsiveHeight(
    BuildContext context, {
    required double baseHeight,
    double minHeight = 60.0,
    double maxHeight = 100.0,
  }) {
    final scale = MediaQuery.of(context).size.height / 812.0;
    return (baseHeight * scale).clamp(minHeight, maxHeight);
  }
}
