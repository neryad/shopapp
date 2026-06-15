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
  static Future<void> generateCsv(BuildContext context, String listId) async {
    final filePlaceHolder = getTranlated(context, 'csvFilePlaceholder');
    final dateCsv = getTranlated(context, 'csvDate');
    final bugetCsv = getTranlated(context, 'csvBudget');
    final bought = getTranlated(context, 'csvBought');
    final notBought = getTranlated(context, 'csvNotBought');
    final storeCsv = getTranlated(context, 'csvStore');
    final titleCsv = getTranlated(context, 'csvListName');
    final difrenceCsv = getTranlated(context, 'csvDifference');
    final totalCsv = getTranlated(context, 'csvTotal');
    final nameProdCsv = getTranlated(context, 'csvName');
    final priceProdCsv = getTranlated(context, 'csvPrice');
    final quantityProdCsv = getTranlated(context, 'csvQuantity');
    final statusProdCsv = getTranlated(context, 'csvStatus');
    final successMsgExport = getTranlated(context, 'csvExportSuccess');
    final errorMsgExport = getTranlated(context, 'csvExportError');

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
        await saveFile('${csvData[1][0]}.csv', Uint8List.fromList(bytes));
        if (successMsgExport.isNotEmpty)
          utils.showSnack(context, successMsgExport);
        return;
      }

      var fileName = csvData[1][0];
      Directory? dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationSupportDirectory();
      String appDocPath = dir!.path;

      final File file =
          File(appDocPath + Platform.pathSeparator + fileName + '.csv');

      await file.writeAsString(csvString);

      await Share.shareXFiles([XFile(file.path)], text: filePlaceHolder);
      // utils.showSnack(context, successMsgExport);
    } catch (e) {
      utils.showSnack(context, '$errorMsgExport');
    }
  }
}
