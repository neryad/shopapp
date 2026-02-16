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
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/utils/utils.dart' as utils;
import 'package:pocketlist/src/utils/file_save_helper.dart';

class ExportHelper {
  static final prefs = PreferenciasUsuario();

  static Future<void> generateCsv(BuildContext context, String listId) async {
    String titleCsv, dateCsv, storeCsv, bugetCsv, totalCsv, difrenceCsv;
    String nameProdCsv, priceProdCsv, quantityProdCsv, statusProdCsv;
    String bought, notBought;
    String filePlaceHolder = '';
    String successMsgExport = '';
    String errorMsgExport = '';

    if (prefs.lnge == 'en') {
      filePlaceHolder = 'List imported from PocketList';
      dateCsv = 'Date';
      bugetCsv = 'Budget';
      bought = 'Bought';
      notBought = 'Not bought';
      storeCsv = 'Store';
      titleCsv = 'List name';
      difrenceCsv = 'Diference';
      totalCsv = 'Total';
      nameProdCsv = 'Name';
      priceProdCsv = 'Price';
      quantityProdCsv = 'Quantity';
      statusProdCsv = 'Status';
      successMsgExport = 'List exported successfully';
      errorMsgExport = 'An error occurred while trying to export the list';
    } else {
      filePlaceHolder = 'Lista importada desde PocketList';
      dateCsv = 'Fecha';
      titleCsv = 'Nombre lista';
      bugetCsv = 'Presupuesto';
      difrenceCsv = 'Diferencia';
      totalCsv = 'Total';
      bought = 'Comprado';
      notBought = 'No comprado';
      storeCsv = 'Tienda';
      nameProdCsv = 'Nombre';
      priceProdCsv = 'Precio';
      quantityProdCsv = 'Cantidad';
      statusProdCsv = 'Estatus';
      successMsgExport = 'Lista exportada correctamente';
      errorMsgExport = 'Sucedió un error al intentar exportar la lista';
    }

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
