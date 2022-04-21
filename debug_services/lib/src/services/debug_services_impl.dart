import 'package:config/config_spec.dart';
import 'package:debug_services/config_adapter.dart';
import 'package:debug_services/services/app_debug_services.dart';
import 'package:debug_services/services/debug_services.dart';
import 'package:drivers/log.dart';
import 'package:drivers/storages/storages.dart';

class DebugServicesServiceImpl implements DebugServicesService {
  final DebugServicesConfigAdapter _configAdapter;
  final DebugAppService _debugAppService;
  final AppConfigDataStorageAdapter _configDataStorageAdapter;
  final SingleStorage<AppConfigData> _configStorage;
  final AppConfigDescriptor _defaultConfigDescriptor;

  DebugServicesServiceImpl(
    this._configAdapter,
    this._debugAppService,
    this._configDataStorageAdapter,
    this._configStorage,
    this._defaultConfigDescriptor,
  );

  @override
  Future<AppConfigData> retrieveConfig() async {
    try {
      final config = await _configStorage.read();
      await _debugAppService.setupConfig(config.config, config.features);
      return config;
    } catch (e, stackTrace) {
      Log.error('debug services', 'Failed to retrieve config, use default', e, stackTrace);
      final config = _configDataStorageAdapter.createFromDescriptor(
        _defaultConfigDescriptor,
        _defaultConfigDescriptor,
      );
      await _configStorage.write(config);
      await _debugAppService.setupConfig(config.config, config.features);
      return config;
    }
  }

  @override
  Future<void> updateConfigFromDescriptor(AppConfigDescriptor descriptor) async {
    final config = _configDataStorageAdapter.createFromDescriptor(
      descriptor,
      _defaultConfigDescriptor,
    );
    await _configStorage.write(config);
    await _debugAppService.setupConfig(config.config, config.features);
  }

  @override
  Future<void> updateConfigValueByKey(String key, String value) async {
    final config = await _configStorage.read();

    final field = config.config.container.spec.fields[key]!;
    final dynamic deserializedValue = _configAdapter.valueFromString(field, value);

    config.config.container.setValueByKey(key, deserializedValue);
    await _configStorage.write(config);
    await _debugAppService.setupConfig(config.config, config.features);
  }

  @override
  Future<void> disableFeature(String featureKey) async {
    final config = await _configStorage.read();
    config.features.container.setValueByKey(featureKey, false);
    await _configStorage.write(config);
    await _debugAppService.setupConfig(config.config, config.features);
  }

  @override
  Future<void> enableFeature(String featureKey) async {
    final config = await _configStorage.read();
    config.features.container.setValueByKey(featureKey, true);
    await _configStorage.write(config);
    await _debugAppService.setupConfig(config.config, config.features);
  }

  @override
  Future<void> restoreConfigToDefaults() async {
    final config = _configDataStorageAdapter.createFromDescriptor(
      _defaultConfigDescriptor,
      _defaultConfigDescriptor,
    );
    await _configStorage.write(config);
    await _debugAppService.setupConfig(config.config, config.features);
  }
}
