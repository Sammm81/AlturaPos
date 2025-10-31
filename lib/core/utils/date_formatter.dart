import 'package:intl/intl.dart';

/// Date and time formatting utilities
class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy HH:mm');
  static final DateFormat _shortDateFormat = DateFormat('dd/MM/yy');
  static final DateFormat _longDateFormat = DateFormat('EEEE, dd MMMM yyyy');
  static final DateFormat _receiptDateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  static final DateFormat _orderNumberFormat = DateFormat('yyyyMMdd');
  static final DateFormat _hourFormat = DateFormat('HH:00');

  /// Format date to 'dd MMM yyyy' (e.g., '31 Oct 2025')
  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// Format time to 'HH:mm' (e.g., '14:30')
  static String formatTime(DateTime date) => _timeFormat.format(date);

  /// Format date and time to 'dd MMM yyyy HH:mm' (e.g., '31 Oct 2025 14:30')
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  /// Format date to 'dd/MM/yy' (e.g., '31/10/25')
  static String formatShortDate(DateTime date) => _shortDateFormat.format(date);

  /// Format date to 'EEEE, dd MMMM yyyy' (e.g., 'Friday, 31 October 2025')
  static String formatLongDate(DateTime date) => _longDateFormat.format(date);

  /// Format date for receipt printing
  static String formatReceiptDate(DateTime date) => 
      _receiptDateFormat.format(date);

  /// Format date for order number generation (e.g., '20251031')
  static String formatOrderNumberDate(DateTime date) =>
      _orderNumberFormat.format(date);

  /// Format hour for analytics (e.g., '14:00')
  static String formatHour(DateTime date) => _hourFormat.format(date);

  /// Get relative time (e.g., 'Just now', '5 minutes ago', '2 hours ago')
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return formatDate(date);
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Get end of day
  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final weekday = date.weekday;
    return startOfDay(date.subtract(Duration(days: weekday - 1)));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  /// Get end of month
  static DateTime endOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
}
