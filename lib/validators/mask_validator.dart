part of 'validators.dart';

class MaskValidator extends Validator<String, String> {
  final MaskTextInputFormatter formatter;

  MaskValidator(this.formatter);

  @override
  String validate(String input) {
    final MaskTextInputFormatter _newFormatter = MaskTextInputFormatter(
      mask: formatter.getMask(),
      initialText: input,
    );

    if (!_newFormatter.isFill()) {
      throw ValidationException(LocalizedString.fromString('Wrong format'));
    }

    return input /*!*/;
  }
}
