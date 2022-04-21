import 'package:config/config_spec.dart';

class DebugInfo {
  final String version;
  final String buildNumber;
  final String packageName;
  final String os;
  final String osVersion;
  final ConfigSpec config;
  final ConfigSpec features;

  DebugInfo({
    required this.version,
    required this.buildNumber,
    required this.packageName,
    required this.os,
    required this.osVersion,
    required this.config,
    required this.features,
  });
}
