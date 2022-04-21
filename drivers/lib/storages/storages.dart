abstract class Storage<T> {
  Future<T> read(String id);

  Future<Iterable<T>> readAll();

  Future<void> write(String id, T item);

  Future<void> delete(String id);

  Future<void> deleteAll();

  Future<void> backup(String id);

  Future<void> restoreFromBackup(String id);

  Future<void> deleteBackup(String id);

  Future<void> backupAll();

  Future<void> restoreAllFromBackup();

  Future<void> deleteAllBackups();
}

abstract class SingleStorage<T> {
  Future<T> read();

  Future<T> readBackup();

  Future<void> write(T item);

  Future<void> backup();

  Future<void> restoreFromBackup();

  Future<void> deleteBackup();

  Future<void> delete();

  Future<bool> contains();
}

abstract class SinglePatchableStorage<T, K> {
  Future<T> read();

  Future<void> write(T item);

  Future<void> patch(K key, Object value);

  Future<void> backup();

  Future<void> restoreFromBackup();

  Future<void> deleteBackup();

  Future<void> delete();
}

class StorageObjectNotFound implements Exception {
  final String? message;

  StorageObjectNotFound([this.message]);
}
