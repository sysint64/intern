part of 'validators.dart';

class StringNotEmptyValidator extends Validator<String, String> {
  @override
  String validate(String? input) {
    if (input == null || input.isEmpty) {
      throw ValidationException(LocalizedString.fromString('Field is required'));
    }

    return input;
  }
}

class NonNullableValidator<T> extends Validator<T?, T> {
  @override
  T validate(T? input) {
    if (input == null) {
      throw ValidationException(LocalizedString.fromString('Field is required'));
    }

    return input;
  }
}
