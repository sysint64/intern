import 'package:flutter/foundation.dart';

T? createEnumFromString<T extends Object>(List<T> enumValues, String value) {
  final items = enumValues.where(
    (enumItem) => describeEnum(enumItem) == value,
  );
  if (items.isEmpty) {
    return null;
  } else {
    return items.first;
  }
}
