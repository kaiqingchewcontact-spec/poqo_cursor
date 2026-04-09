import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String get friendlyDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (date == today.add(const Duration(days: 1))) return 'Tomorrow';

    if (now.difference(this).inDays < 7) {
      return DateFormat('EEEE').format(this);
    }

    if (year == now.year) {
      return DateFormat('MMM d').format(this);
    }

    return DateFormat('MMM d, y').format(this);
  }

  String get shortDate => DateFormat('MMM d').format(this);

  String get dayOfWeekShort => DateFormat('E').format(this);

  String get timeOnly => DateFormat('h:mm a').format(this);

  DateTime get dateOnly => DateTime(year, month, day);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  List<DateTime> get daysInWeek {
    final start = subtract(Duration(days: weekday - 1));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  List<DateTime> get last7Days {
    return List.generate(
      7,
      (i) => subtract(Duration(days: 6 - i)).dateOnly,
    );
  }

  List<DateTime> get last30Days {
    return List.generate(
      30,
      (i) => subtract(Duration(days: 29 - i)).dateOnly,
    );
  }
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }
  return '${minutes}m';
}
