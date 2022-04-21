import 'package:drivers/lifecycle.dart';

abstract class UpdateConfigValuePagePresenter implements Lifecycle {
  Future<String> getUpdatingConfigValue(String key);

  Future<String> getUpdatingConfigName(String key);

  Future<void> updateConfigFieldValue(String key, String value);
}
