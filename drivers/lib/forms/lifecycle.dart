import 'package:drivers/lifecycle.dart';
import 'package:flutter/material.dart';

class FormFieldLifecycle implements Lifecycle {
  final GlobalKey<FormFieldState> key;
  final FocusNode focus;
  final TextEditingController controller;
  final String? tag;

  FormFieldLifecycle.attach(
    LifecycleAware lifecycleAware, {
    GlobalKey<FormFieldState>? key,
    FocusNode? focus,
    TextEditingController? controller,
    this.tag,
  })  : key = key ?? GlobalKey<FormFieldState>(),
        focus = focus ?? FocusNode(),
        controller = controller ?? TextEditingController() {
    lifecycleAware.registerLifecycle(this);
  }

  @override
  void initLifecycle() {
    // log('TextFieldDisposableState', 'init');
  }

  @override
  void disposeLifecycle() {
    // log('TextFieldDisposableState', 'dispose');
    controller.dispose();
    focus.dispose();
  }
}
