import 'package:common_device_services/copy_service.dart';
import 'package:common_ui_services/errors_notifications_service.dart';
import 'package:common_ui_services/popups_service.dart';
import 'package:common_ui_services/ui_notifications_service.dart';
import 'package:config/config_spec.dart';
import 'package:debug_services/models.dart';
import 'package:debug_services/presenters/debug_services_page_presenter.dart';
import 'package:debug_services/router/routes.dart';
import 'package:drivers/router/router.dart';
import 'package:equatable/equatable.dart';
import 'package:error_services/app_error.dart';
import 'package:error_services/errors_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'debug_services_page_event.dart';
part 'debug_services_page_state.dart';

class DebugServicesPageBloc extends Bloc<DebugServicesPageEvent, DebugServicesPageState> {
  final AppRouter _router;
  final ErrorsService _errorsService;
  final ErrorsNotificationsService _errorNotifications;
  final UINotificationsService _notificationsServices;
  final PopupsService _popupsService;
  final CopyService _copyService;
  final DebugServicesPagePresenter _presenter;

  DebugServicesPageBloc(
    this._router,
    this._errorsService,
    this._errorNotifications,
    this._notificationsServices,
    this._popupsService,
    this._copyService,
    this._presenter,
  ) : super(const LoadingState()) {
    on<OnLoad>(_onLoad);
    on<OnReset>(_onResetClick);
    on<OnCopyClick>(_onCopyClick);
    on<OnUpdateConfigValueClick>(_onUpdateConfigValueClick);
    on<OnUpdateConfig>(_onUpdateConfig);
    on<OnUpdateFeature>(_onUpdateFeature);
    on<OnClose>(_onClose);
  }

  Future<void> _onLoad(OnLoad event, Emitter<DebugServicesPageState> emit) async {
    try {
      emit(const LoadingState());
      final data = await _presenter.getData();
      emit(LoadedState(data));
    } catch (e, stackTrace) {
      final error = await _errorsService.registerError(e, stackTrace);
      emit(LoadingErrorState(error));
    }
  }

  Future<void> _onResetClick(OnReset event, Emitter<DebugServicesPageState> emit) async {
    assert(state is LoadedState, 'State: $state');
    final lastValidState = state as LoadedState;

    try {
      final shouldReset = await _popupsService.showYesNoPopup(
        title: 'Reset?',
        descriptions: 'Are you sure you want to reset config to default?',
      );

      if (shouldReset) {
        emit(AwaitingResetState(lastValidState.data));
        await _presenter.restoreConfigToDefaults();
        final data = await _presenter.getData();
        emit(LoadedState(data));

        _notificationsServices.show('Successfully reset config to default');
      }
    } catch (e, stackTrace) {
      final error = await _errorsService.registerError(e, stackTrace);
      _errorNotifications.showError(error);
      emit(lastValidState);
    }
  }

  Future<void> _onCopyClick(OnCopyClick event, Emitter<DebugServicesPageState> emit) async {
    await _copyService.copy(event.value);
    _notificationsServices.show('Successfully copied');
  }

  Future<void> _onUpdateConfigValueClick(
    OnUpdateConfigValueClick event,
    Emitter<DebugServicesPageState> emit,
  ) async {
    assert(state is LoadedState, 'State: $state');

    try {
      final isUpdated = await _router.open(UpdateConfigValuePath(event.id, event.value));

      if (isUpdated) {
        await _onLoad(const OnLoad(), emit);
      }
    } catch (e, stackTrace) {
      final error = await _errorsService.registerError(e, stackTrace);
      _errorNotifications.showError(error);
    }
  }

  Future<void> _onUpdateConfig(OnUpdateConfig event, Emitter<DebugServicesPageState> emit) async {
    assert(state is LoadedState, 'State: $state');
    final lastValidState = state as LoadedState;

    try {
      emit(AwaitingPredefinedConfig(event.id, lastValidState.data));
      await _presenter.updateConfigByDescriptor(event.config);
      await _onLoad(const OnLoad(), emit);
      _notificationsServices.show('Successfully updated');
    } catch (e, stackTrace) {
      final error = await _errorsService.registerError(e, stackTrace);
      _errorNotifications.showError(error);
      emit(lastValidState);
    }
  }

  Future<void> _onUpdateFeature(OnUpdateFeature event, Emitter<DebugServicesPageState> emit) async {
    assert(state is LoadedState, 'State: $state');
    final lastValidState = state as LoadedState;

    try {
      emit(AwaitingFeature(event.id, lastValidState.data));
      await _presenter.updateFeatureValue(event.id, event.value);
      await _onLoad(const OnLoad(), emit);
    } catch (e, stackTrace) {
      final error = await _errorsService.registerError(e, stackTrace);
      _errorNotifications.showError(error);
      emit(lastValidState);
    }
  }

  Future<void> _onClose(OnClose event, Emitter<DebugServicesPageState> emit) async {
    assert(state is LoadedState, 'State: $state');
    final lastValidState = state as LoadedState;

    try {
      if (!await _presenter.isConfigUpdated()) {
        _router.pop();
        return;
      }

      final shouldRestartApp = await _popupsService.showYesNoPopup(
        title: 'Config has changed',
        descriptions:
            'Would you like to restart the application to apply the newest configuration?',
      );

      if (shouldRestartApp) {
        await _presenter.resetApplicationState();
      } else {
        _router.pop();
      }
    } catch (e, stackTrace) {
      final error = await _errorsService.registerError(e, stackTrace);
      _errorNotifications.showError(error);
      emit(lastValidState);
    }
  }
}
