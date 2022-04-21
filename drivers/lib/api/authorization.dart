import 'dart:convert';

import 'package:drivers/api/headers_signatura.dart';
import 'package:drivers/session.dart';

class BearerTokenSession implements Session {
  final String token;

  BearerTokenSession(this.token);

  @override
  Future<SessionSignature> sign() {
    final headers = <String, String>{'authorization': 'Bearer $token'};
    return Future.value(HeadersSignature(headers));
  }
}

class BasicBase64AuthSession implements Session {
  final String username;
  final String password;

  BasicBase64AuthSession(this.username, this.password);

  @override
  Future<SessionSignature> sign() {
    final bytes = utf8.encode(username + ':' + password);
    final token = base64.encode(bytes);
    final headers = <String, String>{'authorization': 'Basic $token'};
    return Future.value(HeadersSignature(headers));
  }
}

class BasicTokenAuthSession implements Session {
  final String token;

  BasicTokenAuthSession(this.token);

  @override
  Future<SessionSignature> sign() {
    final headers = <String, String>{'authorization': 'Basic $token'};
    print(headers);
    return Future.value(HeadersSignature(headers));
  }
}
