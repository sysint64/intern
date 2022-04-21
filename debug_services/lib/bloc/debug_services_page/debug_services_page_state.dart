part of 'debug_services_page_bloc.dart';

abstract class DebugServicesPageState extends Equatable {
  const DebugServicesPageState();
}

class LoadingState extends DebugServicesPageState {
  const LoadingState();

  @override
  List<Object> get props => [];
}

class LoadedState extends DebugServicesPageState {
  final DebugInfo data;

  const LoadedState(this.data);

  @override
  List<Object> get props => [data];
}

abstract class AwaitingState {}

class AwaitingResetState extends LoadedState implements AwaitingState {
  const AwaitingResetState(DebugInfo data) : super(data);
}

class AwaitingPredefinedConfig extends LoadedState implements AwaitingState {
  final String id;

  const AwaitingPredefinedConfig(this.id, DebugInfo data) : super(data);

  @override
  List<Object> get props => [...super.props, id];
}

class AwaitingFeature extends LoadedState implements AwaitingState {
  final String id;

  const AwaitingFeature(this.id, DebugInfo data) : super(data);

  @override
  List<Object> get props => [...super.props, id];
}

class LoadingErrorState extends DebugServicesPageState {
  final AppErrorWithId error;

  const LoadingErrorState(this.error);

  @override
  List<Object> get props => [error];
}
