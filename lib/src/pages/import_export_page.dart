import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/models/List_model.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/pages/list_page.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'details_page.dart';

final prefs = new PreferenciasUsuario();

class ImportExportPage extends StatefulWidget {
  ImportExportPage({Key key}) : super(key: key);

  @override
  _ImportExportPageState createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  Lista listaModel = new Lista();
  List articulos = [];
  String filePlaceHolder,
      titleCsv,
      dateCsv,
      storeCsv,
      bugetCsv,
      totalCsv,
      difrenceCsv,
      bought,
      nameProdCsv,
      priceProdCsv,
      quantityProdCsv,
      statusProdCsv,
      notBought,
      errorMsgImport,
      successMsgImport,
      errorMsgExport,
      successMsgExport,
      succestitle,
      strExport,
      strImported;
  var uuid = Uuid();
  var _paths;
  var employeeData;
  String _extension = "csv";
  FileType _pickingType = FileType.custom;
  @override
  Widget build(BuildContext context) {
    if (prefs.lnge == 'en') {
      filePlaceHolder = 'List imported from PocketList';
      dateCsv = 'Date';
      bugetCsv = 'Budget';
      bought = 'Bought';
      notBought = 'Not bought';
      storeCsv = 'Store';
      titleCsv = 'List name';
      bugetCsv = 'Buget';
      difrenceCsv = 'Diference';
      totalCsv = 'Total';
      nameProdCsv = 'Name';
      priceProdCsv = 'Price';
      quantityProdCsv = 'Quantity';
      statusProdCsv = 'Status';
      errorMsgImport = 'An error occurred while trying to import the list';
      successMsgImport = 'List imported successfully';
      errorMsgExport = 'An error occurred while trying to export the list';
      errorMsgExport = 'List exported successfully';
      strExport = 'Export';
      strImported = 'Import';
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
      errorMsgImport = 'Sucedió un error al intentar importar la lista';
      successMsgImport = 'Lista importada correctamente';
      errorMsgExport = 'Sucedió un error al intentar exportar la lista';
      successMsgExport = 'Lista exportada correctamente';
      strExport = 'Exportar';
      strImported = 'Importar';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Import / Export listas'),
        backgroundColor: utils.cambiarColor(),
        actions: [
          TextButton(
              onPressed: () async {
                // saveList(lista.id);
                // _openFileExplorer();
                //openFile(_paths);
                pickFile();
              },
              child: Icon(
                Icons.arrow_circle_down,
                color: Colors.white,
              )),
        ],
      ),
      body: (_listView(context)),
    );
  }

  _listView(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: FutureBuilder<List<Lista>>(
        future: DBProvider.db.getToadasLista(),
        builder: (context, AsyncSnapshot<List<Lista>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data;

          if (lista.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      getTranlated(context, 'msgImporExporlist'),
                      style: TextStyle(
                        color: (prefs.color == 5)
                            ? Colors.white
                            : utils.cambiarColor(),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          lista.sort((a, b) => b.title.compareTo(a.title));
          return ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DetailsPage(savelist: lista[index]));
                      Navigator.of(context).push(route);
                    },
                    child: card(lista[index]));
              });
        },
      ),
    );
  }

  Widget card(Lista list) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(list.title),
              ],
            ),
            Expanded(child: Container()),
            Column(
              children: [
                Row(children: [
                  TextButton(
                      onPressed: () {
                        _generateCsv(context, list.id);
                        //_openFileExplorer();
                      },
                      child: Icon(Icons.arrow_circle_up_sharp,
                          color: Colors.cyan[600])),
                ]),
              ],
            ),
          ],
        ),
        // Divider(),
      ],
    );
  }

  Future<void> _generateCsv(context, String id) async {
    try {
      List<Lista> lista = await DBProvider.db.getListIds(id);
      List<ProductModel> productModel = await DBProvider.db.getProdId(id);

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

      String csv = const ListToCsvConverter().convert(csvData);

      DateTime now = new DateTime.now();

      var fileName = csvData[1][0];
      // Directory dir = await getExternalStorageDirectory();
      Directory dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationSupportDirectory();
      String appDocPath = dir.path;

      final File file =
          File(appDocPath + Platform.pathSeparator + fileName + '.csv');

      await file.writeAsString(csv);

      await Share.shareFiles([file.path], text: filePlaceHolder);
      showMsg(context, successMsgExport, strExport);
    } catch (e) {
      showMsg(context, '$errorMsgExport', strExport);
    }
  }

  pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path);
      final input = new File(file.path).openRead();

      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      await saveList(context, fields);
      setState(() {});
    }
  }

  saveList(BuildContext context, List<dynamic> importedList) async {
    try {
      String lisId = uuid.v4();
      final listaImportada = Lista(
          id: lisId,
          title: importedList[1][0],
          superMaret: importedList[1][2],
          fecha: importedList[1][1],
          total: importedList[1][4],
          diference: importedList[1][5],
          buget: importedList[1][3]);

      await DBProvider.db.nuevoLista(listaImportada);
      ProductModel productModel = new ProductModel();

      var importedItems =
          importedList.getRange(2, importedList.length).toList();
      var finalItems = importedItems.getRange(1, importedItems.length).toList();

      for (var item in finalItems) {
        var index = finalItems.indexOf(item);

        var tet = ProductModel(
            name: finalItems[index][0],
            price: finalItems[index][1],
            quantity: finalItems[index][2],
            complete: (finalItems[index][3] == bought) ? 1 : 0,
            listId: listaImportada.id);
        await DBProvider.db.newProd(tet);
        showMsg(context, successMsgImport, strImported);
      }
    } catch (e) {
      showMsg(context, errorMsgImport, strImported);
    }
  }

  void showMsg(BuildContext context, String msg, String title) {
    Flushbar(
      title: title,
      titleText: Text(title,
          style: TextStyle(
            color: (prefs.color == 5) ? Colors.white : utils.cambiarColor(),
          )),
      message: msg,
      messageText: Text(msg,
          style: TextStyle(
            color: Colors.white,
          )),
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.white,
      ),
      leftBarIndicatorColor:
          (prefs.color == 5) ? Colors.white : utils.cambiarColor(),
      duration: Duration(seconds: 3),
    )..show(context);

    //////////
    // Flushbar(
    //   title: "Hey Ninja", //ignored since titleText != null
    //   message:
    //       "Lorem Ipsum is simply dummy text of the printing and typesetting industry", //ignored since messageText != null
    //   titleText: Text(
    //     "Hello Hero",
    //   ),
    //   messageText: Text(
    //     "You killed that giant monster in the city. Congratulations!",
    //   ),
    // )..show(context);
  }
}
