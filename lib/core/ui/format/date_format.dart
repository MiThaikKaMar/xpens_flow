import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final timeFormat = DateFormat('h:mma'); // 2:34AM format

  if (dateToCheck == today) {
    return 'Today, ${timeFormat.format(dateTime)}';
  } else if (dateToCheck == yesterday) {
    return 'Yesterday, ${timeFormat.format(dateTime)}';
  } else if (now.difference(dateTime).inDays < 7) {
    // Within the last week, show day name
    return '${DateFormat('EEEE').format(dateTime)}, ${timeFormat.format(dateTime)}';
  } else {
    // Older dates, show full date
    return DateFormat('MMM d, h:mma').format(dateTime);
  }
}

String formatDateForListItem(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final timeFormat = DateFormat('h:mma'); // 2:34AM format

  if (dateToCheck == today) {
    return 'Today, ${timeFormat.format(dateTime)}';
  } else if (dateToCheck == yesterday) {
    return 'Yesterday';
  } else if (now.difference(dateTime).inDays < 7) {
    // Within the last week, show day name
    return DateFormat('EEEE').format(dateTime);
  } else {
    // Older dates, show full date
    return DateFormat('MMM d').format(dateTime);
  }
}

String formatMonthHeader(DateTime dateTime) {
  // Formats like "December 2024"
  return DateFormat('MMMM yyyy').format(dateTime);
}
