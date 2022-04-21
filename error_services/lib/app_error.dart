// ignore_for_file: public_member_api_docs

import 'package:drivers/exceptions.dart';
import 'package:drivers/i18n.dart';
import 'package:equatable/equatable.dart';

class AppErrorId extends Equatable {
  final int value;

  const AppErrorId(this.value);

  @override
  List<Object?> get props => [value];
}

class AppErrorWithId {
  final AppErrorId id;
  final AppError data;

  const AppErrorWithId(this.id, this.data);
}

/// App error contains additional method to form error report.
class AppError {
  final Object? exception;
  final StackTrace? stackTrace;

  AppError(this.exception, this.stackTrace);

  @override
  String toString() {
    return exception.toString();
  }

  I18nString? getLocalizedDescription() {
    if (exception is LocalizeDescriptionException) {
      return (exception as LocalizeDescriptionException).description;
    } else {
      return null;
    }
  }

  I18nString getLocalizedTitle() {
    if (exception is LogicException) {
      return (exception as LogicException).message;
    } else if (exception is String) {
      return RawI18nString(exception.toString());
    } else {
      return const RawI18nString('Unexpected error');
    }
  }

  String getReport() {
    if (exception is String) {
      return exception as String;
    } else {
      if (exception is DiagnosticMessageException) {
        final diagnosticMessage = (exception as DiagnosticMessageException).diagnosticMessage;

        return 'ERROR: ${exception.runtimeType}\n\n'
            'DIAGNOSTIC:\n'
            '$diagnosticMessage';
      } else {
        return 'ERROR: ${exception.runtimeType}\n'
            '$exception\n';
      }
    }
  }

  String getReportWithStackTrace() {
    if (stackTrace != null) {
      return '${getReport()}\n\n'
          'STACK TRACE\n\n'
          '$stackTrace';
    } else {
      return getReport();
    }
  }
}
