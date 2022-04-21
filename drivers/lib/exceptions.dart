import 'package:drivers/api/status_code.dart';
import 'package:drivers/i18n.dart';
import 'package:drivers/strings.dart';

abstract class DiagnosticMessageException implements Exception {
  String get diagnosticMessage;
}

abstract class LocalizeMessageException implements Exception {
  I18nString get message;
}

abstract class LocalizeDescriptionException implements Exception {
  I18nString? get description;
}

abstract class LogicException extends LocalizeMessageException {}

// ignore: avoid_positional_boolean_parameters
void require(bool invariant, Exception Function() exceptionFactory) {
  if (!invariant) {
    throw exceptionFactory();
  }
}

class CanceledException implements Exception {}

class HttpData {
  final String? path;
  final StatusCode? statusCode;
  final Object? request;
  final Object? response;
  final Object? cause;

  HttpData({
    this.path,
    this.statusCode,
    this.request,
    this.response,
    this.cause,
  });

  @override
  String toString() => 'Path: $path\n'
      'Status code: $statusCode\n\n'
      'Request:\n$request\n\n'
      'Response:\n$response\n\n'
      'Cause:\n$cause\n';
}

class ApiException implements Exception, DiagnosticMessageException {
  final HttpData httpData;

  ApiException({required this.httpData});

  @override
  String get diagnosticMessage => httpData.toString();
}

abstract class NetworkException implements Exception {}

class ConnectionException implements NetworkException {}

class NoInternetException implements NetworkException {}

class ValidationException implements LogicException, LocalizeDescriptionException {
  @override
  final I18nString message;
  @override
  final I18nString? description;

  ValidationException(this.message, {this.description});

  ValidationException.string(String message)
      : message = message.i18n(),
        description = null;

  @override
  String toString() {
    if (description != null) {
      return '$message ($description)';
    } else {
      return message.toString();
    }
  }
}
