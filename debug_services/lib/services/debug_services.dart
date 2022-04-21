import 'package:config/config_spec.dart';

abstract class DebugServicesService {
  Future<AppConfigData> retrieveConfig();

  Future<void> updateConfigFromDescriptor(AppConfigDescriptor config);

  Future<void> updateConfigValueByKey(String key, String value);

  Future<void> enableFeature(String featureKey);

  Future<void> disableFeature(String featureKey);

  Future<void> restoreConfigToDefaults();
}
