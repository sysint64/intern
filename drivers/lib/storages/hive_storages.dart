import 'package:hive/hive.dart';

import 'storages.dart';

abstract class StringHiveSingleStorage<T> implements SingleStorage<T> {
  String get boxName;

  @override
  Future<void> write(T item) async {
    final box = await Hive.openBox<String>(boxName);
    await writeData(box, '', item);
  }

  @override
  Future<T> read() async {
    final box = await Hive.openBox<String>(boxName);
    return readData(box, '');
  }

  @override
  Future<void> delete() async {
    final box = await Hive.openBox<String>(boxName);
    await box.deleteFromDisk();
  }

  @override
  Future<void> backup() async {
    final box = await Hive.openBox<String>(boxName);
    final config = await readData(box, '');
    await writeData(box, 'backup', config);
  }

  @override
  Future<void> restoreFromBackup() async {
    final box = await Hive.openBox<String>(boxName);
    final config = await readData(box, 'backup');
    await writeData(box, '', config);
  }

  @override
  Future<void> deleteBackup() async {
    final box = await Hive.openBox<String>(boxName);
    await deleteData(box, 'backup');
  }

  @override
  Future<T> readBackup() async {
    final box = await Hive.openBox<String>(boxName);
    return readData(box, 'backup');
  }

  Future<void> writeData(Box<String> box, String prefix, T data);

  Future<T> readData(Box<String> box, String prefix);

  Future<void> deleteData(Box<String> box, String prefix);
}
