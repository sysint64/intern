import 'package:drivers/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('composite validator', () async {
    final validator = CompositeValidator<String, double>([
      StringIsDoubleValidator(), // input: String, output: double
      DoubleMinMaxValidator(0, 12), // input: double; output: double
    ]);

    final doubleValue = validator.validate('10.5');
    expect(doubleValue, 10.5);
  });
}
