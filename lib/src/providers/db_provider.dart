import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopapp/src/models/List_model.dart';
import 'package:shopapp/src/models/product_model.dart';
export 'package:shopapp/src/models/product_model.dart';
//import 'package:shopapp/src/models/suge.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'List.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
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

      // await db.execute('CREATE TABLE tmpProduct ('
      //     'id INTEGER PRIMARY KEY,'
      //     'name TEXT,'
      //     'quantity INTERGER,'
      //     'price REAL,'
      //     'listId TEXT,'
      //     'complete INTEGER,'
      //     'FOREIGN KEY(listId) REFERENCES Lista(id)'
      //     ')');

      // await db.execute('CREATE TABLE suge ('
      //     'id INTEGER PRIMARY KEY,'
      //     'name TEXT'
      //     ')');
    });
  }

  //Crear Registro
  nuevoLista(Lista nuevalista) async {
    final db = await database;

    final res = await db.insert('Lista', nuevalista.toJson());

    return res;
  }

  newProd(ProductModel productModel) async {
    final db = await database;

    final res = db.insert('product', productModel.toJson());

    return res;
  }

  // newProd(ProductModel productModel) async {
  //   final db = await database;

  //   final res = db.rawInsert(
  //       'INSERT Into product (id,name,quantity,price,listId,complete) '
  //       'VALUES ( ${productModel.id},${productModel.name},${productModel.quantity},${productModel.price},${productModel.listId},${productModel.complete})');

  //   return res;
  // }

  tmpProd(ProductModel productModel) async {
    final db = await database;
    //final res = db.insert('tmpProduct', productModel.toJson());
    final res = db.insert('product', productModel.toJson());

    return res;
  }

  // sugeInsert( Segurencia productModel  ) async {

  //   final db =  await database;

  //   final res = db.insert('suge', productModel.toJson());

  //   return res;
  // }
  //   Future <List<Segurencia>> sugeGet(String name) async {

  //     final db = await database;
  //    //final res = await db.query('suge', where: 'name=?',whereArgs: [name]);
  //     final res = await db.rawQuery("SELECT name FROM suge where name LIKE ?",[name] );
  //     //'SELECT * FROM product WHERE listId=?', [id]
  //     List<Segurencia> art = res.isNotEmpty ? res.map((e) => Segurencia.fromJson(e)).toList(): [];
  //     return art;
  // }

  //GET

  Future<List<ProductModel>> getarticulos(String id) async {
    final db = await database;
    //final res = await db.query('product');

    final res = await db.query('product', where: 'listId=?', whereArgs: [id]);

    List<ProductModel> art =
        res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];

    //List<ProductModel> art = res.isNotEmpty ? ProductModel.fromJson(res.first) : null;

    return art;
    // List<Lista> list = res.isNotEmpty ? res.map((l) => Lista.fromJson(l)).toList() : [];

    // return list;
  }

  Future<List<ProductModel>> getTmpArticulos() async {
    final db = await database;
    final res = await db.query('tmpProduct');

    // final res = await db.query('product', where: 'listId=?', whereArgs: [id]);

    List<ProductModel> art =
        res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];

    //List<ProductModel> art = res.isNotEmpty ? ProductModel.fromJson(res.first) : null;

    return art;
    // List<Lista> list = res.isNotEmpty ? res.map((l) => Lista.fromJson(l)).toList() : [];

    // return list;
  }

  Future<List<Lista>> getToadasLista() async {
    final db = await database;

    final res = await db.query('Lista');

    List<Lista> list =
        res.isNotEmpty ? res.map((l) => Lista.fromJson(l)).toList() : [];

    return list;
  }

  //Get by id

  Future<List<ProductModel>> getprodId(String id) async {
    final db = await database;
    //final res = await db.query('product', where: 'listId=?', whereArgs: [id]);
    final res = await db.rawQuery('SELECT * FROM product WHERE listId=?', [id]);
    //List<Map> result = await db.rawQuery('SELECT * FROM product WHERE listId=?', [id]);
    List<ProductModel> art =
        res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];
    return art;
  }

  //Delete

  Future<String> deleteLista(String id) async {
    final db = await database;

    final res = await db.delete('Lista', where: 'id = ?', whereArgs: [id]);

    return res.toString();
  }

  Future<int> deleteTmpProd(int id) async {
    final db = await database;

    final res = await db.delete('tmpProduct', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<int> deleteProd(int id) async {
    final db = await database;

    final res = await db.delete('product', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<int> deleteAllTempProd() async {
    final db = await database;

    final res = await db.rawDelete('Delete FROM tmpProduct');

    return res;
  }

  Future<int> deleteAllProd() async {
    final db = await database;

    final res = await db.rawDelete('Delete FROM product');

    return res;
  }

  Future<int> deleteAllList() async {
    final db = await database;

    final res = await db.rawDelete('Delete FROM Lista');

    return res;
  }

  //pdate
  updatetempProd(ProductModel prod) async {
    final db = await database;

    final res = await db.update('tmpProduct', prod.toJson(),
        where: 'id = ?', whereArgs: [prod.id]);

    return res;
  }

  updateProd(ProductModel prod) async {
    final db = await database;

    final res = await db.update('product', prod.toJson(),
        where: 'id = ?', whereArgs: [prod.id]);

    return res;
  }

  updatelist(Lista prod) async {
    final db = await database;

    final res = await db
        .update('Lista', prod.toJson(), where: 'id = ?', whereArgs: [prod.id]);

    return res;
  }
}
