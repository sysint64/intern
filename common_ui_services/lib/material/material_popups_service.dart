import 'package:common_ui_services/popups_service.dart';
import 'package:drivers/lifecycle.dart';
import 'package:flutter/material.dart';

class MaterialPopupsService implements PopupsService {
  final LifecycleAwareWithContext _lifecycleAware;

  MaterialPopupsService.attach(this._lifecycleAware) {
    _lifecycleAware.registerLifecycle(this);
  }

  @override
  void disposeLifecycle() {}

  @override
  void initLifecycle() {}

  @override
  Future<void> showOkPopup({
    required String title,
    String? descriptions,
    String? buttonTitle,
  }) async {
    await showDialog<void>(
      context: _lifecycleAware.context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(descriptions ?? ''),
        actions: [
          TextButton(
            child: Text(buttonTitle ?? 'OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Future<bool> showYesNoPopup({
    required String title,
    String? descriptions,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
  }) async {
    return await showDialog<bool>(
          context: _lifecycleAware.context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(descriptions ?? ''),
            actions: [
              TextButton(
                child: Text(positiveButtonTitle ?? 'No'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text(positiveButtonTitle ?? 'Yes'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }
}
