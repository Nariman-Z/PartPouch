import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../localization/app_translations.dart';

/// Manages visual theme mode (dark/light/system), language (English/Persian),
/// dynamic theme accent color, and currency valuation (USD/Toman) for PartPouch.
class ThemeProvider extends ChangeNotifier {
  static final ThemeProvider _instance = ThemeProvider._internal();
  factory ThemeProvider() => _instance;

  ThemeProvider._internal() {
    _rebuildStyleCache();
  }

  static const String _themePreferenceKey = 'app_theme_mode';
  static const String _langPreferenceKey = 'app_language';
  static const String _colorPreferenceKey = 'app_primary_color';
  static const String _currencyPreferenceKey = 'app_currency';
  static const String _ratePreferenceKey = 'app_usd_to_toman_rate';

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Defaults to Dark theme for workshop-grade experience
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  String _currentLanguage = 'English';
  String get currentLanguage => _currentLanguage;

  Locale get locale => _currentLanguage == 'Persian'
      ? const Locale('fa', 'IR')
      : const Locale('en', 'US');

  Color _activeColor = AppColors.accentOrange;
  Color get activeColor => _activeColor;

  // Currency & Exchange Rate (USD / Toman)
  String _currency = 'USD'; // 'USD' or 'TOMAN'
  String get currency => _currency;
  bool get isToman => _currency == 'TOMAN';

  double _usdToTomanRate = 275000.0;
  double get usdToTomanRate => _usdToTomanRate;

  String get currencySymbol =>
      isToman ? (_currentLanguage == 'Persian' ? 'تومان' : 'Toman') : '\$';

  bool get isRtl => _currentLanguage == 'Persian';

  bool get isDark {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // ---------------------------------------------------------------------------
  // TextStyle cache using locally bundled Vazirmatn font
  // ---------------------------------------------------------------------------
  late TextStyle _baseStyle;

  void _rebuildStyleCache() {
    _baseStyle = const TextStyle(
      fontFamily: 'Vazirmatn',
      letterSpacing: -0.2,
    );
  }

  TextStyle get font => _baseStyle;

  TextStyle textStyle({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return _baseStyle.copyWith(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Initialize from SharedPreferences
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      final savedThemeIndex = prefs.getInt(_themePreferenceKey);
      if (savedThemeIndex != null &&
          savedThemeIndex >= 0 &&
          savedThemeIndex < ThemeMode.values.length) {
        _themeMode = ThemeMode.values[savedThemeIndex];
      }

      final savedLang = prefs.getString(_langPreferenceKey);
      if (savedLang != null &&
          (savedLang == 'English' || savedLang == 'Persian')) {
        _currentLanguage = savedLang;
      }

      final savedColor = prefs.getInt(_colorPreferenceKey);
      if (savedColor != null) {
        _activeColor = Color(savedColor);
      }

      final savedCurrency = prefs.getString(_currencyPreferenceKey);
      if (savedCurrency != null &&
          (savedCurrency == 'USD' || savedCurrency == 'TOMAN')) {
        _currency = savedCurrency;
      }

      final savedRate = prefs.getDouble(_ratePreferenceKey);
      if (savedRate != null && savedRate > 0) {
        _usdToTomanRate = savedRate;
      }
    } catch (_) {
      // Fallback to default in test environments or initial runs
    }

    _rebuildStyleCache();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePreferenceKey, mode.index);
    } catch (_) {}
  }

  Future<void> setLanguage(String lang) async {
    _currentLanguage = lang;
    _rebuildStyleCache();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_langPreferenceKey, lang);
    } catch (_) {}
  }

  Future<void> setActiveColor(Color color) async {
    _activeColor = color;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_colorPreferenceKey, color.toARGB32());
    } catch (_) {}
  }

  Future<void> setCurrency(String cur) async {
    _currency = cur;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyPreferenceKey, cur);
    } catch (_) {}
  }

  Future<void> setUsdToTomanRate(double rate) async {
    if (rate <= 0) return;
    _usdToTomanRate = rate;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_ratePreferenceKey, rate);
    } catch (_) {}
  }

  Future<void> toggleTheme() async {
    if (isDark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.dark;
    _currentLanguage = 'English';
    _activeColor = AppColors.accentOrange;
    _currency = 'USD';
    _usdToTomanRate = 275000.0;
    _rebuildStyleCache();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themePreferenceKey);
      await prefs.remove(_langPreferenceKey);
      await prefs.remove(_colorPreferenceKey);
      await prefs.remove(_currencyPreferenceKey);
      await prefs.remove(_ratePreferenceKey);
    } catch (_) {}
  }

  String translate(String key) {
    return AppTranslations.localizedValues[_currentLanguage]?[key] ?? key;
  }

  /// Converts English digits to Persian digits when active language is Persian
  String formatNumber(dynamic number) {
    if (number == null) return '';
    String input = number.toString();
    if (!isRtl) return input;

    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ','];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹', '٬'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], persian[i]);
    }
    return input;
  }

  /// Formats integer cents into active currency (USD or recalculated Toman)
  String formatCurrency(int? cents) {
    if (cents == null) return '--';
    final double usdAmount = cents / 100.0;

    if (isToman) {
      final double tomanAmount = usdAmount * _usdToTomanRate;
      final String formattedToman =
          NumberFormat('#,##0').format(tomanAmount.round());
      if (isRtl) {
        return '${formatNumber(formattedToman)} تومان';
      } else {
        return '$formattedToman Toman';
      }
    } else {
      final formattedUsd = NumberFormat.currency(
        symbol: '\$',
        decimalDigits: 2,
      ).format(usdAmount);
      if (isRtl) {
        return formatNumber(formattedUsd);
      } else {
        return formattedUsd;
      }
    }
  }

  // Adaptive theme colors
  Color get primaryColor =>
      isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

  Color get secondaryColor =>
      isDark ? AppColors.darkSecondary : AppColors.lightSecondary;

  Color get elevatedColor =>
      isDark ? AppColors.darkElevated : AppColors.lightElevated;

  Color get borderColor =>
      isDark ? AppColors.darkBorder : AppColors.lightBorder;

  Color get textColor =>
      isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;

  Color get subTextColor =>
      isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

  List<Color> get activeGradient {
    final HSLColor hsl = HSLColor.fromColor(activeColor);
    final HSLColor secondaryHsl = hsl
        .withHue((hsl.hue - 35 + 360) % 360)
        .withLightness((hsl.lightness * 0.88).clamp(0.0, 1.0));
    return [secondaryHsl.toColor(), activeColor];
  }
}
