import 'dart:convert';

import 'package:config/config_spec.dart';
import 'package:drivers/log.dart';

class ConfigContainer {
  final Map<String, dynamic> _values;
  final ConfigSpec spec;

  ConfigContainer._fromValues(this._values, this.spec);

  static ConfigContainer fromJson(Map<String, dynamic> values, ConfigSpec spec) {
    final config = ConfigContainer.empty(spec);

    for (final key in values.keys) {
      if (!spec.fields.containsKey(key)) {
        Log.warning('config', 'Unknown key: $key');
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
      Log.error('config', 'Error occured', e, stackTrace);
      return spec.fields[key]!.defaultValue as T;
    }
  }

  // ignore: avoid_annotating_with_dynamic
  void setValueByKey(String key, dynamic value) {
    if (value.runtimeType == spec.fields[key]!.type) {
      _values[key] = value;
    } else {
      Log.warning(
        'config',
        'Validation failed: ${value.runtimeType} != ${spec.fields[key]!.type}',
      );
    }
  }

  void clear() => _values.clear();
}
