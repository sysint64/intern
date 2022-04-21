part of 'validators.dart';

class AlwaysInvalidValidator<T, R> extends Validator<T, R> {
  final I18nString message;

  AlwaysInvalidValidator(this.message);

  @override
  R validate(T input) {
    throw ValidationException(message);
  }
}
