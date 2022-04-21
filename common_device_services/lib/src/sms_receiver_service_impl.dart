import 'dart:async';

import 'package:common_device_services/models.dart';
import 'package:common_device_services/sms_receiver_service.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

class SmsReceiverServiceImpl implements SmsReceiverService {
  late SmsUserConsent smsUserConsent;
  final _smsStreamController = StreamController<ReceivedSmsData>.broadcast();

  @override
  void initLifecycle() {
    smsUserConsent = SmsUserConsent(
      smsListener: () {
        final sms = smsUserConsent.receivedSms;
        final phone = smsUserConsent.selectedPhoneNumber;

        if (sms != null) {
          _smsStreamController.add(ReceivedSmsData(phone, sms));
        }
      },
    );
  }

  @override
  void disposeLifecycle() {
    smsUserConsent.dispose();
    _smsStreamController.close();
  }

  @override
  void requestSms({String? senderPhoneNumber}) {
    smsUserConsent.requestSms(senderPhoneNumber: senderPhoneNumber);
  }

  @override
  Stream<ReceivedSmsData> receivedSms() {
    return _smsStreamController.stream;
  }
}
