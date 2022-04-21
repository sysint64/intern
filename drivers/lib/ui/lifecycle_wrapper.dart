import 'package:drivers/lifecycle.dart';
import 'package:flutter/material.dart';

class ChangeNotifierLifecycle<T extends ChangeNotifier> implements Lifecycle {
  final T instance;

  ChangeNotifierLifecycle(this.instance);

  ChangeNotifierLifecycle.attach(LifecycleAwareWithContext lifecycleAware, this.instance) {
    lifecycleAware.registerLifecycle(this);
  }

  @override
  void disposeLifecycle() {
    instance.dispose();
  }

  @override
  void initLifecycle() {}
}
