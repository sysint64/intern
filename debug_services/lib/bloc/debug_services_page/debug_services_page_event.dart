part of 'debug_services_page_bloc.dart';

abstract class DebugServicesPageEvent extends Equatable {
  const DebugServicesPageEvent();
}

class OnLoad extends DebugServicesPageEvent {
  const OnLoad();

  @override
  List<Object> get props => [];
}

class OnClose extends DebugServicesPageEvent {
  const OnClose();

  @override
  List<Object> get props => [];
}

class OnReset extends DebugServicesPageEvent {
  const OnReset();

  @override
  List<Object> get props => [];
}

class OnCopyClick extends DebugServicesPageEvent {
  final String value;

  const OnCopyClick(this.value);

  @override
  List<Object> get props => [value];
}

class OnUpdateConfig extends DebugServicesPageEvent {
  final String id;
  final AppConfigDescriptor config;

  const OnUpdateConfig({
    required this.id,
    required this.config,
  });

  @override
  List<Object> get props => [id, config];
}

class OnUpdateConfigValueClick extends DebugServicesPageEvent {
  final String id;
  final String? value;

  const OnUpdateConfigValueClick(this.id, this.value);

  @override
  List<Object?> get props => [id, value];
}

class OnUpdateFeature extends DebugServicesPageEvent {
  final String id;
  final bool value;

  // ignore: avoid_positional_boolean_parameters
  const OnUpdateFeature(this.id, this.value);

  @override
  List<Object> get props => [id, value];
}
