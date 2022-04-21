import 'package:config/config_container.dart';

class ConfigFieldSpec {
  final Type type;
  final String name;
  final dynamic defaultValue;

  const ConfigFieldSpec({
    required this.type,
    required this.name,
    this.defaultValue,
  });

  ConfigFieldSpec copyWith({
    Type? type,
    String? name,
    // ignore: avoid_annotating_with_dynamic
    dynamic defaultValue,
  }) =>
      ConfigFieldSpec(
        type: type ?? this.type,
        name: name ?? this.name,
        defaultValue: defaultValue ?? this.defaultValue,
      );
}

abstract class ConfigSpec {
  Map<String, ConfigFieldSpec> get fields;

  ConfigContainer get container;
}

class AppConfigDescriptor {
  final Map<String, dynamic> config;
  final Map<String, bool> features;

  const AppConfigDescriptor({required this.config, required this.features});
}

class AppConfigData {
  final ConfigSpec config;
  final ConfigSpec features;

  const AppConfigData(this.config, this.features);
}

abstract class AppConfigDataStorageAdapter {
  String configToStringJson(AppConfigData data);

  String featuresToStringJson(AppConfigData data);

  AppConfigData createFromDescriptor(
    AppConfigDescriptor descriptor,
    AppConfigDescriptor defaults,
  );
}
