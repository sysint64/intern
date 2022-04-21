enum TransactionExecutionStatus {
  checkpoint,
  finished,
}

abstract class Transaction {
  String get id;

  String get name;

  Future<void> backupState();

  Future<void> restoreStateFromBackup();

  Future<void> clearBackupState();

  Future<void> cancel();

  Stream<TransactionExecutionStatus> execute([Object? action]);

  Future<void> failed();
}
