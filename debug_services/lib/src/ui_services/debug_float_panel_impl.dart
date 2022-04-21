import 'dart:async';

import 'package:debug_services/router/configurations.dart';
import 'package:debug_services/router/routes.dart';
import 'package:debug_services/ui_services/debug_float_panel.dart';
import 'package:debug_services/widgets.dart';
import 'package:drivers/async.dart';
import 'package:drivers/router/router.dart';
import 'package:flutter/widgets.dart';
import 'package:overlay_support/overlay_support.dart';

class DebugFloatPanelServiceImpl implements DebugFloatPanelService {
  OverlaySupportEntry? _overlayEntry;
  bool _flipped = false;
  bool _isEnabled = false;
  final AppRouter _router;
  late final StreamSubscription<int> _stateVersionSubscription;

  DebugFloatPanelServiceImpl(this._router);

  // ignore: avoid_positional_boolean_parameters
  @override
  Future<void> setEnabled(bool isEnabled) async {
    _isEnabled = isEnabled;
    if (!_isEnabled) {
      await hideDebugPanel();
    }
  }

  @override
  void initLifecycle() {
    _stateVersionSubscription = _router.version.listen((_) {
      final isDebugServicesOpened =
          _router.currentPath.contains<DebugServicesRouteScopeLifecycle>();

      if ((isDebugServicesOpened && _overlayEntry != null) || !_isEnabled) {
        hideDebugPanel();
      } else if (!isDebugServicesOpened && _overlayEntry == null) {
        showDebugPanel();
      }
    });
  }

  @override
  void disposeLifecycle() {
    _stateVersionSubscription.cancel();
    _overlayEntry?.dismiss(animate: true);
    _overlayEntry = null;
  }

  @override
  Future<void> hideDebugPanel() async {
    _overlayEntry?.dismiss(animate: true);
    _overlayEntry = null;
  }

  int c = 0;

  @override
  Future<void> showDebugPanel() async {
    if (!_isEnabled) {
      return hideDebugPanel();
    }

    _overlayEntry?.dismiss(animate: true);
    _overlayEntry = showOverlay(
      (context, progress) {
        final mediaQuery = MediaQuery.of(context);
        final viewHeight = mediaQuery.size.height - mediaQuery.viewInsets.bottom;

        return Positioned(
          left: _flipped ? -32 * (1 - progress) : null,
          right: !_flipped ? -32 * (1 - progress) : null,
          top: viewHeight / 2 - mediaQuery.padding.top,
          child: DebugServicePanelWidget(
            onPressed: () => _router.open(DebugServicesPath()),
            onFlip: () async {
              await hideDebugPanel();
              await delay(300);
              _flipped = !_flipped;
              await showDebugPanel();
            },
          ),
        );
      },
      duration: Duration.zero,
    );
  }
}
