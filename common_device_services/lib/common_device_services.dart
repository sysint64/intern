/// Module contains most common device services like copy service,
/// network availability service etc.

library common_device_services;

import 'package:common_device_services/copy_service.dart';
import 'package:common_device_services/sms_receiver_service.dart';
import 'package:common_device_services/src/copy_service_impl.dart';
import 'package:common_device_services/src/sms_receiver_service_impl.dart';
import 'package:drivers/dependencies.dart';
import 'package:drivers/lifecycle.dart';

class CommonDeviceServicesModule {
  final LifecycleWithContextRegistrator<CopyService> copyService;
  final LifecycleWithContextRegistrator<SmsReceiverService> smsReceiverService;

  CommonDeviceServicesModule({
    required this.copyService,
    required this.smsReceiverService,
  });

  static Future<CommonDeviceServicesModule> bootstrap() async {
    final module = CommonDeviceServicesModule(
      copyService: LifecycleWithContextRegistrator(
        (lifecycleAware) => CopyServiceImpl(lifecycleAware),
      ),
      smsReceiverService: LifecycleWithContextRegistrator(
        (_) => SmsReceiverServiceImpl(),
      ),
    );
    module.registerDependencies();
    return module;
  }

  void registerDependencies() {
    registerLifecycleDependency<CopyService>(
      builder: copyService.attach,
    );
    registerLifecycleDependency<SmsReceiverService>(
      builder: smsReceiverService.attach,
    );
  }
}
