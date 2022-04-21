import 'dart:convert';

import 'package:config/config_spec.dart';
import 'package:drivers/storages/hive_storages.dart';
import 'package:hive/hive.dart';

class ConfigStorageImpl extends StringHiveSingleStorage<AppConfigData> {
  final AppConfigDescriptor _defaultConfigDescriptor;
  final AppConfigDataStorageAdapter _configStorageAdapter;

  @override
  String get boxName => 'config';

  ConfigStorageImpl(this._defaultConfigDescriptor, this._configStorageAdapter);

  @override
  Future<bool> contains() => throw UnimplementedError();

  @override
  Future<void> writeData(Box<String> box, String prefix, AppConfigData data) async {
    await box.put('$prefix:config', _configStorageAdapter.configToStringJson(data));
    await box.put('$prefix:features', _configStorageAdapter.featuresToStringJson(data));
  }

  @override
  Future<AppConfigData> readData(Box<String> box, String prefix) async {
    final dynamic configJson = jsonDecode(box.get('$prefix:config', defaultValue: '{}')!);
    final dynamic featuresJson = jsonDecode(box.get('$prefix:features', defaultValue: '{}')!);
    final features = Map<String, dynamic>.from(featuresJson as Map<String, dynamic>);

    return _configStorageAdapter.createFromDescriptor(
      AppConfigDescriptor(
        config: configJson as Map<String, dynamic>,
        features: features.map((key, dynamic value) => MapEntry(key, value == true)),
      ),
      _defaultConfigDescriptor,
    );
  }

  @override
  Future<void> deleteData(Box<String> box, String prefix) async {
    await box.delete('$prefix:config');
    await box.delete('$prefix:features');
  }
}
