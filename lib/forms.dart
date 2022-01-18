/// Example
/// class MyForm extends FormDescriptor {
///   final name = FormFieldDescriptor<String, String>(
///     input: '',
///     validator: StringNotEmptyValidator(),
///   );
///   final address = FormFieldDescriptor<String, String>(
///     input: '',
///     validator: StringNotEmptyValidator(),
///   );
///
///   @override
///   List<FormFieldDescriptor> get fields => [name, address];
///
///   @override
///   void disposeLifecycle() {}
///
///   @override
///   void initLifecycle() {}
/// }
import 'package:drivers/dependencies.dart';
import 'package:drivers/exceptions.dart';
import 'package:drivers/validators/validators.dart';
import 'package:flutter/material.dart';

typedef FormFieldPredicate<T extends FormDescriptor> = bool Function(T values);

abstract class FormDescriptor implements Lifecycle {
  List<FormFieldDescriptor> get fields;

  void validate() {
    for (final field in fields.reversed) {
      try {
        field.validator.validate(field.input);
      } on ValidationException catch (_) {
        field.focusNode.requestFocus();
        break;
      }
    }
  }
}

class FormFieldDescriptor<I, T> {
  final Validator<I, T> validator;
  final focusNode = FocusNode();
  I input;

  FormFieldDescriptor({
    required this.validator,
    required this.input,
  });

  T get value => validator.validate(input);
}
