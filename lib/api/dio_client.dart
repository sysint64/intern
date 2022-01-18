import 'package:dio/dio.dart';
import 'package:drivers/api/headers_signatura.dart';
import 'package:drivers/api/status_code.dart';
import 'package:drivers/exceptions.dart';
import 'package:drivers/log.dart';
import 'package:drivers/session.dart';
import 'package:flutter/cupertino.dart';

class DioClient {
  final Dio _dio;
  final String baseEndpoint;

  DioClient(
    this._dio, {
    required this.baseEndpoint,
  });

  Future<Options> _defaultOptions(Session session) async {
    final sign = await session.sign();

    if (sign is HeadersSignature) {
      return Options(headers: sign.headers);
    } else {
      return Options();
    }
  }

  Future<Options> _createOptions(
    Options? options,
    Session? session,
  ) async {
    if (options != null) {
      return options;
    } else if (session != null) {
      return _defaultOptions(session);
    } else {
      return Options();
    }
  }

  Future<Response<T>> get<T>(
    String endpoint, {
    Options? options,
    CancelToken? cancelToken,
    Session? session,
  }) async {
    return _request<T>(
      () async => _dio.get(
        '$baseEndpoint$endpoint',
        options: await _createOptions(options, session),
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    Session? session,
  }) async {
    return _request<T>(
      () async => _dio.post(
        '$baseEndpoint$endpoint',
        data: data,
        options: await _createOptions(options, session),
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    Session? session,
  }) async {
    return _request<T>(
      () async => _dio.patch(
        '$baseEndpoint$endpoint',
        data: data,
        options: await _createOptions(options, session),
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    Session? session,
  }) async {
    return _request<T>(
      () async => _dio.put(
        '$baseEndpoint$endpoint',
        data: data,
        options: await _createOptions(options, session),
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    Session? session,
  }) async {
    return _request<T>(
      () async => _dio.delete(
        '$baseEndpoint$endpoint',
        data: data,
        options: await _createOptions(options, session),
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> _request<T>(Future<Response<T>> Function() handler) async {
    try {
      final response = await handler();
      return response;
    } on DioError catch (e, stackTrace) {
      logError('dio client', 'request', e: e, st: stackTrace);
      throw dioErrorToException(e);
    } catch (e, stackTrace) {
      logError('dio client', 'request', e: e, st: stackTrace);
      throw ConnectionException();
    }
  }

  Map<String, dynamic> getJsonBody<T>(Response<T> response) {
    try {
      return response.data as Map<String, dynamic>;
    } on Exception catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
      throw SchemeConsistencyException('Bad body format');
    }
  }

  List<dynamic> getJsonBodyList<T>(Response<T> response) {
    try {
      return response.data as List<dynamic>;
    } on Exception catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
      throw SchemeConsistencyException('Bad body format');
    }
  }

  Exception dioErrorToException(DioError e) {
    switch (e.type) {
      case DioErrorType.response:
        final statusCode = e.response?.statusCode;
        return ApiException(
          statusCode: statusCode == null ? null : StatusCode(statusCode),
          body: e.response?.data,
          headers: e.response?.headers,
        );
      case DioErrorType.cancel:
        return CanceledException();
      case DioErrorType.other:
        if (e.error is LogicException) {
          return e.error as LogicException;
        } else {
          return ConnectionException();
        }
      default:
        return ConnectionException();
    }
  }

  Exception handleErrors(ApiException exception) {
    return exception;
  }
}
