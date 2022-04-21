import 'package:common_ui_services/common_ui_services_module.dart';
import 'package:common_ui_services/errors_notifications_service.dart';
import 'package:drivers/dependencies.dart';
import 'package:drivers/lifecycle.dart';
import 'package:error_services/app_error.dart';
import 'package:flutter/material.dart';

class MaterialSnackbarErrorsNotificationsService implements ErrorsNotificationsService {
  final LifecycleAwareWithContext _lifecycleAware;
  final _config = resolveDependency<CommonUIServicesModuleConfig>();

  MaterialSnackbarErrorsNotificationsService.attach(this._lifecycleAware) {
    _lifecycleAware.registerLifecycle(this);
  }

  @override
  void disposeLifecycle() {}

  @override
  void initLifecycle() {}

  @override
  void showError(AppErrorWithId error) {
    final title = error.data.getLocalizedTitle();
    final description = error.data.getLocalizedDescription();

    ScaffoldMessenger.of(_lifecycleAware.context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.localize(_lifecycleAware.context)),
            if (description != null) Text(description.localize(_lifecycleAware.context)),
          ],
        ),
        action: _config.openErrorDetails != null
            ? SnackBarAction(
                label: 'DEBUG',
                onPressed: () => _config.openErrorDetails!.call(_lifecycleAware.context, error),
              )
            : null,
      ),
    );
  }
}
