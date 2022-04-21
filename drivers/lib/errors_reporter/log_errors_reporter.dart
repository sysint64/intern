import 'package:drivers/log.dart';

import 'errors_reporter.dart';

class LogErrorsReporter implements ErrorsReporter {
  @override
  Future<void> reportError(Object e, [StackTrace? st]) async {
    Log.error('error reporter', 'Report error', e, st);
  }
}
