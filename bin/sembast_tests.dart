import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

void main() async {
  final dbPath = 'my_app_database.db';
  final db = await open(dbPath);
  await recordReadWriteDelete(db);
  await readWithDot(db);
}

Future<Database> open(String dbPath) async {
  final store = intMapStoreFactory.store('members');

  return await databaseFactoryIo.openDatabase(
    dbPath,
    version: 1, // Se não especificar nenhum valor, será 1.
    onVersionChanged: (db, oldVersion, newVersion) async {
      if (oldVersion == 0) {
        // Uma transaction adiciona vários dados com apenas uma escrita no banco.
        // Em caso de erro as alterações são revertidas
        await db.transaction((txn) async {
          await store.add(txn, {'name': 'John', 'age': 20});
          await store.add(txn, {'name': 'Mark', 'age': 35});
        });
      }
    },
  );
}

Future<void> recordReadWriteDelete(Database db) async {
  print('------ recordReadWriteDelete ---');

  var store = StoreRef<String, String>.main();

  // Com o record é possível especificar a key
  await store.record('title').put(db, 'sembast_test_app');

  var title = await store.record('title').get(db);
  print('title: $title');

  await store.record('title').delete(db);
  title = await store.record('title').get(db);
  print('title after delete: $title');

  print('\n');
}

Future<void> readWithDot(Database db) async {
  print('------ readWithDot ---');

  final store = intMapStoreFactory.store('cities');

  final key = await store.add(db, {
    'cityData': {
      'name': 'São Paulo',
      'country': 'Brasil',
    },
  });

  final record = await store.record(key).getSnapshot(db);
  final cityName = record?['cityData.name'];
  print('city name: $cityName');

  print('\n');
}
