import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart' as csv_pkg;
import 'package:share_plus/share_plus.dart';
import 'package:pocketlist/src/models/List_model.dart';
import 'package:pocketlist/src/models/product_model.dart';
import 'package:pocketlist/src/providers/db_provider.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:pocketlist/src/utils/file_save_helper.dart';

class ExportHelper {
  static String _sanitizeFilename(String name) {
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').trim();
  }

  static Future<void> generateCsv(BuildContext context, String listId) async {
    final filePlaceHolder = getTranslated(context, 'csvFilePlaceholder');
    final dateCsv = getTranslated(context, 'csvDate');
    final bugetCsv = getTranslated(context, 'csvBudget');
    final bought = getTranslated(context, 'csvBought');
    final notBought = getTranslated(context, 'csvNotBought');
    final storeCsv = getTranslated(context, 'csvStore');
    final titleCsv = getTranslated(context, 'csvListName');
    final difrenceCsv = getTranslated(context, 'csvDifference');
    final totalCsv = getTranslated(context, 'csvTotal');
    final nameProdCsv = getTranslated(context, 'csvName');
    final priceProdCsv = getTranslated(context, 'csvPrice');
    final quantityProdCsv = getTranslated(context, 'csvQuantity');
    final statusProdCsv = getTranslated(context, 'csvStatus');
    final successMsgExport = getTranslated(context, 'csvExportSuccess');
    final errorMsgExport = getTranslated(context, 'csvExportError');

    try {
      List<Lista> lista = await DBProvider.db.getListIds(listId);
      List<ProductModel> productModel = await DBProvider.db.getProdId(listId);

      if (lista.isEmpty) return;

      List<List<String>> csvData = [
        <String>[titleCsv, dateCsv, storeCsv, bugetCsv, totalCsv, difrenceCsv],
        ...lista.map((e) => [
              e.title,
              e.fecha,
              e.superMaret,
              e.buget.toString(),
              e.total.toString(),
              e.diference.toString()
            ]),
        // headers
        <String>[nameProdCsv, priceProdCsv, quantityProdCsv, statusProdCsv],
        // data
        ...productModel.map((item) => [
              item.name,
              item.price.toString(),
              item.quantity.toString(),
              item.complete == 1 ? bought : notBought
            ]),
      ];

      String csvString = csv_pkg.CsvCodec().encode(csvData);

      if (kIsWeb) {
        // Web: Download CSV
        final bytes = utf8.encode(csvString);
        await saveFile('${_sanitizeFilename(csvData[1][0])}.csv', Uint8List.fromList(bytes));
        if (successMsgExport.isNotEmpty)
          utils.showSnack(context, successMsgExport);
        return;
      }

      var fileName = _sanitizeFilename(csvData[1][0]);
      Directory? dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationSupportDirectory();
      String appDocPath = dir!.path;

      final File file =
          File(appDocPath + Platform.pathSeparator + fileName + '.csv');

      await file.writeAsString(csvString);

      await Share.shareXFiles([XFile(file.path)], text: filePlaceHolder);
    } catch (e) {
      utils.showSnack(context, '$errorMsgExport');
    }
  }
}
