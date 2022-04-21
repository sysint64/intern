import 'package:drivers/lifecycle.dart';
import 'package:drivers/i18n.dart';

/// UI Service to show toast notifications.
abstract class UINotificationsService implements Lifecycle {
  /// Show toast notification with a given i18n [message].
  void showLocalized(I18nString message);

  /// Show toast notification with a given [message].
  void show(String message);
}
