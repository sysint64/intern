import 'package:drivers/router/router.dart';

abstract class AppRoute<T> {
  Future<T> open(AppRouter router);
}
