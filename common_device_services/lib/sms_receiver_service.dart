import 'package:common_device_services/models.dart';
import 'package:drivers/lifecycle.dart';

/// Service that provides methods to read just received
/// SMS messages from you phone.
abstract class SmsReceiverService implements Lifecycle {
  /// Request receiving SMS message.
  void requestSms({String? senderPhoneNumber});

  /// Get stream of received SMS messages.
  /// result contains sender and SMS message.
  Stream<ReceivedSmsData> receivedSms();
}
