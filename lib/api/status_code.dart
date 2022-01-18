import 'package:equatable/equatable.dart';

class StatusCode extends Equatable {
  static const ok200 = StatusCode(200);
  static const created201 = StatusCode(201);
  static const noContent204 = StatusCode(204);
  static const badRequest400 = StatusCode(400);
  static const unauthorized401 = StatusCode(401);
  static const forbidden403 = StatusCode(403);
  static const notFound404 = StatusCode(404);
  static const methodNotAllowed405 = StatusCode(405);
  static const conflict409 = StatusCode(409);
  static const internalServerError500 = StatusCode(500);
  static const badGateway502 = StatusCode(502);
  static const serviceUnavailable502 = StatusCode(503);
  static const gatewayTimeout504 = StatusCode(504);

  final int value;

  const StatusCode(this.value);

  @override
  List<Object?> get props => [value];
}
