import 'package:drivers/lifecycle.dart';
import 'package:drivers/i18n.dart';

/// Service that provides methods to copy text into clipboard.
abstract class CopyService implements Lifecycle {
  /// Copy a given text into clipboard.
  Future<void> copy(String text);

  /// Copy a given i18n text into clipboard.
  Future<void> copyI18nString(I18nString text);
}
