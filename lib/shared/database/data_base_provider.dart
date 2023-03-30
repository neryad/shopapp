import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseProvider {
  static Database? _database;

  static final DataBaseProvider dataBase = DataBaseProvider._();

  DataBaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDataBase();

    return _database!;
  }

  initDataBase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'List.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE Lista ('
            'id TEXT PRIMARY KEY,'
            'title TEXT,'
            'superMaret TEXT,'
            'fecha TEXT,'
            'total REAL,'
            'buget REAL,'
            'diference REAL'
            ')');

        await db.execute('CREATE TABLE product ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'name TEXT,'
            'quantity INTERGER,'
            'price REAL,'
            'listId INTEGER,'
            'complete INTEGER,'
            'FOREIGN KEY(listId) REFERENCES Lista(id)'
            ')');
      },
    );
  }
}
