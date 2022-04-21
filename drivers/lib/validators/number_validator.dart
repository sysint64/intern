part of 'validators.dart';

class StringIsDoubleValidator extends Validator<String, double> {
  final I18nString message;

  StringIsDoubleValidator(this.message);

  @override
  double validate(String input) {
    final value = double.tryParse(input);

    if (value == null) {
      throw ValidationException(message);
    }

    return value;
  }
}

class StringIsIntValidator extends Validator<String, int> {
  final I18nString message;

  StringIsIntValidator(this.message);

  @override
  int validate(String input) {
    final value = int.tryParse(input);

    if (value == null) {
      throw ValidationException(message);
    }

    return value;
  }
}

class NullableIntValidator extends Validator<String?, int?> {
  final I18nString message;

  NullableIntValidator(this.message);

  @override
  int? validate(String? input) {
    if (input == null) {
      return null;
    }

    final value = int.tryParse(input);

    if (value == null) {
      throw ValidationException(message);
    }

    return value;
  }
}
