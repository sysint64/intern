part of 'validators.dart';

class EmailValidator extends Validator<String, String> {
  @override
  String validate(String input) {
    if (!email_validator.EmailValidator.validate(input)) {
      throw ValidationException(LocalizedString.fromString('Invalid email'));
    }

    return input;
  }
}
