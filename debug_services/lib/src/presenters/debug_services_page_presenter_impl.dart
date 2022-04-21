import 'dart:io';

import 'package:config/config_spec.dart';
import 'package:debug_services/models.dart';
import 'package:debug_services/presenters/debug_services_page_presenter.dart';
import 'package:debug_services/services/app_debug_services.dart';
import 'package:debug_services/services/debug_services.dart';
import 'package:debug_services/src/debug_services_state.dart';
import 'package:drivers/log.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DebugServicesPagePresenterImpl implements DebugServicesPagePresenter {
  final DebugAppService _debugAppServices;
  final DebugServicesService _debugService;
  final DebugServicesState _debugServicesState;

  DebugServicesPagePresenterImpl(
    this._debugAppServices,
    this._debugService,
    this._debugServicesState,
  );

  @override
  void disposeLifecycle() {}

  @override
  void initLifecycle() {}

  @override
  Future<void> restoreConfigToDefaults() async {
    await _debugService.restoreConfigToDefaults();
    _debugServicesState.updated = true;
  }

  @override
  Future<bool> isConfigUpdated() async {
    return _debugServicesState.updated;
  }

  @override
  Future<DebugInfo> getData() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final config = await _debugAppServices.getCurrentConfig();
    final features = await _debugAppServices.getCurrentFeatures();

    return DebugInfo(
      version: packageInfo.version,
      packageName: packageInfo.packageName,
      buildNumber: packageInfo.buildNumber,
      os: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      config: config,
      features: features,
    );
  }

  @override
  Future<void> updateConfigByDescriptor(AppConfigDescriptor config) async {
    await _debugService.updateConfigFromDescriptor(config);
    _debugServicesState.updated = true;
  }

  @override
  Future<void> updateFeatureValue(String key, bool value) async {
    Log.info('config', 'update feature value: $value');
    _debugServicesState.updated = true;

    if (value) {
      await _debugService.enableFeature(key);
    } else {
      await _debugService.disableFeature(key);
    }
  }

  @override
  Future<void> resetApplicationState() async {
    await _debugAppServices.resetApplicationState();
  }
}
