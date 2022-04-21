import 'package:drivers/lifecycle.dart';
import 'package:flutter/material.dart';

abstract class LifecycleAwareWidgetState<T extends StatefulWidget> extends State<T>
    implements LifecycleAwareWithContext {
  final _registeredServices = <Lifecycle>[];
  final _initedServices = <Lifecycle>[];

  @override
  void didChangeDependencies() {
    for (final service in _registeredServices) {
      if (!_initedServices.contains(service)) {
        service.initLifecycle();
        _initedServices.add(service);
      }
    }
    onAttach();
    super.didChangeDependencies();
  }

  void onAttach() {}

  @override
  void dispose() {
    for (final service in _registeredServices) {
      service.disposeLifecycle();
    }
    super.dispose();
  }

  @override
  void registerLifecycle(Lifecycle lifecycle) {
    _registeredServices.add(lifecycle);

    if (mounted && !_initedServices.contains(lifecycle)) {
      lifecycle.initLifecycle();
      _initedServices.add(lifecycle);
    }
  }
}
