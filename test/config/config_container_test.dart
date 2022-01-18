import 'package:drivers/config/config_container.dart';
import 'package:drivers/config/config_spec.dart';
import 'package:flutter_test/flutter_test.dart';

class DemoConfigSpec implements ConfigSpec {
  @override
  Map<String, ConfigFieldSpec> get fields => const {
        'NAME': ConfigFieldSpec(
          type: String,
          name: 'Application name',
          defaultValue: 'My App',
        ),
        'DEBUG': ConfigFieldSpec(
          type: bool,
          name: 'Is debug enabled',
          defaultValue: false,
        ),
        'INT_VALUE': ConfigFieldSpec(
          type: int,
          name: 'int value',
          defaultValue: 12,
        ),
        'DOUBLE_VALUE': ConfigFieldSpec(
          type: double,
          name: 'double value',
          defaultValue: 34.0,
        ),
      };
}

void main() {
  final spec = DemoConfigSpec();

  test('ConfigContainer.fromJson valid', () async {
    final container = ConfigContainer.fromJson(
      <String, dynamic>{
        'NAME': 'Hello World!',
        'DEBUG': true,
      },
      spec,
    );

    expect(container.getValueByKey<String>('NAME'), 'Hello World!');
    expect(container.getValueByKey<bool>('DEBUG'), true);
  });

  test('ConfigContainer.fromJson wrong types', () async {
    final container = ConfigContainer.fromJson(
      <String, dynamic>{
        'NAME': true,
        'DEBUG': 'Hello World!',
      },
      spec,
    );

    expect(container.getValueByKey<String>('NAME'), 'My App');
    expect(container.getValueByKey<bool>('DEBUG'), false);
  });

  test('ConfigContainer.fromJson unknown keys', () async {
    final container = ConfigContainer.fromJson(
      <String, dynamic>{
        'NAME': 'Hello World!',
        'DEBUG': true,
        'SOME_UNKNOWN_KEY': 12,
      },
      spec,
    );

    expect(container.getValueByKey<String>('NAME'), 'Hello World!');
    expect(container.getValueByKey<bool>('DEBUG'), true);
  });

  test('ConfigContainer.defaultValues', () async {
    final container = ConfigContainer.empty(spec);
    expect(container.getValueByKey<String>('NAME'), 'My App');
    expect(container.getValueByKey<bool>('DEBUG'), false);
  });

  test('ConfigContainer.values', () async {
    final container = ConfigContainer.fromJson(
      <String, dynamic>{
        'NAME': 'Hello World!',
        'UNKNOWN_KEY': 12,
      },
      spec,
    );
    expect(container.values.toList().length, 4);
    expect(container.values.toList()[0].key, 'NAME');
    expect(container.values.toList()[0].value, 'Hello World!');
    expect(container.values.toList()[1].key, 'DEBUG');
    expect(container.values.toList()[1].value, false);
  });

  test('ConfigContainer.deserializeValueByKey', () async {
    final container = ConfigContainer.empty(spec);
    expect(container.deserializeValueByKey('NAME', 'Hello World!'), 'Hello World!');
    expect(container.deserializeValueByKey('DEBUG', 'true'), true);
    expect(container.deserializeValueByKey('DEBUG', 'false'), false);
    expect(container.deserializeValueByKey('DEBUG', 'hello'), false);
    expect(container.deserializeValueByKey('INT_VALUE', '124'), 124);
    expect(container.deserializeValueByKey('DOUBLE_VALUE', '124'), 124.0);
    expect(container.deserializeValueByKey('DOUBLE_VALUE', '124.44'), 124.44);
  });

  test('ConfigContainer.clear', () async {
    final container = ConfigContainer.fromJson(
      <String, dynamic>{
        'NAME': 'Hello World!',
        'INT_VALUE': 912,
        'DEBUG': true,
      },
      spec,
    );
    container.clear();
    expect(container.getValueByKey<String>('NAME'), 'My App');
    expect(container.getValueByKey<int>('INT_VALUE'), 12);
    expect(container.getValueByKey<bool>('DEBUG'), false);
  });
}
