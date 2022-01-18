import 'package:localized_string/localized_string.dart';

import 'exceptions.dart';

class AppError {
  final Object e;
  final StackTrace? stackTrace;

  const AppError(this.e, this.stackTrace);

  LocalizedString get title {
    if (e is LocalizeMessageException) {
      return (e as LocalizeMessageException).localizedMessage;
    } else {
      return LocalizedString.fromString('Unexpected error');
    }
  }

  LocalizedString? get description {
    if (e is LocalizeDescriptionException) {
      return (e as LocalizeDescriptionException).descriptionMessage;
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
