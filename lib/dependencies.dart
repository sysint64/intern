import 'package:drivers/log.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

T resolveDependency<T extends Object>({String? instanceName}) {
  try {
    return GetIt.instance.get<T>(instanceName: instanceName);
  } catch (e, stackTrace) {
    logError('di', 'failed resolving dependency', e: e, st: stackTrace);
    rethrow;
  }
}

T? resolveDependencyOrNull<T extends Object>({String? instanceName}) {
  try {
    return GetIt.instance.get<T>(instanceName: instanceName);
  } catch (_) {
    return null;
  }
}

void pushDependency<T extends Object>(T instance, {String? instanceName}) =>
    GetIt.instance.registerSingleton<T>(instance, instanceName: instanceName);

void removeDependency<T extends Object>(T instance, {String? instanceName}) =>
    GetIt.instance.unregister<T>(instance: instance, instanceName: instanceName);

LifecycleDependency<T> resolveLifecycleDependency<T extends Lifecycle>({String? instanceName}) {
  try {
    return GetIt.instance.get<LifecycleDependency<T>>(instanceName: instanceName);
  } catch (e, stackTrace) {
    logError('di', 'failed resolving dependency', e: e, st: stackTrace);
    rethrow;
  }
}

void registerLifecycleDependency<T extends Lifecycle>({
  required T Function(LifecycleAwareWithContext) builder,
  String? instanceName,
}) =>
    GetIt.instance.registerSingleton<LifecycleDependency<T>>(
      LifecycleDependency<T>(builder),
      instanceName: instanceName,
    );

class LifecycleDependency<T extends Lifecycle> {
  final T Function(LifecycleAwareWithContext) builder;

  LifecycleDependency(this.builder);

  T attach(LifecycleAwareWithContext lifecycleAware) {
    final service = builder(lifecycleAware);
    lifecycleAware.registerLifecycle(service);
    return service;
  }
}

abstract class Lifecycle {
  void initLifecycle();

  void disposeLifecycle();
}

abstract class LifecycleAware {
  void registerLifecycle(Lifecycle lifecycle);
}

abstract class LifecycleAwareWithContext extends LifecycleAware {
  BuildContext get context;
}
