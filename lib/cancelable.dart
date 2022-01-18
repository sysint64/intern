import 'package:dio/dio.dart';

abstract class Cancelable<T> {
  Future<T> execute();

  void cancel();
}

class DioCancelable<T> implements Cancelable<T> {
  final Future<T> Function(CancelToken) executor;
  final CancelToken cancelToken = CancelToken();

  DioCancelable(this.executor);

  @override
  void cancel() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
  }

  @override
  Future<T> execute() => executor(cancelToken);
}

class VoidCancelable implements Cancelable<void> {
  @override
  void cancel() {}

  @override
  Future<void> execute() async {}
}

class ValueCancelable<T> implements Cancelable<T> {
  final T value;

  ValueCancelable(this.value);

  @override
  void cancel() {}

  @override
  Future<T> execute() async => value;
}

class FutureCancelable<T> implements Cancelable<T> {
  final Future<T> Function() executor;

  FutureCancelable(this.executor);

  @override
  void cancel() {}

  @override
  Future<T> execute() => executor();
}

class ThenCancellable<T> implements Cancelable<T> {
  final Cancelable<T> parent;
  final Future<void> Function(T value) then;

  ThenCancellable(this.parent, this.then);

  @override
  void cancel() {
    parent.cancel();
  }

  @override
  Future<T> execute() async {
    final res = await parent.execute();
    await then(res);
    return res;
  }
}

class MapCancellable<R, T> implements Cancelable<R> {
  final Cancelable<T> parent;
  final R Function(T value) map;

  MapCancellable(this.parent, this.map);

  @override
  void cancel() {
    parent.cancel();
  }

  @override
  Future<R> execute() async {
    final res = await parent.execute();
    return map(res);
  }
}

extension CancelableReactiveExt<T> on Cancelable<T> {
  Cancelable<T> then(Future<void> Function(T value) callback) {
    return ThenCancellable(this, callback);
  }

  Cancelable<R> map<R>(R Function(T value) callback) {
    return MapCancellable(this, callback);
  }
}
