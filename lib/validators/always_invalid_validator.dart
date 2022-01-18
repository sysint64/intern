part of 'validators.dart';

class AlwaysInvalidValidator<T, R> extends Validator<T, R> {
  final LocalizedString message;

  AlwaysInvalidValidator({required this.message});

  @override
  R validate(T input) {
    throw ValidationException(message);
  }
}
