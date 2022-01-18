abstract class Session {
  Future<SessionSignature> sign();
}

abstract class SessionSignature {}

class SessionImpl implements Session {
  @override
  Future<SessionSignature> sign() {
    // TODO: implement sign
    throw UnimplementedError();
  }
}
