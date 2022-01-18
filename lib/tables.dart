import 'dart:async';

import 'package:rxdart/rxdart.dart';

class StreamsTable<K, T> {
  final T? defaultValue;
  final _controllers = <K, BehaviorSubject<T>>{};

  StreamsTable({this.defaultValue});

  void clear() {
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }

  Stream<T> getStream(K id) {
    if (!_controllers.containsKey(id)) {
      if (defaultValue != null) {
        updateValue(id, defaultValue!);
      } else {
        throw StateError('Unknown id: $id');
      }
    }
    return _controllers[id]!.stream;
  }

  void updateValue(K id, T value) {
    if (!_controllers.containsKey(id)) {
      _controllers[id] = BehaviorSubject<T>();
    }
    _controllers[id]!.sink.add(value);
  }

  void removeItem(K id) {
    _controllers[id]?.close();
    _controllers.remove(id);
  }
}

class Table3D<I1, I2, I3, T> {
  final Map<I1, Map<I2, Map<I3, T>>> _data = {};

  T? get(I1 id1, I2 id2, I3 id3) {
    return _data[id1]?[id2]?[id3];
  }

  void set(I1 id1, I2 id2, I3 id3, T data) {
    if (!_data.containsKey(id1)) {
      _data[id1] = {};
    }

    if (!_data[id1]!.containsKey(id2)) {
      _data[id1]![id2] = {};
    }

    _data[id1]![id2]![id3] = data;
  }
}
