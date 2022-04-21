import 'dart:async';

import 'package:drivers/async.dart';
import 'package:drivers/transactions/transaction.dart';
import 'package:drivers/transactions/transaction_state_storage.dart';
import 'package:drivers/transactions/transactions_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transaction_manager_test.mocks.dart';

class TestTransactionState implements TransactionState {
  @override
  final String id;

  @override
  final TransactionStatus status;

  TestTransactionState(this.id, this.status);
}

Stream<TransactionExecutionStatus> _heavyTask() async* {
  for (int i = 0; i < 100; i++) {
    await delay(100);
    yield TransactionExecutionStatus.checkpoint;
  }

  yield TransactionExecutionStatus.finished;
}

Stream<TransactionExecutionStatus> _emptyTask() async* {
  yield TransactionExecutionStatus.finished;
}

Stream<TransactionExecutionStatus> _failedTask() async* {
  yield TransactionExecutionStatus.checkpoint;
  throw AssertionError('Oh no!');
}

@GenerateMocks([Transaction, TransactionStateStorage, TransactionFactory])
void main() {
  test('test cancel', () async {
    final transactionStateStorage = MockTransactionStateStorage();
    final transactionFactory = MockTransactionFactory();
    final transactionsManger = TransactionsManager(
      transactionStateStorage,
      transactionFactory,
    );
    final transaction = MockTransaction();
    final completer = Completer<dynamic>();

    when(transaction.id).thenReturn('HT');
    when(transaction.name).thenReturn('Heavy Transaction');
    when(transaction.execute()).thenAnswer((_) => _heavyTask());
    when(transaction.cancel()).thenAnswer((_) => Future.value());
    when(transaction.backupState()).thenAnswer((_) => Future.value());
    when(transaction.clearBackupState()).thenAnswer((_) => Future.value());
    when(transaction.restoreStateFromBackup()).thenAnswer((_) => Future.value());

    // ignore: unawaited_futures
    transactionsManger.executeTransaction(transaction).then(
      (value) {
        completer.completeError(AssertionError());
      },
    ).catchError(
      (Object e) {
        if (e is TransactionCancelled) {
          completer.complete();
        } else {
          completer.completeError(AssertionError());
        }
      },
    );
    await delay(300);
    await transactionsManger.cancelTransaction(transaction);
    await completer.future;

    verify(transaction.backupState());
    verify(transaction.execute());
    verify(transaction.cancel());
    verify(transaction.restoreStateFromBackup());
    verify(transaction.clearBackupState());
    verify(
      transactionStateStorage.updateStatus(
        'HT',
        TransactionStatus.awaiting,
      ),
    );
    verify(
      transactionStateStorage.updateStatus(
        'HT',
        TransactionStatus.cancelled,
      ),
    );
    verify(transactionStateStorage.delete('HT'));
    verifyNoMoreInteractions(transactionStateStorage);
  });

  test('test success', () async {
    final transactionStateStorage = MockTransactionStateStorage();
    final transactionFactory = MockTransactionFactory();
    final transactionsManger = TransactionsManager(
      transactionStateStorage,
      transactionFactory,
    );
    final transaction = MockTransaction();

    when(transaction.id).thenReturn('ET');
    when(transaction.name).thenReturn('Empty Transaction');
    when(transaction.execute()).thenAnswer((_) => _emptyTask());
    when(transaction.cancel()).thenAnswer((_) => Future.value());
    when(transaction.backupState()).thenAnswer((_) => Future.value());
    when(transaction.clearBackupState()).thenAnswer((_) => Future.value());
    when(transaction.restoreStateFromBackup()).thenAnswer((_) => Future.value());

    await transactionsManger.executeTransaction(transaction);

    verify(transaction.backupState());
    verify(transaction.execute());
    verify(transaction.clearBackupState());

    verifyNever(transaction.cancel());
    verifyNever(transaction.restoreStateFromBackup());

    verify(
      transactionStateStorage.updateStatus(
        'ET',
        TransactionStatus.awaiting,
      ),
    );
    verify(
      transactionStateStorage.updateStatus(
        'ET',
        TransactionStatus.success,
      ),
    );

    verifyNoMoreInteractions(transactionStateStorage);
  });

  test('test failed', () async {
    final transactionStateStorage = MockTransactionStateStorage();
    final transactionFactory = MockTransactionFactory();
    final transactionsManger = TransactionsManager(
      transactionStateStorage,
      transactionFactory,
    );
    final transaction = MockTransaction();

    when(transaction.id).thenReturn('FT');
    when(transaction.name).thenReturn('Fail Transaction');
    when(transaction.execute()).thenAnswer((_) => _failedTask());
    when(transaction.cancel()).thenAnswer((_) => Future.value());
    when(transaction.failed()).thenAnswer((_) => Future.value());
    when(transaction.backupState()).thenAnswer((_) => Future.value());
    when(transaction.clearBackupState()).thenAnswer((_) => Future.value());
    when(transaction.restoreStateFromBackup()).thenAnswer((_) => Future.value());

    try {
      await transactionsManger.executeTransaction(transaction);
    } catch (_) {
      // Ignore
    }

    verify(transaction.backupState());
    verify(transaction.execute());
    verify(transaction.failed());
    verifyNever(transaction.cancel());
    verify(transaction.restoreStateFromBackup());
    verify(transaction.clearBackupState());

    verify(
      transactionStateStorage.updateStatus(
        'FT',
        TransactionStatus.awaiting,
      ),
    );
    verify(
      transactionStateStorage.updateStatus(
        'FT',
        TransactionStatus.failed,
      ),
    );
    verify(transactionStateStorage.delete('FT'));
    verifyNoMoreInteractions(transactionStateStorage);
  });

  test('test recoveyState', () async {
    final transactionStateStorage = MockTransactionStateStorage();
    final transactionFactory = MockTransactionFactory();
    final transactionsManger = TransactionsManager(
      transactionStateStorage,
      transactionFactory,
    );
    final t1 = MockTransaction();

    when(t1.id).thenReturn('T1');
    when(t1.name).thenReturn('Test transaction #1');
    when(t1.execute()).thenAnswer((_) => const Stream.empty());
    when(t1.backupState()).thenAnswer((_) => Future.value());
    when(t1.clearBackupState()).thenAnswer((_) => Future.value());
    when(t1.restoreStateFromBackup()).thenAnswer((_) => Future.value());

    final t2 = MockTransaction();

    when(t2.id).thenReturn('T2');
    when(t2.name).thenReturn('Test transaction #2');
    when(t2.execute()).thenAnswer((_) => const Stream.empty());
    when(t2.backupState()).thenAnswer((_) => Future.value());
    when(t2.clearBackupState()).thenAnswer((_) => Future.value());
    when(t2.restoreStateFromBackup()).thenAnswer((_) => Future.value());

    when(transactionStateStorage.loadState()).thenAnswer(
      (_) => Future.value(
        <TransactionState>[
          TestTransactionState('T1', TransactionStatus.failed),
          TestTransactionState('T2', TransactionStatus.failed),
        ],
      ),
    );

    when(transactionFactory.createTransactionById('T1')).thenAnswer((_) => Future.value(t1));

    when(transactionFactory.createTransactionById('T2')).thenAnswer((_) => Future.value(t2));

    await transactionsManger.recoveryState();

    verify(t1.restoreStateFromBackup());
    verify(t1.clearBackupState());
    verify(t1.id);
    verify(t1.name);
    verifyNoMoreInteractions(t1);

    verify(t2.restoreStateFromBackup());
    verify(t2.clearBackupState());
    verify(t2.id);
    verify(t2.name);
    verifyNoMoreInteractions(t2);

    verify(transactionStateStorage.loadState());
    verify(transactionStateStorage.delete('T1'));
    verify(transactionStateStorage.delete('T2'));
    verifyNoMoreInteractions(transactionStateStorage);
  });

  test('test recoveyState - clear success and removed transactions', () async {
    final transactionStateStorage = MockTransactionStateStorage();
    final transactionFactory = MockTransactionFactory();
    final transactionsManger = TransactionsManager(
      transactionStateStorage,
      transactionFactory,
    );
    final t1 = MockTransaction();

    when(t1.id).thenReturn('T1');
    when(t1.name).thenReturn('Test transaction #1');
    when(t1.execute()).thenAnswer((_) => const Stream.empty());
    when(t1.backupState()).thenAnswer((_) => Future.value());
    when(t1.clearBackupState()).thenAnswer((_) => Future.value());
    when(t1.restoreStateFromBackup()).thenAnswer((_) => Future.value());

    final t2 = MockTransaction();

    when(t2.id).thenReturn('T2');
    when(t2.name).thenReturn('Test transaction #2');
    when(t2.execute()).thenAnswer((_) => const Stream.empty());
    when(t2.backupState()).thenAnswer((_) => Future.value());
    when(t2.clearBackupState()).thenAnswer((_) => Future.value());
    when(t2.restoreStateFromBackup()).thenAnswer((_) => Future.value());

    when(transactionStateStorage.loadState()).thenAnswer(
      (_) => Future.value(
        <TransactionState>[
          TestTransactionState('T1', TransactionStatus.removed),
          TestTransactionState('T2', TransactionStatus.success),
        ],
      ),
    );

    when(transactionFactory.createTransactionById('T1')).thenAnswer((_) => Future.value(t1));

    when(transactionFactory.createTransactionById('T2')).thenAnswer((_) => Future.value(t2));

    await transactionsManger.recoveryState();

    verify(t1.clearBackupState());
    verify(t1.id);
    verify(t1.name);
    verifyNoMoreInteractions(t1);

    verify(t2.clearBackupState());
    verify(t2.id);
    verify(t2.name);
    verifyNoMoreInteractions(t2);

    verify(transactionStateStorage.loadState());
    verify(transactionStateStorage.delete('T1'));
    verify(transactionStateStorage.delete('T2'));
    verifyNoMoreInteractions(transactionStateStorage);
  });
}
