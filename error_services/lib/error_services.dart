library error_services;

import 'package:drivers/dependencies.dart';
import 'package:drivers/errors_reporter/errors_reporter.dart';
import 'package:error_services/errors_service.dart';
import 'package:error_services/src/errors_service_impl.dart';
import 'package:error_services/src/errors_services_state.dart';

class ErrorServicesModule {
  final ErrorsServicesState state;
  final ErrorsService errorsServices;

  ErrorServicesModule({
    required this.state,
    required this.errorsServices,
  });

  static Future<ErrorServicesModule> bootstrap(ErrorsReporter errorsReporter) async {
    final state = ErrorsServicesState();
    final module = ErrorServicesModule(
      state: state,
      errorsServices: ErrorsServiceImpl(errorsReporter, state),
    );
    module.registerDependencies();
    return module;
  }

  void registerDependencies() {
    registerSingletonDependency<ErrorsServicesState>(state);
    registerSingletonDependency<ErrorsService>(errorsServices);
  }
}
