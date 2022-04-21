import 'package:config/config_spec.dart';

abstract class DebugAppService {
  Future<void> setupConfig(ConfigSpec config, ConfigSpec features);

  Future<ConfigSpec> getCurrentConfig();

  Future<ConfigSpec> getCurrentFeatures();

  Future<void> resetApplicationState();
}
