import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

void main() async {
  final dbPath = 'my_app_database.db';
  migration(dbPath);
}

void migration(String dbPath) async {
  final store = intMapStoreFactory.store('members');

  await databaseFactoryIo.openDatabase(
    dbPath,
    version: 1, // Se não especificar nenhum valor, será 1.
    onVersionChanged: (db, oldVersion, newVersion) async {
      if (oldVersion == 0) {
        await store.add(db, {'name': 'John', 'age': 20});
        await store.add(db, {'name': 'Mark', 'age': 35});
      }
    },
  );
}
