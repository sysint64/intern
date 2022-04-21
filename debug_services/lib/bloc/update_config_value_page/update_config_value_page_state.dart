part of 'update_config_value_page_bloc.dart';

abstract class UpdateConfigValuePageState extends Equatable {
  const UpdateConfigValuePageState();
}

class LoadingState extends UpdateConfigValuePageState {
  const LoadingState();

  @override
  List<Object> get props => [];
}

class LoadedState extends UpdateConfigValuePageState {
  final String name;
  final String value;

  const LoadedState(this.name, this.value);

  @override
  List<Object> get props => [name, value];
}

class AwaitingSetValueState extends LoadedState {
  const AwaitingSetValueState(String name, String value) : super(name, value);
}

class LoadingErrorState extends UpdateConfigValuePageState {
  final AppErrorWithId error;

  const LoadingErrorState(this.error);

  @override
  List<Object> get props => [error];
}
