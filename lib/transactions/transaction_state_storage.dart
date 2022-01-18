import 'transactions_manager.dart';

abstract class TransactionState {
  String get id;

  TransactionStatus get status;
}

abstract class TransactionStateStorage {
  Future<List<TransactionState>> loadState();

  Future<void> updateStatus(String id, TransactionStatus status);

  Future<void> delete(String id);
}
