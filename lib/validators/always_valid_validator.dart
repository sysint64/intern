part of 'validators.dart';

class AlwaysValidValidator<T> extends Validator<T, T> {
  @override
  T validate(T input) => input;
}
