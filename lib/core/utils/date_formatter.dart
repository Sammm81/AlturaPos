import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy HH:mm').format(dateTime);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDateOnly(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return ' year(s) ago';
    } else if (difference.inDays > 30) {
      return ' month(s) ago';
    } else if (difference.inDays > 0) {
      return ' day(s) ago';
    } else if (difference.inHours > 0) {
      return ' hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return ' minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}
