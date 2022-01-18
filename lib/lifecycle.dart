import 'dart:async';

import 'package:drivers/log.dart';
import 'package:drivers/router/path.dart';
import 'package:get_it/get_it.dart';

import 'dependencies.dart';

abstract class RouteLifecycle {
  void init();

  void dispose();
}

abstract class RouteLifecycleRegistrator<T extends RouteLifecycle> {
  bool isValidRouteSegment(RouterPathConfiguration pathSegment);

  T create();

  void register() {
    if (!GetIt.instance.isRegistered<T>()) {
      log('route lifecycle registrator', 'registered $T');
      final instance = create();
      GetIt.instance.registerSingleton<T>(instance);
      instance.init();
    }
  }

  void unregister() {
    if (GetIt.instance.isRegistered<T>()) {
      log('route lifecycle registrator', 'unregistered $T');
      GetIt.instance<T>().dispose();
      GetIt.instance.unregister<T>();
    }
  }
}

class StreamSubscriptionLifecycle<T> implements Lifecycle {
  final StreamSubscription<T> sub;
  final String tag;

  StreamSubscriptionLifecycle(this.sub, this.tag);

  StreamSubscriptionLifecycle.attach(
    LifecycleAware lifecycleAware, {
    required this.sub,
    required this.tag,
  }) {
    lifecycleAware.registerLifecycle(this);
  }

  @override
  void disposeLifecycle() {
    log('stream subscription', 'dispose: $tag');
    sub.cancel();
  }

  @override
  void initLifecycle() {
    log('stream subscription', 'init: $tag');
  }
}
