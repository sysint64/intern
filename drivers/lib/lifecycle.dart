import 'dart:async';

import 'package:drivers/log.dart';
import 'package:drivers/router/path.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

class LifecycleRegistrator<T extends Lifecycle> {
  final T Function(LifecycleAware) builder;

  LifecycleRegistrator(this.builder);

  T attach(LifecycleAware lifecycleAware) {
    final lifecycle = builder(lifecycleAware);
    lifecycleAware.registerLifecycle(lifecycle);
    return lifecycle;
  }
}

class LifecycleWithContextRegistrator<T extends Lifecycle> {
  final T Function(LifecycleAwareWithContext) builder;

  LifecycleWithContextRegistrator(this.builder);

  T attach(LifecycleAwareWithContext lifecycleAware) {
    final lifecycle = builder(lifecycleAware);
    lifecycleAware.registerLifecycle(lifecycle);
    return lifecycle;
  }
}

abstract class RouteLifecycle {
  void init();

  void dispose();
}

abstract class RouteLifecycleRegistrator<T extends RouteLifecycle> {
  bool isValidRouteSegment(RouterPathConfiguration pathSegment);

  T create();

  void register() {
    if (!GetIt.instance.isRegistered<T>()) {
      Log.debug('route lifecycle registrator', 'registered $T');
      final instance = create();
      GetIt.instance.registerSingleton<T>(instance);
      instance.init();
    }
  }

  void unregister() {
    if (GetIt.instance.isRegistered<T>()) {
      Log.debug('route lifecycle registrator', 'unregistered $T');
      GetIt.instance<T>().dispose();
      GetIt.instance.unregister<T>();
    }
  }
}

class StreamSubscriptionLifecycle<T> implements Lifecycle {
  final StreamSubscription<T> sub;
  final String? tag;

  StreamSubscriptionLifecycle(this.sub, this.tag);

  StreamSubscriptionLifecycle.attach(
    LifecycleAware lifecycleAware, {
    required this.sub,
    this.tag,
  }) {
    lifecycleAware.registerLifecycle(this);
  }

  @override
  void disposeLifecycle() {
    if (tag != null) {
      Log.debug('stream subscription', 'dispose: $tag');
    }
    sub.cancel();
  }

  @override
  void initLifecycle() {
    if (tag != null) {
      Log.debug('stream subscription', 'init: $tag');
    }
  }
}
