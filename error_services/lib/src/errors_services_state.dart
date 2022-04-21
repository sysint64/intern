import 'package:error_services/app_error.dart';

class ErrorsServicesState {
  static const kMaxErrors = 20;

  int lastErrorId = 0;
  final lastErrors = <AppErrorWithId>[];
}
