import 'package:common_ui_services/errors_notifications_service.dart';
import 'package:common_ui_services/ui_notifications_service.dart';
import 'package:debug_services/presenters/update_config_value_page_presenter.dart';
import 'package:drivers/router/router.dart';
import 'package:equatable/equatable.dart';
import 'package:error_services/app_error.dart';
import 'package:error_services/errors_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_config_value_page_event.dart';
part 'update_config_value_page_state.dart';

class UpdateConfigValuePageBloc
    extends Bloc<UpdateConfigValuePageEvent, UpdateConfigValuePageState> {
  final String key;
  final AppRouter _router;
  final ErrorsService _errorsService;
  final UINotificationsService _toastNotifications;
  final ErrorsNotificationsService _errorsNotifications;
  final UpdateConfigValuePagePresenter _presenter;

  UpdateConfigValuePageBloc(
    this.key,
    this._router,
    this._errorsService,
    this._toastNotifications,
    this._errorsNotifications,
    this._presenter,
  ) : super(const LoadingState()) {
    on<OnLoad>(_onLoad);
    on<OnUpdateValue>(_onUpdateValue);
  }

  void _onLoad(OnLoad event, Emitter<UpdateConfigValuePageState> emit) async {
    try {
      emit(const LoadingState());
      final name = await _presenter.getUpdatingConfigName(key);
      final data = await _presenter.getUpdatingConfigValue(key);
      emit(LoadedState(name, data));
    } catch (e, stackTrace) {
      final error = await _errorsService.registerError(e, stackTrace);
      emit(LoadingErrorState(error));
    }
  }

  void _onUpdateValue(OnUpdateValue event, Emitter<UpdateConfigValuePageState> emit) async {
    assert(state is LoadedState, 'State: $state');
    final currentState = state as LoadedState;

    try {
      emit(AwaitingSetValueState(currentState.name, currentState.value));
      await _presenter.updateConfigFieldValue(key, event.value);
      _router.pop(true);
      _toastNotifications.show('Success');
    } catch (e, stackTrace) {
      final error = await _errorsService.registerError(e, stackTrace);
      _errorsNotifications.showError(error);
      emit(currentState);
    }
  }
}
