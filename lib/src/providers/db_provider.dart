import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:PocketList/src/models/List_model.dart';
import 'package:PocketList/src/models/product_model.dart';
export 'package:PocketList/src/models/product_model.dart';
//import 'package:PocketList/src/models/suge.dart';
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

  tmpProd(ProductModel productModel) async {
    final db = await database;
    //final res = db.insert('tmpProduct', productModel.toJson());
    final res = db.insert('product', productModel.toJson());

    return res;
  }

  ///GET PRODUCTS WITH NO LIST ASSIGENDE
  Future<List<ProductModel>> getArticlesTmp(String id) async {
    final db = await database;
    final res = await db.query('product', where: 'listId=?', whereArgs: [id]);

    List<ProductModel> art =
        res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];
    return art;
  }

  ///GET ALL PRODUSCTS
  Future<List<ProductModel>> getArticles() async {
    final db = await database;
    final res = await db.query('product');
    List<ProductModel> art =
        res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];
    return art;
  }

  ///GET ALL LIST
  Future<List<Lista>> getToadasLista() async {
    final db = await database;

    final res = await db.query('Lista');

    List<Lista> list =
        res.isNotEmpty ? res.map((l) => Lista.fromJson(l)).toList() : [];
    return list;
  }

  ///GET PRODUCST BY LIST ID
  Future<List<ProductModel>> getProdId(String id) async {
    final db = await database;
    final res = await db.query('product', where: 'listId=?', whereArgs: [id]);
    List<ProductModel> art =
        res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];
    return art;
  }

  ///DELETE LIST BY ID
  Future<String> deleteLista(String id) async {
    final db = await database;

    final res = await db.delete('Lista', where: 'id = ?', whereArgs: [id]);

    return res.toString();
  }

  ///DELETE PRODUCST BY LIST ID
  Future<int> deleteProd(int id) async {
    final db = await database;

    final res = await db.delete('product', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  ///DELETE ALL PRODUCTS
  Future<int> deleteAllProd() async {
    final db = await database;

    final res = await db.rawDelete('Delete FROM product');

    return res;
  }

  ///DELETE ALL PRODUCTS THAT NO HAVE LIST ASSOGNEDE
  Future<int> deleteAllTempProd(String id) async {
    final db = await database;
    final res = await db.delete('product', where: 'listId=?', whereArgs: [id]);

    return res;
  }

  ///DELETE ALL LIST
  Future<int> deleteAllList() async {
    final db = await database;

    final res = await db.rawDelete('Delete FROM Lista');

    return res;
  }

  ///EDIT PRODUCTS
  updateProd(ProductModel prod) async {
    final db = await database;

    final res = await db.update('product', prod.toJson(),
        where: 'id = ?', whereArgs: [prod.id]);

    return res;
  }

  ///EDIT LIST
  updateList(Lista prod) async {
    final db = await database;

    final res = await db
        .update('Lista', prod.toJson(), where: 'id = ?', whereArgs: [prod.id]);

    return res;
  }
  //TODO: esto es para la futura sugerencia
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
}
