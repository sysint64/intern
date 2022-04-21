import 'package:drivers/i18n.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

String truncateWithEllipsis(String str, int cutoff) {
  return (str.length <= cutoff) ? str : '${str.substring(0, cutoff)}...';
}

String formatSecondsToTime(int seconds) {
  final m = (seconds / 60).floor();
  final s = seconds - m * 60;

  String minutesFormatted;
  String secondsFormatted;

  if (m < 10) {
    minutesFormatted = '0$m';
  } else {
    minutesFormatted = m.toString();
  }

  if (s < 10) {
    secondsFormatted = '0$s';
  } else {
    secondsFormatted = s.toString();
  }

  return '$minutesFormatted:$secondsFormatted';
}

String formatPhoneNumber(String phone) {
  return FlutterLibphonenumber().formatNumberSync(phone);
}

extension StringExtension on String {
  String capitalize() {
    if (this == "") return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  I18nString i18n() => RawStringLocalizable(this);
}

String removeTrailingZerosAfterDecimal(String n) {
  final regex = RegExp(r'([.]*0+)(?!.*\d)');
  return n.replaceAll(regex, '');
  // return n;
}
