import 'package:drivers/lifecycle.dart';
import 'package:drivers/log.dart';
import 'package:get_it/get_it.dart';

T resolveDependency<T extends Object>({String? instanceName, String? errorMessage}) {
  if (T is Lifecycle) {
    Log.warning('di',
        'Resolve dependency: $T that implements $Lifecycle type, consider using $resolveLifecycleDependency');
  }

  try {
    return GetIt.instance.get<T>(instanceName: instanceName);
  } catch (e, stackTrace) {
    Log.error('di', errorMessage ?? 'failed resolving dependency', e, stackTrace);
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

void registerSingletonDependency<T extends Object>(T instance, {String? instanceName}) =>
    GetIt.instance.registerSingleton<T>(instance, instanceName: instanceName);

void registerFactoryDependency<T extends Object>(
  T Function() factoryFunc, {
  String? instanceName,
}) =>
    GetIt.instance.registerFactory<T>(factoryFunc, instanceName: instanceName);

void removeDependency<T extends Object>(T instance, {String? instanceName}) =>
    GetIt.instance.unregister<T>(instance: instance, instanceName: instanceName);

LifecycleWithContextRegistrator<T> resolveLifecycleDependency<T extends Lifecycle>({
  String? instanceName,
}) {
  try {
    return GetIt.instance.get<LifecycleWithContextRegistrator<T>>(instanceName: instanceName);
  } catch (e, stackTrace) {
    Log.error('di', 'failed resolving dependency', e, stackTrace);
    rethrow;
  }
}

void registerLifecycleDependency<T extends Lifecycle>({
  required T Function(LifecycleAwareWithContext) builder,
  String? instanceName,
}) =>
    GetIt.instance.registerSingleton<LifecycleWithContextRegistrator<T>>(
      LifecycleWithContextRegistrator<T>(builder),
      instanceName: instanceName,
    );
