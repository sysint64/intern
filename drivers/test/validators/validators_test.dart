import 'package:drivers/strings.dart';
import 'package:drivers/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('composite validator', () async {
    final validator = CompositeValidator<String, double>([
      StringIsDoubleValidator('Invalid number'.i18n()), // input: String, output: double
      DoubleMinMaxValidator(
        min: 0,
        max: 12,
        message: 'Invalid range'.i18n(),
      ), // input: double; output: double
    ]);

    final doubleValue = validator.validate('10.5');
    expect(doubleValue, 10.5);
  });
}
