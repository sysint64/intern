import 'package:intl/intl.dart';

DateTime convertDateFromTimeStamp(int timestamp) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  final date = DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    dateTime.hour,
    dateTime.minute,
    dateTime.second,
  );

  return date;
}

String formatDateTimeToYMMMMd(DateTime dateTime) {
  return DateFormat.yMMMMd().format(dateTime);
}

String formatDateTimeToYMMMMdHms(DateTime dateTime) {
  return DateFormat('d MMMM y, HH:mm:ss').format(dateTime);
}
