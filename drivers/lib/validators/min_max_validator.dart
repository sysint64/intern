part of 'validators.dart';

class IntMinMaxValidator extends Validator<int, int> {
  final int min;
  final int max;
  final I18nString message;

  IntMinMaxValidator({
    required this.min,
    required this.max,
    required this.message,
  });

  @override
  int validate(int input) {
    if (input < min || input > max) {
      throw ValidationException(message);
    }

    return input;
  }
}

class StringIntMinMaxValidator extends Validator<String, String> {
  final int min;
  final int max;
  final I18nString notIntegerMessage;
  final I18nString rangeMessage;

  StringIntMinMaxValidator({
    required this.min,
    required this.max,
    required this.notIntegerMessage,
    required this.rangeMessage,
  });

  @override
  String validate(String input) {
    final inputInt = int.tryParse(input);
    if (inputInt == null) {
      throw ValidationException(notIntegerMessage);
    }
    if (inputInt < min || inputInt > max) {
      throw ValidationException(rangeMessage);
    }

    return input;
  }
}

class DoubleMinMaxValidator extends Validator<double, double> {
  final double min;
  final double max;
  final I18nString message;

  DoubleMinMaxValidator({
    required this.min,
    required this.max,
    required this.message,
  });

  @override
  double validate(double input) {
    if (input < min || input > max) {
      throw ValidationException(message);
    }

    return input;
  }
}
