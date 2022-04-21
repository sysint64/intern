import 'package:drivers/log.dart';
import 'package:drivers/router/path.dart';
import 'package:drivers/router/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppRouteInformationParser extends RouteInformationParser<RouterPath> {
  final AppRouter router;

  AppRouteInformationParser(this.router);

  @override
  Future<RouterPath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    return router.configuration(uri);
  }

  @override
  RouteInformation? restoreRouteInformation(RouterPath configuration) {
    return RouteInformation(location: configuration.location);
  }
}

class AppRouterDelegate extends RouterDelegate<RouterPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppRouter router;
  final RouterPath? initialRoute;

  AppRouterDelegate({
    required this.router,
    required this.navigatorKey,
    this.initialRoute,
  }) {
    router.navigatorKey = navigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWidget(
      navigatorKey: navigatorKey,
      onUpdate: notifyListeners,
      router: router,
    );
  }

  @override
  Future<void> setInitialRoutePath(RouterPath configuration) {
    return setNewRoutePath(initialRoute ?? configuration);
  }

  @override
  Future<void> setNewRoutePath(RouterPath configuration) {
    Log.info('set route path', configuration);
    router.openPathSegments(configuration.segments);
    return SynchronousFuture(null);
  }

  @override
  Future<bool> popRoute() async {
    if (!await super.popRoute()) {
      return router.navigatorPop(null);
    } else {
      return true;
    }
  }

  @override
  RouterPath? get currentConfiguration => router.currentPath;
}

class AppNavigatorWidget extends StatefulWidget {
  final VoidCallback onUpdate;
  final GlobalKey<NavigatorState> navigatorKey;
  final AppRouter router;

  const AppNavigatorWidget({
    Key? key,
    required this.router,
    required this.onUpdate,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  _AppNavigatorWidgetState createState() => _AppNavigatorWidgetState();
}

class _AppNavigatorWidgetState extends State<AppNavigatorWidget> {
  @override
  void initState() {
    widget.router.version.listen((_) {
      widget.onUpdate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      pages: widget.router.generatePages(),
      observers: [HeroController()],
      onPopPage: (route, dynamic result) {
        return route.didPop(result) && widget.router.onPopPage(result);
      },
    );
  }
}
