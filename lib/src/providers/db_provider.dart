import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pocketlist/src/models/List_model.dart';
import 'package:pocketlist/src/models/category_model.dart';
import 'package:pocketlist/src/models/product_model.dart';
export 'package:pocketlist/src/models/product_model.dart';

// Importaciones condicionales
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    if (kIsWeb) {
      return await _initDBWeb();
    } else {
      return await _initDBMobile();
    }
  }

  // Inicialización para WEB
  Future<Database> _initDBWeb() async {
    final factory = databaseFactoryFfiWeb;

    return await factory.openDatabase(
      'List.db',
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (Database db, int version) async {
          await _createTables(db);
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          await _migrateDB(db, oldVersion, newVersion);
        },
      ),
    );
  }

  // Inicialización para MOBILE
  Future<Database> _initDBMobile() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'List.db');

    return await openDatabase(
      dbPath,
      version: 2,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await _createTables(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await _migrateDB(db, oldVersion, newVersion);
      },
    );
  }

  // Método común para crear tablas (instalaciones nuevas)
  Future<void> _createTables(Database db) async {
    await db.execute('CREATE TABLE Lista ('
        'id TEXT PRIMARY KEY,'
        'title TEXT,'
        'superMaret TEXT,'
        'fecha TEXT,'
        'total REAL,'
        'buget REAL,'
        'diference REAL'
        ')');

    await db.execute('CREATE TABLE categories ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'name TEXT NOT NULL,'
        'icon TEXT'
        ')');

    await db.execute('CREATE TABLE product ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'name TEXT,'
        'quantity INTEGER,'
        'price REAL,'
        'listId TEXT,'
        'complete INTEGER,'
        'categoryId INTEGER,'
        'FOREIGN KEY(listId) REFERENCES Lista(id),'
        'FOREIGN KEY(categoryId) REFERENCES categories(id)'
        ')');
  }

  // Migraciones incrementales
  Future<void> _migrateDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // v1 → v2: añadir tabla categories y columna categoryId en product
      await db.execute('CREATE TABLE IF NOT EXISTS categories ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT NOT NULL,'
          'icon TEXT'
          ')');

      // Verificar si la columna ya existe antes de intentar añadirla
      final columnExists = await _columnExists(db, 'product', 'categoryId');
      if (!columnExists) {
        await db.execute('ALTER TABLE product ADD COLUMN categoryId INTEGER');
      }
    }
  }

  Future<bool> _columnExists(Database db, String table, String column) async {
    final List<Map<String, dynamic>> columns =
        await db.rawQuery('PRAGMA table_info($table)');
    return columns.any((element) => element['name'] == column);
  }

  // ─────────────────────────────────────────────
  // LISTA CRUD
  // ─────────────────────────────────────────────

  //Crear Registro
  nuevoLista(Lista nuevalista) async {
    final db = await database;
    final res = await db!.insert('Lista', nuevalista.toJson());
    return res;
  }

  ///GET ALL LIST
  Future<List<Lista>> getTodasLista() async {
    final db = await database;
    final res = await db!.query('Lista');

    List<Lista> list =
        res.isNotEmpty ? res.map((l) => Lista.fromJson(l)).toList() : [];
    return list;
  }

  ///GET PRODUCT BY LIST ID
  Future<Lista> getListId(String id) async {
    final db = await database;
    final res = await db!.query('Lista', where: 'id =?', whereArgs: [id]);
    Lista art =
        res.isNotEmpty ? res.map((e) => Lista.fromJson(e)).first : Lista();
    return art;
  }

  Future<List<Lista>> getListIds(String id) async {
    final db = await database;
    final res = await db!.query('Lista', where: 'id =?', whereArgs: [id]);
    List<Lista> list =
        res.isNotEmpty ? res.map((l) => Lista.fromJson(l)).toList() : [];
    return list;
  }

  ///DELETE LIST BY ID
  Future<int> deleteList(String id) async {
    final db = await database;
    // Primero eliminar productos de esa lista
    await db!.delete('product', where: 'listId = ?', whereArgs: [id]);
    // Luego eliminar la lista
    final res = await db.delete('Lista', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  ///DELETE LIST BY ID
  Future<int> deleteLista(String id) async {
    return await deleteList(id);
  }

  ///DELETE ALL LISTS
  Future<int> deleteAllList() async {
    final db = await database;
    final res = await db!.rawDelete('DELETE FROM Lista');
    return res;
  }

  ///EDIT LIST
  updateList(Lista prod) async {
    final db = await database;
    final res = await db!
        .update('Lista', prod.toJson(), where: 'id = ?', whereArgs: [prod.id]);
    return res;
  }

  // ─────────────────────────────────────────────
  // PRODUCT CRUD
  // ─────────────────────────────────────────────

  newProd(ProductModel productModel) async {
    final db = await database;
    final res = await db!.insert('product', productModel.toJson());
    return res;
  }

  tmpProd(ProductModel productModel) async {
    final db = await database;
    final res = await db!.insert('product', productModel.toJson());
    return res;
  }

  ///GET PRODUCTS WITH NO LIST ASSIGNED
  Future<List<ProductModel>> getArticlesTmp(String id) async {
    final db = await database;
    final res = await db!.query('product', where: 'listId=?', whereArgs: [id]);

    List<ProductModel> art =
        res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];
    return art;
  }

  ///GET ALL PRODUCTS
  Future<List<ProductModel>> getArticles() async {
    final db = await database;
    final res = await db!.query('product');
    List<ProductModel> art =
        res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];
    return art;
  }

  ///GET ALL PRODUCTS - ALIAS para compatibilidad con DataPage
  Future<List<ProductModel>> getAllProducts() async {
    return await getArticles();
  }

  ///GET PRODUCTS BY LIST ID
  Future<List<ProductModel>> getProdId(String id) async {
    final db = await database;
    final res = await db!.query('product', where: 'listId=?', whereArgs: [id]);
    List<ProductModel> art =
        res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];
    return art;
  }

  ///DELETE PRODUCT BY ID
  Future<int> deleteProd(int id) async {
    final db = await database;
    final res = await db!.delete('product', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  ///DELETE ALL PRODUCTS
  Future<int> deleteAllProd() async {
    final db = await database;
    final res = await db!.rawDelete('DELETE FROM product');
    return res;
  }

  ///DELETE ALL PRODUCTS THAT NO HAVE LIST ASSIGNED
  Future<int> deleteAllTempProd(String id) async {
    final db = await database;
    final res = await db!.delete('product', where: 'listId=?', whereArgs: [id]);
    return res;
  }

  ///DELETE ALL PRODUCTS BY LIST ID - Para cuando eliminas una lista
  Future<int> deleteAllProdByListId(String listId) async {
    final db = await database;
    final res =
        await db!.delete('product', where: 'listId = ?', whereArgs: [listId]);
    return res;
  }

  ///EDIT PRODUCTS
  updateProd(ProductModel prod) async {
    final db = await database;
    final res = await db!.update('product', prod.toJson(),
        where: 'id = ?', whereArgs: [prod.id]);
    return res;
  }

  // ─────────────────────────────────────────────
  // CATEGORY CRUD
  // ─────────────────────────────────────────────

  /// Obtener todas las categorías
  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final res = await db!.query('categories', orderBy: 'name ASC');
    return res.isNotEmpty
        ? res.map((e) => CategoryModel.fromJson(e)).toList()
        : [];
  }

  /// Insertar una categoría, devuelve el id generado
  Future<int> insertCategory(CategoryModel category) async {
    final db = await database;
    return await db!.insert('categories', category.toJson());
  }

  /// Actualizar el nombre/icono de una categoría existente
  Future<int> updateCategory(CategoryModel category) async {
    final db = await database;
    return await db!.update('categories', category.toJson(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  /// Eliminar una categoría; los productos asociados quedan con categoryId = NULL
  Future<int> deleteCategory(int id) async {
    final db = await database;
    // Desasociar productos antes de eliminar
    await db!.update(
      'product',
      {'categoryId': null},
      where: 'categoryId = ?',
      whereArgs: [id],
    );
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  /// Seed de categorías por defecto (solo para instalaciones nuevas)
  Future<void> seedDefaultCategories(List<Map<String, String>> defaults) async {
    final db = await database;
    final existing = await db!.query('categories');
    if (existing.isNotEmpty) return; // Solo seedear si está vacío

    for (final cat in defaults) {
      await db.insert('categories', {
        'name': cat['name']!,
        'icon': cat['icon']!,
      });
    }
  }
}
