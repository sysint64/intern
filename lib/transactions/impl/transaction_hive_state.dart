import 'package:hive/hive.dart';
import 'package:drivers/transactions/transaction_state_storage.dart';
import 'package:drivers/transactions/transaction_status_adapter.dart';
import 'package:drivers/transactions/transactions_manager.dart';

part 'transaction_hive_state.g.dart';

@HiveType(typeId: 1)
class TransactionHiveState extends HiveObject implements TransactionState {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  final String statusString;

  @override
  TransactionStatus get status => TransactionStatusAdapter().createFromString(statusString);

  TransactionHiveState(this.id, this.statusString);
}
