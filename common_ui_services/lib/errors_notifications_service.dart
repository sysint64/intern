import 'package:drivers/lifecycle.dart';
import 'package:error_services/app_error.dart';

/// Service to show error notification.
abstract class ErrorsNotificationsService implements Lifecycle {
  /// Show error notification to a user. This notification should
  /// contain a button, tapping on opens error details information.
  void showError(AppErrorWithId error);
}
