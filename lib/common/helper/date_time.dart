import 'package:intl/intl.dart';

bool isDateTimeBetween(DateTime? target, String? start, String? end) {
  if (target != null && start != null && end != null) {
    if (target == parseStringToDateTime(start)) {
      return false;
    } else {
      return target.isAfter(parseStringToDateTime(start)) &&
          target.isBefore(parseStringToDateTime(end));
    }
  }
  return true;
}

DateTime parseStringToDateTime(String formatTime) {
  return DateFormat('d MMM y h:mm a').parse(formatTime);
}

String parseDateTimeToString(DateTime date) {
  return DateFormat('d MMM y h:mm a').format(date);
}

(String, String) parseStringDateTimeToDateTime(String dateSTR) {
  DateTime dateTime = DateFormat('d MMM y h:mm a').parse(dateSTR);

  final String time = DateFormat("h:mm a").format(dateTime);
  final String date = DateFormat("d MMM y").format(dateTime);

  return (date, time);
}
