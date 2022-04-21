import 'package:loggy/loggy.dart';

abstract class Log {
  // static final _logger = Logger();
  static Future<void> init() async {
    Loggy.initLoggy();
  }

  static void debug(String tag, dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logDebug('[${tag.toUpperCase()}] $message', error, stackTrace);
  }

  static void info(String tag, dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logInfo('[${tag.toUpperCase()}] $message', error, stackTrace);
  }

  static void warning(String tag, dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logWarning('[${tag.toUpperCase()}] $message', error, stackTrace);
  }

  static void error(String tag, dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logError(error);
    logError('[${tag.toUpperCase()}] $message', error, stackTrace);
  }

  static void trace(String tag, dynamic message, [dynamic error, StackTrace? stackTrace]) {
    // print('[${tag.toUpperCase()}}] $message', error, stackTrace);
  }
}
