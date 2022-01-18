import 'config_spec.dart';

class ConfigAdapter {
  // NOTE(sysint64): This method is used to parse the value enetered by user in the debug screen.
  dynamic valueFromString(ConfigFieldSpec field, String? value) {
    if (value == null) {
      return field.defaultValue;
    }

    switch (field.type) {
      case String:
        return value;

      case int:
        return int.parse(value);

      case double:
        return double.parse(value);

      case bool:
        return value == 'true';

      default:
        throw StateError('Unsupported type: ${field.type}');
    }
  }
}
