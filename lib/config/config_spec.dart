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
}
