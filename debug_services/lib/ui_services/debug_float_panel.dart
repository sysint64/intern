import 'package:drivers/lifecycle.dart';

abstract class DebugFloatPanelService implements Lifecycle {
  // ignore: avoid_positional_boolean_parameters
  Future<void> setEnabled(bool isEnabled);

  /// Show debug panel over a screen.
  Future<void> showDebugPanel();

  /// Hide debug panel over a screen.
  Future<void> hideDebugPanel();
}
