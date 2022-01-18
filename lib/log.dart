import 'package:drivers/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:ansicolor/ansicolor.dart';

void log(String tag, dynamic message, {bool highlight = false}) {
  if (!kDebugMode) {
    return;
  }

  final tagPen = AnsiPen();
  final textPen = AnsiPen();

  if (highlight) {
    tagPen.magenta(bold: true);
    textPen.magenta();
  } else {
    tagPen.yellow(bold: true);
    textPen.yellow();
  }

  final logEntry = tagPen('[${tag.toUpperCase()}:${DateTime.now()}]') +
      textPen(' ${truncateWithEllipsis(message.toString(), 1000)}');

  debugPrint(logEntry);
}

void logError(
  String tag,
  String data, {
  dynamic e,
  StackTrace? st,
  String? traceparent,
}) {
  if (!kDebugMode) {
    return;
  }

  if (traceparent != null) data = '<$traceparent> $data';

  final tagPen = AnsiPen()..red(bold: true);
  final textPen = AnsiPen()..red();

  final logEntry =
      tagPen('[${tag.toUpperCase()}]') + textPen(' ${truncateWithEllipsis(data.toString(), 1000)}');
  tag = tag.toUpperCase();

  debugPrint(logEntry);

  if (e != null) {
    debugPrint(tagPen('[$tag:${DateTime.now()}]') + textPen(' $e'));
  }

  if (st != null) {
    debugPrint(tagPen('[$tag: STACK TRACE]'));
    debugPrint(st.toString());
  }
}
