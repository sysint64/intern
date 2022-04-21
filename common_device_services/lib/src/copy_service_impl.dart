import 'package:common_device_services/copy_service.dart';
import 'package:drivers/lifecycle.dart';
import 'package:drivers/i18n.dart';
import 'package:flutter/services.dart';

class CopyServiceImpl implements CopyService {
  final LifecycleAwareWithContext _lifecycleAware;

  CopyServiceImpl(this._lifecycleAware);

  @override
  void disposeLifecycle() {}

  @override
  void initLifecycle() {}

  @override
  Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Future<void> copyI18nString(I18nString text) => copy(text.localize(_lifecycleAware.context));
}
