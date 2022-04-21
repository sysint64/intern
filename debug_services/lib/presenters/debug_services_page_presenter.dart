import 'package:config/config_spec.dart';
import 'package:debug_services/models.dart';
import 'package:drivers/lifecycle.dart';

abstract class DebugServicesPagePresenter implements Lifecycle {
  Future<bool> isConfigUpdated();

  Future<DebugInfo> getData();

  Future<void> updateConfigByDescriptor(AppConfigDescriptor config);

  Future<void> restoreConfigToDefaults();

  // ignore: avoid_positional_boolean_parameters
  Future<void> updateFeatureValue(String key, bool value);

  Future<void> resetApplicationState();
}
