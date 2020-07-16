import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopapp/src/models/List_model.dart';
import 'package:shopapp/src/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {


  static Database _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future <Database>get database async {

    if (_database != null ) return  _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'List.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {

        await db.execute(

          'CREATE TABLE Lista ('
          'id INTEGER PRIMARY KEY,'
          'title TEXT,'
          'superMaret TEXT,'
          'fecha TEXT'
          ')');

        await db.execute(

          'CREATE TABLE product ('
          'id INTERGER PRIMARY KEY,'
          'name TEXT,'
          'quantity INTERGER,'
          'price REAL,'
          'listId INTEGER,'
          'FOREIGN KEY(listId) REFERENCES Lista(id)'
          ')'


        );
        
      }
    );


  }

  //Crear Registro
  nuevoLista( Lista nuevalista ) async {

    final db =  await database;

    final res = await db.insert('Lista', nuevalista.toJson());

    return res;
  }

    newProd( ProductModel productModel  ) async {

    final db =  await database;

    final res = db.insert('product', productModel.toJson());

    return res;
  }

}