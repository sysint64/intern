import 'package:drivers/exceptions.dart';
import 'package:drivers/i18n.dart';
import 'package:drivers/strings.dart';
import 'package:error_services/app_error.dart';

/// Services to register errors and get errors information.
abstract class ErrorsService {
  /// Register error. As a result get AppError that can form error report
  /// and registere error id.
  Future<AppErrorWithId> registerError(Object error, StackTrace stackTrace);

  /// Get detailed information about an error by a given [id].
  Future<AppError> getErrorById(AppErrorId id);
}

class ErrorNotFoundException extends LogicException {
  @override
  I18nString get message => 'Error not found'.i18n();
}
