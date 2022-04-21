import 'package:debug_services/router/configurations.dart';
import 'package:drivers/router/route.dart';
import 'package:drivers/router/router.dart';

class UpdateConfigValuePath extends AppRoute<bool> {
  final String envKey;
  final String? value;

  UpdateConfigValuePath(this.envKey, this.value);

  @override
  Future<bool> open(AppRouter router) async {
    final path = UpdateConfigValuePathConfiguration(envKey, value ?? '');
    router.pushPathSegment(path);
    return path.waitResult();
  }
}

class DebugServicesPath extends AppRoute<void> {
  @override
  Future<void> open(AppRouter router) async {
    router.pushPathSegment(DebugServicesPathConfiguration());
  }
}
