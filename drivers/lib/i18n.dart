import 'package:flutter/material.dart';

abstract class I18nString {
  const I18nString();

  /// Translate string for the locale that in [context].
  String localize(BuildContext context);

  /// Translate a i18n string for the context and watch any changes.
  Stream<String> localizeAndWatch(BuildContext context);

  I18nString map(String Function(String) mapper) => TransformI18nString(this, mapper);

  I18nString toUpperCase() => map((it) => it.toUpperCase());

  I18nString toLowerCase() => map((it) => it.toLowerCase());
}

class RawStringLocalizable extends I18nString {
  final String value;

  const RawStringLocalizable(this.value);

  @override
  String localize([BuildContext? context]) {
    return value;
  }

  @override
  Stream<String> localizeAndWatch([BuildContext? context]) => Stream.value(value);

  @override
  String toString() {
    return value;
  }
}

class TransformI18nString extends I18nString {
  final String Function(String) transform;
  final I18nString text;

  const TransformI18nString(this.text, this.transform);

  @override
  String localize(BuildContext context) {
    return transform(text.localize(context));
  }

  @override
  Stream<String> localizeAndWatch(BuildContext context) {
    return text.localizeAndWatch(context).map(transform);
  }
}
