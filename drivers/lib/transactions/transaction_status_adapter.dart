import 'package:drivers/transactions/transactions_manager.dart';

class TransactionStatusAdapter {
  TransactionStatus createFromString(String status) {
    switch (status) {
      case 'awaiting':
        return TransactionStatus.awaiting;
      case 'cancelled':
        return TransactionStatus.cancelled;
      case 'failed':
        return TransactionStatus.failed;
      case 'success':
        return TransactionStatus.success;
      case 'removed':
        return TransactionStatus.removed;
    }

    throw StateError('Unknown status: $status');
  }

  String createString(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.awaiting:
        return 'awaiting';
      case TransactionStatus.cancelled:
        return 'cancelled';
      case TransactionStatus.failed:
        return 'failed';
      case TransactionStatus.success:
        return 'success';
      case TransactionStatus.removed:
        return 'removed';
    }
  }
}
