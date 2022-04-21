import 'package:config/config_spec.dart';
import 'package:config/storages/config.dart';
import 'package:drivers/dependencies.dart';
import 'package:drivers/storages/storages.dart';

class ConfigModule {
  final SingleStorage<AppConfigData> configDataStorage;
  final AppConfigDataStorageAdapter configDataStorageAdapter;
  final AppConfigDescriptor defaultConfigDescriptor;

  ConfigModule({
    required this.configDataStorage,
    required this.configDataStorageAdapter,
    required this.defaultConfigDescriptor,
  });

  static Future<ConfigModule> bootstrap(
    AppConfigDescriptor defaultConfig,
    AppConfigDataStorageAdapter configDataStorageAdapter,
  ) async {
    final module = ConfigModule(
      configDataStorage: ConfigStorageImpl(
        defaultConfig,
        configDataStorageAdapter,
      ),
      configDataStorageAdapter: configDataStorageAdapter,
      defaultConfigDescriptor: defaultConfig,
    );
    module.registerDependencies();
    return module;
  }

  void registerDependencies() {
    registerSingletonDependency<SingleStorage<AppConfigData>>(configDataStorage);
  }
}
