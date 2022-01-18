part of 'validators.dart';

class ValidatorAdapter {
  static String? Function(String?) toTextFormValidator(
    BuildContext context,
    Validator<String?, dynamic> Function() validator,
  ) {
    return (String? input) {
      if (input?.isEmpty == true) {
        input = null;
      }
      try {
        validator().validate(input);
        return null;
      } on ValidationException catch (e) {
        return e.localizedMessage.localize(context);
      }
    };
  }
}
