part of 'update_config_value_page_bloc.dart';

abstract class UpdateConfigValuePageEvent extends Equatable {
  const UpdateConfigValuePageEvent();
}

class OnLoad extends UpdateConfigValuePageEvent {
  const OnLoad();

  @override
  List<Object> get props => [];
}

class OnUpdateValue extends UpdateConfigValuePageEvent {
  final String value;

  const OnUpdateValue(this.value);

  @override
  List<Object> get props => [value];
}
