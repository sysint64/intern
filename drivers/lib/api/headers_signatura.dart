import 'package:drivers/session.dart';

class HeadersSignature implements SessionSignature {
  final Map<String, String> headers;

  HeadersSignature(this.headers);
}
