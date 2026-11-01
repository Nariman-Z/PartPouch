import 'package:intl/intl.dart';
import '../theme/theme_provider.dart';

/// Accurate financial and currency formatter working with integer minor units (cents).
/// Supports both native USD and dynamic real-time recalculated Iranian Toman valuation.
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format cents to currency string (respecting active currency and exchange rate)
  static String formatCents(int? cents, {String? currencySymbol}) {
    if (cents == null) return '--';
    if (currencySymbol != null) {
      final double value = cents / 100.0;
      final formatter = NumberFormat.currency(
        symbol: currencySymbol,
        decimalDigits: 2,
      );
      return formatter.format(value);
    }
    return ThemeProvider().formatCurrency(cents);
  }

  /// Format cents without symbol (e.g. 124800 cents -> "1,248.00")
  static String formatCentsAmount(int? cents) {
    if (cents == null) return '0.00';
    final double value = cents / 100.0;
    return NumberFormat('#,##0.00').format(value);
  }

  /// Parse user input string e.g. "12.50" or "$12.50" to integer cents (1250)
  static int? parseToCents(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d.]'), '');
    if (cleaned.isEmpty) return null;
    final value = double.tryParse(cleaned);
    if (value == null) return null;
    return (value * 100).round();
  }
}
