part of 'validators.dart';

class CompositeValidator<T, R> extends Validator<T, R> {
  final List<Validator> validators;

  CompositeValidator(this.validators);

  @override
  R validate(T input) {
    Validator? lastValidator;
    dynamic value = input;

    for (final validator in validators) {
      if (lastValidator == null) {
        lastValidator = validator;
        assert(lastValidator.inputType == T, 'types mistmatch: ${lastValidator.inputType} != $T');
      } else {
        assert(
          validator.inputType == lastValidator.outputType,
          'types mistmatch: ${validator.inputType} != ${lastValidator.outputType}',
        );
      }
      value = validator.validate(value);
      lastValidator = validator;
    }

    assert(lastValidator!.outputType == R, 'types mistmatch: ${lastValidator.outputType} != $R');
    assert(value is R, 'returned value is not $R');

    return value as R;
  }
}
