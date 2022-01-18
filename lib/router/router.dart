import 'package:drivers/exceptions.dart';
import 'package:drivers/lifecycle.dart';
import 'package:drivers/log.dart';
import 'package:drivers/router/path.dart';
import 'package:drivers/router/route.dart';
import 'package:drivers/state_version.dart';
import 'package:flutter/material.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class AppRouter with StateVersion {
  var _currentPath = RouterPath.empty();
  RouterPath? _lastValidPath;
  // Uri? _initialUri;

  final _lifecycleRegistrators = <RouteLifecycleRegistrator>[];

  RouterPath get currentPath => _currentPath;

  AppRouter({bool bootstrapDeepLinking = true}) {
    // _initUniLinks();
    _initLifecycle();
  }

  void _initLifecycle() {
    version.listen((event) {
      for (final registrator in _lifecycleRegistrators) {
        var isValid = false;

        for (final segment in getLifecycleSegments()) {
          isValid = isValid || registrator.isValidRouteSegment(segment);
        }

        if (isValid) {
          registrator.register();
        } else {
          registrator.unregister();
        }
      }
    });
  }

  Iterable<RouterPathConfiguration> getLifecycleSegments() => currentPath.segments;

  void registerLifecycle(RouteLifecycleRegistrator registrator) {
    _lifecycleRegistrators.add(registrator);
    updateStateVersion();
  }

  RouterPath configuration(Uri uri);

  List<Page<dynamic>> generatePages();

  /// Returns true if successfully opened.
  bool openDeeplink(String uri, {bool showUnknownPageOnError = true}) {
    return openUri(Uri.parse(uri));
  }

  /// Returns true if successfully opened.
  bool openUri(Uri uri, {bool showUnknownPageOnError = true}) {
    try {
      log('ROUTE', 'open deeplink: $uri');
      final path = configuration(uri);
      _currentPath = path;
      _lastValidPath = path;
      updateStateVersion();
      return true;
    } on ValidationException catch (_) {
      if (showUnknownPageOnError) {
        _currentPath = RouterPath([UnknownRoutePath()]);
        updateStateVersion();
      }

      return false;
    }
  }

  RouterPath validatePath(RouterPath path) => configuration(Uri.parse(path.location));

  void openPathSegments(Iterable<RouterPathConfiguration> path) {
    final resPath = RouterPath(path);

    try {
      validatePath(resPath);
      _currentPath = resPath;
      _lastValidPath = resPath;
      log('router', 'open path: $resPath');
      updateStateVersion();
    } on ValidationException catch (_) {
      logError('router', 'unknown path: $resPath');
      _currentPath = RouterPath([UnknownRoutePath()]);
      updateStateVersion();
    }
  }

  void pushPath(Iterable<RouterPathConfiguration> path) {
    openPathSegments([..._currentPath.segments, ...path]);
  }

  void pushPathSegment(RouterPathConfiguration path) {
    openPathSegments([..._currentPath.segments, path]);
  }

  Future<bool> openHttpUrl({
    required String url,
    required bool isBlank,
    bool forceSafariVC = true,
    bool forceWebView = true,
  }) async {
    await Future<void>.delayed(
      Duration(milliseconds: _currentPath.canPop() ? 0 : 100),
    );

    if (await canLaunch(url)) {
      return launch(
        url,
        forceSafariVC: forceSafariVC,
        forceWebView: forceWebView,
        webOnlyWindowName: isBlank ? '_blank' : '_self',
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void pop<T extends Object>([T? result]) {
    // _navigator.pop(result);
    //to avoid black screen after pop calling
    // if (_historyObserver.isHistoryEmpty) SystemNavigator.pop();
    if (_currentPath.isUnknown() && _lastValidPath != null) {
      _currentPath = _lastValidPath!;
      _lastValidPath = null;
    } else {
      _currentPath.pop(result);
    }
    updateStateVersion();
  }

  bool onPopPage(dynamic result) {
    updateStateVersion();

    if (_currentPath.isUnknown() && _lastValidPath != null) {
      _currentPath = _lastValidPath!;
      _lastValidPath = null;
      return true;
    } else {
      final isPopped = _currentPath.pop<dynamic>(result);
      log('setPath', _currentPath);
      return isPopped;
    }
  }

  // Future<void> _initUniLinks() async {
  //   try {
  //     _initialUri = await getInitialUri();
  //     if (_initialUri != null) log('Deep link', _initialUri);
  //   } catch (e, stackTrace) {
  //     logError(
  //       'Deep link',
  //       e.toString(),
  //       e: e,
  //       st: stackTrace,
  //     );
  //   }

  //   uriLinkStream.listen(
  //     (Uri? uri) {
  //       if (uri != null) {
  //         openUri(uri);
  //       }
  //     },
  //     onError: (Object e, StackTrace stackTrace) {
  //       logError(
  //         'Deep link',
  //         e.toString(),
  //         e: e,
  //         st: stackTrace,
  //       );
  //     },
  //   );
  // }

  Future<T> open<T>(AppRoute<T> path) {
    return path.open(this);
  }
}
