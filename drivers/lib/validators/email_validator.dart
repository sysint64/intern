part of 'validators.dart';

class EmailValidator extends Validator<String, String> {
  final I18nString message;

  EmailValidator(this.message);

  @override
  String validate(String input) {
    if (!email_validator.EmailValidator.validate(input)) {
      throw ValidationException(message);
    }

    return input;
  }
}
