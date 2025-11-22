import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
// import 'package:open_filex/open_filex.dart';

Future<File> saveFile(String fileName, Uint8List bytes) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes);
  return file;
}
