import 'package:drivers/i18n.dart';
import 'package:drivers/strings.dart';

import 'exceptions.dart';

class AppError {
  const AppError(this.e, this.stackTrace);

  final Object e;
  final StackTrace? stackTrace;

  I18nString get title {
    if (e is LocalizeMessageException) {
      return (e as LocalizeMessageException).message;
    } else {
      return 'Unexpected error'.i18n();
    }
  }

  I18nString? get description {
    if (e is LocalizeDescriptionException) {
      return (e as LocalizeDescriptionException).description;
    } else {
      return null;
    }
  }

  String getReport() {
    if (e is String) {
      return '$e';
    } else {
      if (e is DiagnosticMessageException) {
        final diagnosticMessage = (e as DiagnosticMessageException).diagnosticMessage;
        final message = title.toString();

        return 'MESSAGE: $message\n'
            'ERROR: ${e.runtimeType}\n\n'
            'DIAGNOSTIC:\n'
            '$diagnosticMessage';
      } else {
        return 'ERROR: ${e.runtimeType}\n'
            '$e\n';
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
