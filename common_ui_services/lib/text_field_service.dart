import 'package:drivers/lifecycle.dart';

abstract class TextFieldUIService implements Lifecycle {
  void clearValue();

  void clearError();

  void error();

  void updateValue(String value);

  String value();
}
