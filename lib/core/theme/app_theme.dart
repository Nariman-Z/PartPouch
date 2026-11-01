import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// Ambinet-styled ThemeData builder for PartPouch supporting Dark & Light themes,
/// RTL layout with Vazirmatn font, and dynamic accent color swatches.
class AppTheme {
  AppTheme._();

  /// Backward-compatible dark theme getter
  static ThemeData get darkTheme => getTheme(true);

  /// Backward-compatible light theme getter
  static ThemeData get lightTheme => getTheme(false);

  /// Main theme builder matching Ambinet AppTheme structure
  static ThemeData getTheme(
    bool isDark, {
    bool isRtl = false,
    Color? activeColor,
  }) {
    final primaryBg = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final secondaryBg =
        isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final elevatedBg =
        isDark ? AppColors.darkElevated : AppColors.lightElevated;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final borderSubtle =
        isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle;
    final textPrimary =
        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
    final textMuted = isDark ? AppColors.textMuted : AppColors.lightTextMuted;

    final accent = activeColor ?? AppColors.accentOrange;

    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: primaryBg,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    );

    final baseTextTheme = isDark
        ? ThemeData(brightness: Brightness.dark).textTheme
        : ThemeData(brightness: Brightness.light).textTheme;

    final textTheme = baseTextTheme.apply(
      fontFamily: 'Vazirmatn',
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Vazirmatn',
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: accent,
      scaffoldBackgroundColor: primaryBg,
      cardColor: secondaryBg,
      canvasColor: secondaryBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: accent,
        onPrimary: Colors.white,
        primaryContainer: accent.withValues(alpha: 0.15),
        onPrimaryContainer: accent,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondary.withValues(alpha: 0.15),
        onSecondaryContainer: AppColors.secondary,
        surface: secondaryBg,
        onSurface: textPrimary,
        error: AppColors.error,
        onError: Colors.white,
        outline: border,
        outlineVariant: borderSubtle,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBg,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        systemOverlayStyle: overlayStyle,
      ),
      cardTheme: CardThemeData(
        color: secondaryBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: border, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: secondaryBg,
        selectedItemColor: accent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: elevatedBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 14,
          color: textMuted,
        ),
        labelStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 14,
          color: textSecondary,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 12,
          color: AppColors.error,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border, width: 1),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: elevatedBg,
        side: BorderSide(color: border),
        labelStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 12,
          color: textSecondary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dividerColor: border,
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: secondaryBg,
        elevation: 8,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: border, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: elevatedBg,
        modalBackgroundColor: elevatedBg,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
