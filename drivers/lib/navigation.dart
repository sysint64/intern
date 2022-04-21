bool isNavigationSuccessResult<T>(T value) => value != null && value is bool && value;

T? getNavigationResult<T, R>(R value) {
  if (value != null && value is T) {
    return value as T;
  } else {
    return null;
  }
}
