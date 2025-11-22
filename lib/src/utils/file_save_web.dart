import 'dart:html' as html;
import 'dart:typed_data';

Future<dynamic> saveFile(String fileName, Uint8List bytes) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
  return null;
}
