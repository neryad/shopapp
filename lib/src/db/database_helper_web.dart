import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDBWeb() async {
  var factory = databaseFactoryFfiWeb;
  var db = await factory.openDatabase('List.db');
  return db;
}
