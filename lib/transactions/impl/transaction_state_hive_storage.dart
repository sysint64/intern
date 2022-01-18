import 'package:hive/hive.dart';
import 'package:drivers/transactions/impl/transaction_hive_state.dart';
import 'package:drivers/transactions/transaction_status_adapter.dart';
import 'package:drivers/transactions/transactions_manager.dart';

import '../transaction_state_storage.dart';

class TransactionStateHiveStorage implements TransactionStateStorage {
  final _statusAdapter = TransactionStatusAdapter();

  @override
  Future<List<TransactionState>> loadState() async {
    final box = await Hive.openBox<TransactionHiveState>('transactions');
    return box.values.toList();
  }

  @override
  Future<void> updateStatus(String id, TransactionStatus status) async {
    final box = await Hive.openBox<TransactionHiveState>('transactions');
    await box.put(
      id,
      TransactionHiveState(id, _statusAdapter.createString(status)),
    );
  }

  @override
  Future<void> delete(String id) async {
    final box = await Hive.openBox<TransactionHiveState>('transactions');
    await box.delete(id);
  }
}
