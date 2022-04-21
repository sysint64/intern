part of 'validators.dart';

class StringNotEmptyValidator extends Validator<String, String> {
  final I18nString message;

  StringNotEmptyValidator(this.message);

  @override
  String validate(String? input) {
    if (input == null || input.isEmpty) {
      throw ValidationException(message);
    }

    return input;
  }
}

class NullableStringNotEmptyValidator extends Validator<String?, String?> {
  final I18nString message;

  NullableStringNotEmptyValidator(this.message);

  @override
  String? validate(String? input) {
    if (input == null) {
      return null;
    }

    if (input.isEmpty) {
      throw ValidationException(message);
    }

    return input;
  }
}

class NonNullableValidator<T> extends Validator<T?, T> {
  final I18nString message;

  NonNullableValidator(this.message);

  @override
  T validate(T? input) {
    if (input == null) {
      throw ValidationException(message);
    }

    return input;
  }
}
