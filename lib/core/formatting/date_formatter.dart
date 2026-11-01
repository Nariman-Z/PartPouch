import 'package:intl/intl.dart';

/// Formatter for dates and timestamps
class DateFormatter {
  DateFormatter._();

  static final DateFormat _shortDate = DateFormat('MMM d, yyyy');
  static final DateFormat _dateTime = DateFormat('MMM d, yyyy HH:mm');

  static String formatDate(DateTime date) => _shortDate.format(date);
  static String formatDateTime(DateTime date) => _dateTime.format(date);

  /// Friendly relative time: "just now", "5m ago", "3h ago", "2d ago", or date
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return _shortDate.format(date);
    }
  }
}
