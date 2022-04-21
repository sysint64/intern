import 'package:debug_services/pages/debug_service_page.dart';
import 'package:debug_services/pages/update_config_value_page.dart';
import 'package:drivers/i18n.dart';
import 'package:drivers/router/configuration.dart';
import 'package:drivers/router/path.dart';
import 'package:drivers/validators/validators.dart';
import 'package:flutter/material.dart';

abstract class DebugServicesRouteScopeLifecycle {}

class DebugServicesPathConfiguration extends RouterPathConfiguration<void>
    implements DebugServicesRouteScopeLifecycle {
  DebugServicesPathConfiguration();

  DebugServicesPathConfiguration.parse(PathReader pathReader) {
    PathConfigurationParser.parse(pathReader, location, queryParameters);
  }

  @override
  Iterable<PathSegmentDescriptor> get location => [PathStrConst('debug_services')];

  @override
  dynamic normalizeResult(dynamic result) => null;

  static Iterable<RouterPathConfiguration> config(PathReader pathReader) {
    return RouterPathFactory.category(
      pathReader,
      home: DebugServicesPathConfiguration.parse(pathReader),
      children: [
        UpdateConfigValuePathConfiguration.config,
      ],
    );
  }

  @override
  Iterable<Page<dynamic>> generatePages(String pathId) {
    return [
      MaterialPage<void>(
        child: const DebugServicesPageProvider(),
        key: ValueKey(pathId),
      ),
    ];
  }
}

class UpdateConfigValuePathConfiguration extends RouterPathConfiguration<bool>
    implements DebugServicesRouteScopeLifecycle {
  final env = PathParameter<String>(
    StringNotEmptyValidator(const RawI18nString('env cannot be empty')),
  );
  final value = QueryParameter<String?>(
    'value',
    NullableStringNotEmptyValidator(const RawI18nString('value cannot be empty')),
  );

  UpdateConfigValuePathConfiguration(String env, String? value) {
    this.env.value = env;
    this.value.value = value;
  }

  UpdateConfigValuePathConfiguration.parse(PathReader pathReader) {
    PathConfigurationParser.parse(pathReader, location, queryParameters);
  }

  // config/<env:string>/update
  @override
  Iterable<PathSegmentDescriptor> get location =>
      [PathStrConst('config'), env, PathStrConst('update'), PathDeadEnd()];

  // ?value=<value:string>
  @override
  Iterable<PathQueryDescriptor> get queryParameters => [value];

  @override
  bool normalizeResult(dynamic result) => result == true;

  static Iterable<RouterPathConfiguration> config(PathReader pathReader) {
    return [UpdateConfigValuePathConfiguration.parse(pathReader)];
  }

  @override
  Iterable<Page<dynamic>> generatePages(String pathId) {
    return [
      MaterialPage<void>(
        child: UpdateConfigValuePageProvider(env.value),
        key: ValueKey(pathId),
      ),
    ];
  }
}
