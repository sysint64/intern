part of 'validators.dart';

class IntMinMaxValidator extends Validator<int, int> {
  final int min;
  final int max;

  IntMinMaxValidator(this.min, this.max);

  @override
  int validate(int input) {
    if (input < min || input > max) {
      throw ValidationException(
        LocalizedString.fromString('Number not in the range: $min - $max'),
      );
    }

    return input;
  }
}

class DoubleMinMaxValidator extends Validator<double, double> {
  final double min;
  final double max;

  DoubleMinMaxValidator(this.min, this.max);

  @override
  double validate(double input) {
    if (input < min || input > max) {
      throw ValidationException(
        LocalizedString.fromString('Number not in the range: $min - $max'),
      );
    }

    return input;
  }
}
