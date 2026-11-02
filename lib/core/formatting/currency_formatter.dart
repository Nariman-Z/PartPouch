import 'package:intl/intl.dart';
import '../theme/theme_provider.dart';

/// Accurate financial and currency formatter working with integer minor units (cents).
/// Supports both native USD and dynamic real-time recalculated Iranian Toman valuation.
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format cents to currency string (respecting active currency and exchange rate).
  /// When [compact] is true, uses "K" or "M" for numbers >= 1,000.
  /// When [compact] is false (default), returns the exact unrounded financial valuation.
  static String formatCents(
    int? cents, {
    String? currencySymbol,
    bool compact = false,
  }) {
    if (cents == null) return '--';
    if (currencySymbol != null) {
      final double value = cents / 100.0;
      if (compact && value >= 1000) {
        final compactStr = ThemeProvider()
            .formatCompactAmount(value, isUsd: currencySymbol == '\$');
        return '$currencySymbol$compactStr';
      }
      final formatter = NumberFormat.currency(
        symbol: currencySymbol,
        decimalDigits: 2,
      );
      return formatter.format(value);
    }
    return ThemeProvider().formatCurrency(cents, compact: compact);
  }

  /// Format cents without symbol (e.g. 124800 cents -> "1,248.00")
  static String formatCentsAmount(int? cents) {
    if (cents == null) return '0.00';
    final double value = cents / 100.0;
    return NumberFormat('#,##0.00').format(value);
  }

  /// Returns a record (amount, unit) for multi-line display e.g. in charts
  /// e.g. ("133.3M", "Toman") or ("12.5K", "USD")
  static ({String amount, String unit}) formatCentsParts(
    int? cents, {
    bool compact = false,
  }) {
    if (cents == null) return (amount: '--', unit: '');
    final theme = ThemeProvider();
    final double usdAmount = cents / 100.0;

    if (theme.isToman) {
      if (!theme.hasExchangeRate) {
        return (amount: '--', unit: theme.isRtl ? 'تومان' : 'Toman');
      }
      final double tomanAmount = usdAmount * theme.usdToTomanRate;
      final String formattedToman = compact
          ? theme.formatCompactAmount(tomanAmount)
          : NumberFormat('#,##0').format(tomanAmount.round());
      return (
        amount: theme.isRtl ? theme.formatNumber(formattedToman) : formattedToman,
        unit: theme.isRtl ? 'تومان' : 'Toman',
      );
    } else {
      final String formattedUsd = compact
          ? theme.formatCompactAmount(usdAmount, isUsd: true)
          : NumberFormat('#,##0.00').format(usdAmount);
      return (
        amount: theme.isRtl ? theme.formatNumber(formattedUsd) : formattedUsd,
        unit: theme.isRtl ? '\$' : 'USD',
      );
    }
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
