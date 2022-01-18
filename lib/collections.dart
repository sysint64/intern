Map<L, R> cloneMapAndRemove<L, R>(Map<L, R> source, L key) {
  return {}
    ..addAll(source)
    ..remove(key);
}

Map<L, R> cloneMapAndAdd<L, R>(Map<L, R> source, L key, R value) {
  return {key: value}..addAll(source);
}

Map<L, R> cloneMapAndUpdate<L, R>(Map<L, R> source, L key, R value) {
  return {}
    ..addAll(source)
    ..remove(key)
    ..addAll({key: value});
}

List<T> cloneListAndReplace<T>(
  List<T> source,
  bool Function(T element) test,
  T newElement,
) {
  if (source.where(test).isEmpty) {
    return source;
  }

  final item = source.firstWhere(test);
  final index = source.indexOf(item);
  final newList = <T>[];

  newList.addAll(source);
  newList[index] = newElement;

  return newList;
}

List<T> cloneListAndReplaceIterable<T>(
  List<T> source,
  bool Function(T a, T b) test,
  List<T> newElements,
) {
  final newList = <T>[];

  for (final item in source) {
    for (final newItem in newElements) {
      if (test(item, newItem)) {
        newList.add(newItem);
      } else {
        newList.add(item);
      }
    }
  }

  return newList;
}

List<T> cloneListAndReplaceMap<T>(
  List<T> source,
  bool Function(T a) test,
  T Function(T item) mapper,
) {
  final newList = <T>[];

  for (final item in source) {
    if (test(item)) {
      newList.add(mapper(item));
    } else {
      newList.add(item);
    }
  }

  return newList;
}

List<T> cloneListAndSwap<T>(
  List<T> source,
  int oldIndex,
  int newIndex,
) {
  final newList = <T>[];
  newList.addAll(source);
  newList.removeAt(oldIndex);
  newList.insert(newIndex, source[oldIndex]);

  return newList;
}
