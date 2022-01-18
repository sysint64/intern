abstract class ErrorsReporter {
  Future<void> reportError(Object e, [StackTrace? st]);
}
