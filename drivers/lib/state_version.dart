import 'dart:async';

import 'package:drivers/log.dart';

mixin StateVersion {
  int _stateVersion = 0;
  final _stateVersionController = StreamController<int>.broadcast()..add(0);

  Stream<int> get version => _stateVersionController.stream;

  void updateStateVersion() {
    _stateVersion += 1;
    if (!_stateVersion.isFinite) {
      _stateVersion = 0;
    }
    _stateVersionController.add(_stateVersion);
    Log.debug('update version', _stateVersion);
  }
}
