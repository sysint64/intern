library debug_services;

import 'package:config/config_module.dart';
import 'package:debug_services/config_adapter.dart';
import 'package:debug_services/dashboard_builder.dart';
import 'package:debug_services/pages/error_details_page.dart';
import 'package:debug_services/presenters/debug_services_page_presenter.dart';
import 'package:debug_services/presenters/update_config_value_page_presenter.dart';
import 'package:debug_services/router/configurations.dart';
import 'package:debug_services/services/app_debug_services.dart';
import 'package:debug_services/services/debug_services.dart';
import 'package:debug_services/src/debug_services_state.dart';
import 'package:debug_services/src/presenters/debug_services_page_presenter_impl.dart';
import 'package:debug_services/src/presenters/update_config_value_page_presenter_impl.dart';
import 'package:debug_services/src/services/debug_services_impl.dart';
import 'package:debug_services/src/ui_services/debug_float_panel_impl.dart';
import 'package:debug_services/ui_services/debug_float_panel.dart';
import 'package:drivers/dependencies.dart';
import 'package:drivers/lifecycle.dart';
import 'package:drivers/router/path.dart';
import 'package:drivers/router/router.dart';
import 'package:error_services/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:loggy/loggy.dart';

class DebugServicesStateRegistrator extends RouteLifecycleRegistrator<DebugServicesState> {
  @override
  bool isValidRouteSegment(RouterPathConfiguration pathSegment) =>
      pathSegment is DebugServicesRouteScopeLifecycle;

  @override
  DebugServicesState create() => DebugServicesState();
}

class DebugServicesConfig {
  final bool captureLog;

  const DebugServicesConfig({
    this.captureLog = true,
  });
}

class DebugServicesModule {
  final DebugAppService debugAppService;
  final DebugServicesService debugServicesService;
  final AppRouter router;
  final DebugServicesConfig config;
  final DebugServicesDashboardBuilder dashboardBuilder;
  final void Function(BuildContext context, AppErrorWithId error) openErrorDetails;

  DebugServicesModule({
    required this.debugAppService,
    required this.router,
    required this.debugServicesService,
    required this.config,
    required this.openErrorDetails,
    required this.dashboardBuilder,
  });

  static Future<DebugServicesModule> bootstrap(
    AppRouter router,
    DebugAppService debugAppService,
    DebugServicesConfigAdapter debugServicesConfigAdapter,
    ConfigModule configModule,
    DebugServicesConfig config,
  ) async {
    final debugServicesService = DebugServicesServiceImpl(
      debugServicesConfigAdapter,
      debugAppService,
      configModule.configDataStorageAdapter,
      configModule.configDataStorage,
      configModule.defaultConfigDescriptor,
    );
    final module = DebugServicesModule(
      debugAppService: debugAppService,
      config: config,
      debugServicesService: debugServicesService,
      router: router,
      dashboardBuilder: DebugServicesDashboardBuilder(),
      openErrorDetails: (context, error) =>
          Navigator.of(context).push(ErrorDetailsPage.route(error.data)),
    );
    router.registerLifecycle(DebugServicesStateRegistrator());

    if (config.captureLog) {
      Loggy.initLoggy(
        logPrinter: StreamPrinter(const PrettyPrinter()),
      );
    }

    module.registerDependencies();
    return module;
  }

  void registerDependencies() {
    registerSingletonDependency<DebugServicesService>(debugServicesService);
    registerLifecycleDependency<DebugServicesPagePresenter>(
      builder: (lifecycleAware) => DebugServicesPagePresenterImpl(
        debugAppService,
        debugServicesService,
        resolveDependency<DebugServicesState>(),
      ),
    );
    registerLifecycleDependency<UpdateConfigValuePagePresenter>(
      builder: (lifecycleAware) => UpdateConfigValuePagePresenterImpl(
        debugAppService,
        debugServicesService,
        resolveDependency<DebugServicesState>(),
      ),
    );
    registerLifecycleDependency<DebugFloatPanelService>(
      builder: (_) => DebugFloatPanelServiceImpl(router),
    );
    registerSingletonDependency<DebugServicesConfig>(config);
    registerSingletonDependency<DebugServicesDashboardBuilder>(dashboardBuilder);
  }
}
