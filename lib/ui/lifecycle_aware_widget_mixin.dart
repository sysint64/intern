import 'package:drivers/dependencies.dart';
import 'package:flutter/material.dart';

abstract class LifecycleAwareState<T extends StatefulWidget> extends State<T>
    implements LifecycleAwareWithContext {
  final _registeredLifecycles = <Lifecycle>[];
  final _initedLifecycles = <Lifecycle>[];

  @override
  void didChangeDependencies() {
    for (final service in _registeredLifecycles) {
      if (!_initedLifecycles.contains(service)) {
        service.initLifecycle();
        _initedLifecycles.add(service);
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    for (final service in _registeredLifecycles) {
      service.disposeLifecycle();
    }
    super.dispose();
  }

  @override
  void registerLifecycle(Lifecycle lifecycle) {
    _registeredLifecycles.add(lifecycle);

    if (mounted && !_initedLifecycles.contains(lifecycle)) {
      lifecycle.initLifecycle();
      _initedLifecycles.add(lifecycle);
    }
  }
}
