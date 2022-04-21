import 'package:drivers/lifecycle.dart';

/// Service to show popups.
abstract class PopupsService implements Lifecycle {
  /// Show popup with to button - Yes and No
  /// Returns true if a user tap to Yes button.
  Future<bool> showYesNoPopup({
    required String title,
    String? descriptions,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
  });

  /// Show popup with one button - OK.
  Future<void> showOkPopup({
    required String title,
    String? descriptions,
    String? buttonTitle,
  });
}
