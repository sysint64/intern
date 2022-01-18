import 'package:drivers/exceptions.dart';
import 'package:email_validator/email_validator.dart' as email_validator;
import 'package:flutter/material.dart';
import 'package:localized_string/localized_string.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

part 'always_invalid_validator.dart';
part 'always_valid_validator.dart';
part 'composite_validator.dart';
part 'email_validator.dart';
part 'mask_validator.dart';
part 'min_max_validator.dart';
part 'not_empty_validator.dart';
part 'number_validator.dart';
part 'validator_adapter.dart';

abstract class Validator<T, R> {
  Type get outputType => R;

  Type get inputType => T;

  const Validator();

  R validate(T input);
}
