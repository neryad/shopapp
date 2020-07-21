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
          'fecha TEXT,'
          'total REAL'
          ')');

        await db.execute(

          'CREATE TABLE product ('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'quantity INTERGER,'
          'price REAL,'
          'listId INTEGER,'
           'complete INTEGER,'
          'FOREIGN KEY(listId) REFERENCES Lista(id)'
          ')');

          await db.execute(

          'CREATE TABLE tmpProduct ('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'quantity INTERGER,'
          'price REAL,'
          'listId INTEGER,'
          'complete INTEGER,'
          'FOREIGN KEY(listId) REFERENCES Lista(id)'
          ')');
        
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

    tmpProd( ProductModel productModel  ) async {

    final db =  await database;

    final res = db.insert('tmpProduct', productModel.toJson());

    return res;
  }


    //GET

     Future <List<ProductModel>> getarticulos() async {

      final db = await database;
       final res = await db.query('product');

     // final res = await db.query('product', where: 'listId=?', whereArgs: [id]);
      
       List<ProductModel> art = res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList(): [];


       //List<ProductModel> art = res.isNotEmpty ? ProductModel.fromJson(res.first) : null;

        return art;
      // List<Lista> list = res.isNotEmpty ? res.map((l) => Lista.fromJson(l)).toList() : [];

      // return list;
    }

      Future <List<ProductModel>> getTmpArticulos() async {

      final db = await database;
       final res = await db.query('tmpProduct');

     // final res = await db.query('product', where: 'listId=?', whereArgs: [id]);
      
       List<ProductModel> art = res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList(): [];


       //List<ProductModel> art = res.isNotEmpty ? ProductModel.fromJson(res.first) : null;

        return art;
      // List<Lista> list = res.isNotEmpty ? res.map((l) => Lista.fromJson(l)).toList() : [];

      // return list;
    }

    Future <List<Lista>> getToadasLista() async {

      final db = await database;

      final res = await db.query('Lista');

      List<Lista> list = res.isNotEmpty ? res.map((l) => Lista.fromJson(l)).toList() : [];

      return list;
    }

    //Delete

    Future<int> deleteLista(int id ) async {

      final db =  await database;

      final res = await db.delete('Lista', where: 'id = ?', whereArgs: [id]);

      return res;
    }

      Future<int> deleteTmpProd(int id ) async {

      final db =  await database;

      final res = await db.delete('tmpProduct', where: 'id = ?', whereArgs: [id]);

      return res;
    }

       Future<int> deleteAllTempProd() async {

      final db =  await database;


      final res = await db.rawDelete('Delete FROM tmpProduct');

      return res;
    }




}