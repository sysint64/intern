part of 'validators.dart';

class MaskValidator extends Validator<String, String> {
  final MaskTextInputFormatter formatter;
  final I18nString message;

  MaskValidator({
    required this.formatter,
    required this.message,
  });

  @override
  String validate(String input) {
    final MaskTextInputFormatter _newFormatter = MaskTextInputFormatter(
      mask: formatter.getMask(),
      initialText: input,
    );

    if (!_newFormatter.isFill()) {
      throw ValidationException(message);
    }

    return input;
  }
}
