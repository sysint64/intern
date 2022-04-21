import 'package:debug_services/presenters/update_config_value_page_presenter.dart';
import 'package:debug_services/services/app_debug_services.dart';
import 'package:debug_services/services/debug_services.dart';
import 'package:debug_services/src/debug_services_state.dart';

class UpdateConfigValuePagePresenterImpl implements UpdateConfigValuePagePresenter {
  final DebugAppService _debugAppServices;
  final DebugServicesService _debugService;
  final DebugServicesState _debugServicesState;

  UpdateConfigValuePagePresenterImpl(
    this._debugAppServices,
    this._debugService,
    this._debugServicesState,
  );

  @override
  void disposeLifecycle() {}

  @override
  Future<void> initLifecycle() async {
    _debugServicesState.updated = false;
  }

  @override
  Future<String> getUpdatingConfigValue(String key) async {
    final config = await _debugAppServices.getCurrentConfig();
    return config.container.getValueByKey<dynamic>(key).toString();
  }

  @override
  Future<String> getUpdatingConfigName(String key) async {
    final config = await _debugAppServices.getCurrentConfig();

    for (final fieldKey in config.fields.keys) {
      if (fieldKey == key) {
        return config.fields[key]!.name;
      }
    }

    return '?';
  }

  @override
  Future<void> updateConfigFieldValue(String key, String value) async {
    await _debugService.updateConfigValueByKey(key, value);
    _debugServicesState.updated = true;
  }
}
