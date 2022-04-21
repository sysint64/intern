import 'package:drivers/errors_reporter/errors_reporter.dart';
import 'package:drivers/exceptions.dart';
import 'package:drivers/log.dart';
import 'package:error_services/app_error.dart';
import 'package:error_services/errors_service.dart';
import 'package:error_services/src/errors_services_state.dart';

class ErrorsServiceImpl implements ErrorsService {
  final ErrorsReporter _errorsReporter;
  final ErrorsServicesState _state;

  ErrorsServiceImpl(this._errorsReporter, this._state);

  @override
  Future<AppErrorWithId> registerError(Object error, StackTrace stackTrace) async {
    final id = AppErrorId(_state.lastErrorId);
    _state.lastErrorId += 1;

    if (!_state.lastErrorId.isFinite) {
      _state.lastErrorId = 0;
    }

    final pair = AppErrorWithId(id, AppError(error, stackTrace));
    _state.lastErrors.insert(0, pair);

    if (_state.lastErrors.length > ErrorsServicesState.kMaxErrors) {
      _state.lastErrors.removeRange(ErrorsServicesState.kMaxErrors, _state.lastErrors.length);
    }

    if (error is! LogicException) {
      await _errorsReporter.reportError(error, stackTrace);
    } else {
      Log.error('errors service', 'Logic error occured', error, stackTrace);
    }

    return pair;
  }

  @override
  Future<AppError> getErrorById(AppErrorId id) async {
    final errors = _state.lastErrors.where((element) => element.id == id);

    if (errors.isEmpty) {
      throw ErrorNotFoundException();
    }

    return errors.first.data;
  }
}
