part of 'validators.dart';

class StringIsDoubleValidator extends Validator<String, double> {
  @override
  double validate(String input) {
    final value = double.tryParse(input);

    if (value == null) {
      throw ValidationException(LocalizedString.fromString('Invalid number'));
    }

    return value;
  }
}

class StringIsIntValidator extends Validator<String, int> {
  @override
  int validate(String input) {
    final value = int.tryParse(input);

    if (value == null) {
      throw ValidationException(LocalizedString.fromString('Invalid number'));
    }

    return value;
  }
}

class NullableIntValidator extends Validator<String?, int?> {
  @override
  int? validate(String? input) {
    if (input == null) {
      return null;
    }

    final value = int.tryParse(input);

    if (value == null) {
      throw ValidationException(LocalizedString.fromString('Invalid number'));
    }

    return value;
  }
}
