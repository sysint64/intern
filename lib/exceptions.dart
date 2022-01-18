import 'package:dio/dio.dart';
import 'package:drivers/api/status_code.dart';
import 'package:localized_string/localized_string.dart';

class SchemeConsistencyException implements Exception {
  final String? message;

  SchemeConsistencyException([this.message]);

  @override
  String toString() {
    if (message == null) {
      return '$SchemeConsistencyException';
    }
    return '$SchemeConsistencyException: $message';
  }
}

abstract class DiagnosticMessageException implements Exception {
  String get diagnosticMessage;
}

abstract class LocalizeMessageException implements Exception {
  LocalizedString get localizedMessage;
}

abstract class LocalizeDescriptionException implements Exception {
  LocalizedString? get descriptionMessage;
}

abstract class LogicException extends LocalizeMessageException {}

// ignore: avoid_positional_boolean_parameters
void require(bool invariant, Exception Function() exceptionFactory) {
  if (!invariant) {
    throw exceptionFactory();
  }
}

class CanceledException implements LogicException {
  @override
  LocalizedString get localizedMessage => LocalizedString.fromString('Cancelled');
}

class ApiException implements Exception, DiagnosticMessageException {
  final StatusCode? statusCode;
  final Object? body;
  final Headers? headers;

  ApiException({this.statusCode, this.body, this.headers});

  @override
  String get diagnosticMessage => 'Status code: $statusCode\nBody: $body';
}

abstract class NetworkException implements Exception {}

class ConnectionException implements NetworkException {}

class NoInternetException implements NetworkException {}

class ValidationException implements LogicException, LocalizeDescriptionException {
  @override
  final LocalizedString localizedMessage;
  @override
  final LocalizedString? descriptionMessage;

  ValidationException(this.localizedMessage, {this.descriptionMessage});

  ValidationException.string(String message)
      : localizedMessage = LocalizedString.fromString(message),
        descriptionMessage = null;
}
