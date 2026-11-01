import 'package:flutter/material.dart';

/// Centralized color palette for PartPouch following Ambinet design tokens.
/// Supports workshop-grade Dark theme, clean Light theme, and dynamic theme accent swatches.
class AppColors {
  AppColors._();

  // --- Dynamic Accent Swatches (in exact palette order) ---
  static const Color accentOrange = Color(0xFFFF5A1F); // PartPouch Vibrant Orange (default)
  static const Color accentBlue = Color(0xFF2196F3);   // Workshop Tech Blue
  static const Color accentGreen = Color(0xFF4CAF50);  // Emerald Green
  static const Color accentPurple = Color(0xFF7E3FF2); // Deep Ambinet Purple
  static const Color accentYellow = Color(0xFFFFC107); // Amber Gold
  static const Color accentRed = Color(0xFFFF5252);    // Coral Red

  /// Palette list in exact display order for Appearance settings
  static const List<Color> themeSwatches = [
    accentOrange,
    accentBlue,
    accentGreen,
    accentPurple,
    accentYellow,
    accentRed,
  ];

  // Default brand primary
  static const Color primary = accentOrange;
  static const Color primaryHover = Color(0xFFFF723E);
  static const Color primaryDark = Color(0xFFD94812);
  static const Color primaryContainer = Color(0x26FF5A1F);

  // Secondary brand
  static const Color secondary = accentBlue;
  static const Color secondaryContainer = Color(0x262196F3);

  // --- Theme: Dark (Workshop High-Contrast) ---
  static const Color darkPrimary = Color(0xFF07111A);
  static const Color darkSecondary = Color(0xFF0D1A25);
  static const Color darkElevated = Color(0xFF101F2C);
  static const Color darkHighlight = Color(0xFF152838);
  static const Color darkBorder = Color(0xFF1C3040);
  static const Color darkBorderSubtle = Color(0xFF142433);

  // --- Theme: Light (Clean Modern) ---
  static const Color lightPrimary = Color(0xFFF8F9FE);
  static const Color lightSecondary = Color(0xFFFFFFFF);
  static const Color lightElevated = Color(0xFFF0F2F7);
  static const Color lightHighlight = Color(0xFFE9ECF3);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderSubtle = Color(0xFFEDF2F7);

  // Default Dark-first surface aliases for backward compatibility
  static const Color background = darkPrimary;
  static const Color surface = darkSecondary;
  static const Color surfaceElevated = darkElevated;
  static const Color surfaceHighlight = darkHighlight;
  static const Color border = darkBorder;
  static const Color borderSubtle = darkBorderSubtle;
  static const Color darkCard = darkSecondary;
  static const Color lightCard = lightSecondary;

  // Text Colors (Dark mode defaults)
  static const Color textPrimary = Color(0xFFF3F6F8);
  static const Color textSecondary = Color(0xFF9BAAB6);
  static const Color textMuted = Color(0xFF627382);
  static const Color textDisabled = Color(0xFF435260);
  static const Color darkTextPrimary = textPrimary;
  static const Color darkTextSecondary = textSecondary;

  // Text Colors (Light mode)
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);
  static const Color lightTextDisabled = Color(0xFFCBD5E1);

  // Semantic Status Colors
  static const Color success = Color(0xFF2ECC71); // In stock / positive
  static const Color successContainer = Color(0x262ECC71);

  static const Color warning = Color(0xFFF39C12); // Low stock / attention
  static const Color warningContainer = Color(0x26F39C12);

  static const Color error = Color(0xFFE74C3C); // Out of stock / critical
  static const Color errorContainer = Color(0x26E74C3C);

  static const Color info = Color(0xFF3498DB);
  static const Color infoContainer = Color(0x263498DB);

  // Scanner Colors (Ambinet standard)
  static const Color scannerBorder = Color(0xFFE0E0E0);
  static const Color scannerOverlay = Color(0x99000000);
  static const Color scannerLine = accentOrange;

  // Linear Gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentOrange, Color(0xFFFF7B42)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
