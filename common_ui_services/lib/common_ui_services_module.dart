/// Module contains interfaces of most common UI services.

library common_ui_services;

import 'package:drivers/dependencies.dart';
import 'package:error_services/app_error.dart';
import 'package:flutter/material.dart';

class CommonUIServicesModuleConfig {
  void Function(BuildContext context, AppErrorWithId error)? openErrorDetails;

  CommonUIServicesModuleConfig({
    this.openErrorDetails,
  });
}

class CommonUIServicesModule {
  final CommonUIServicesModuleConfig config;

  CommonUIServicesModule({
    required this.config,
  });

  static Future<CommonUIServicesModule> bootstrap(CommonUIServicesModuleConfig config) async {
    final module = CommonUIServicesModule(
      config: config,
    );
    module.registerDependencies();
    return module;
  }

  void registerDependencies() {
    registerSingletonDependency(config);
  }
}
