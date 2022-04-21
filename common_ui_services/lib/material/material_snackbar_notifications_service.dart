import 'package:common_ui_services/ui_notifications_service.dart';
import 'package:drivers/i18n.dart';
import 'package:drivers/lifecycle.dart';
import 'package:flutter/material.dart';

class MaterialSnackbarNotificationsService implements UINotificationsService {
  final LifecycleAwareWithContext _lifecycleAware;

  MaterialSnackbarNotificationsService.attach(this._lifecycleAware) {
    _lifecycleAware.registerLifecycle(this);
  }

  @override
  void disposeLifecycle() {}

  @override
  void initLifecycle() {}

  @override
  void show(String message) {
    ScaffoldMessenger.of(_lifecycleAware.context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void showLocalized(I18nString message) {
    ScaffoldMessenger.of(_lifecycleAware.context)
        .showSnackBar(SnackBar(content: Text(message.localize(_lifecycleAware.context))));
  }
}
