import 'package:intl/intl.dart';

/// Formatters for various data types
class Formatters {
  Formatters._();

  /// Format currency
  /// Example: 10000.00 -> "Rp 10,000.00"
  static String currency(double amount, {String symbol = 'Rp'}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format currency without decimals
  /// Example: 10000.00 -> "Rp 10,000"
  static String currencyCompact(double amount, {String symbol = 'Rp'}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format number
  /// Example: 1000 -> "1,000"
  static String number(num value) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(value);
  }

  /// Format percentage
  /// Example: 0.15 -> "15%"
  static String percentage(double value) {
    final formatter = NumberFormat.percentPattern('id_ID');
    return formatter.format(value);
  }

  /// Format date
  /// Example: DateTime -> "25 Jan 2024"
  static String date(DateTime dateTime, {String pattern = 'dd MMM yyyy'}) {
    final formatter = DateFormat(pattern, 'id_ID');
    return formatter.format(dateTime);
  }

  /// Format time
  /// Example: DateTime -> "14:30"
  static String time(DateTime dateTime, {String pattern = 'HH:mm'}) {
    final formatter = DateFormat(pattern, 'id_ID');
    return formatter.format(dateTime);
  }

  /// Format date and time
  /// Example: DateTime -> "25 Jan 2024, 14:30"
  static String dateTime(DateTime dateTime,
      {String pattern = 'dd MMM yyyy, HH:mm'}) {
    final formatter = DateFormat(pattern, 'id_ID');
    return formatter.format(dateTime);
  }

  /// Format date and time with seconds
  /// Example: DateTime -> "25 Jan 2024, 14:30:15"
  static String dateTimeWithSeconds(DateTime dateTime,
      {String pattern = 'dd MMM yyyy, HH:mm:ss'}) {
    final formatter = DateFormat(pattern, 'id_ID');
    return formatter.format(dateTime);
  }

  /// Format relative time
  /// Example: DateTime -> "2 hours ago"
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format phone number
  /// Example: "081234567890" -> "+62 812-3456-7890"
  static String phoneNumber(String phone) {
    if (phone.isEmpty) return phone;
    
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    
    if (digits.startsWith('0')) {
      // Convert 08xx to +628xx
      final formatted = '+62${digits.substring(1)}';
      return _formatIndonesianPhone(formatted);
    } else if (digits.startsWith('62')) {
      return _formatIndonesianPhone('+$digits');
    }
    
    return phone;
  }

  static String _formatIndonesianPhone(String phone) {
    // Format: +62 8xx-xxxx-xxxx
    if (phone.length >= 13) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 6)}-${phone.substring(6, 10)}-${phone.substring(10)}';
    }
    return phone;
  }

  /// Format file size
  /// Example: 1024 -> "1.00 KB"
  static String fileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// Capitalize first letter
  /// Example: "hello world" -> "Hello world"
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Title case
  /// Example: "hello world" -> "Hello World"
  static String titleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) => word.isEmpty ? word : capitalize(word))
        .join(' ');
  }

  /// Truncate text with ellipsis
  /// Example: "Hello World" -> "Hello..."
  static String truncate(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
}
