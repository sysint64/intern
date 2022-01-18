import 'dart:convert';

import 'package:drivers/log.dart';

import 'config_adapter.dart';
import 'config_spec.dart';

class ConfigContainer {
  final Map<String, dynamic> _values;
  final ConfigSpec spec;
  final adapter = ConfigAdapter();

  ConfigContainer._fromValues(this._values, this.spec);

  static ConfigContainer fromJson(Map<String, dynamic> values, ConfigSpec spec) {
    final config = ConfigContainer.empty(spec);

    for (final key in values.keys) {
      if (!spec.fields.containsKey(key)) {
        log('config', 'Unknown key: $key');
        continue;
      }

      config.setValueByKey(key, values[key]);
    }

    return config;
  }

  factory ConfigContainer.empty(ConfigSpec spec) =>
      ConfigContainer._fromValues(<String, dynamic>{}, spec);

  String toJson() => jsonEncode(_values);

  Iterable<MapEntry<String, dynamic>> get values sync* {
    for (final key in spec.fields.keys) {
      yield MapEntry<String, dynamic>(key, getValueByKey<dynamic>(key));
    }
  }

  T getValueByKey<T>(String key) {
    try {
      return _values[key] as T? ?? spec.fields[key]!.defaultValue as T;
    } catch (e, stackTrace) {
      logError('config', 'Error occured', e: e, st: stackTrace);
      return spec.fields[key]!.defaultValue as T;
    }
  }

  // ignore: avoid_annotating_with_dynamic
  void setValueByKey(String key, dynamic value) {
    if (value.runtimeType == spec.fields[key]!.type) {
      _values[key] = value;
    } else {
      log(
        'config',
        'Validation failed: ${value.runtimeType} != ${spec.fields[key]!.type}',
      );
    }
  }

  dynamic deserializeValueByKey(String key, String value) {
    return adapter.valueFromString(spec.fields[key]!, value);
  }

  void clear() => _values.clear();
}
