import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/models/List_model.dart';
import 'package:PocketList/src/models/csv_data.dart';
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
  var uuid = Uuid();
  var _paths;
  var employeeData;
  String _extension = "csv";
  FileType _pickingType = FileType.custom;
  @override
  Widget build(BuildContext context) {
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
      body: (Container(
        child: _listView(context),
      )),
    );
  }

  _listView(BuildContext context) {
    return Container(
      key: UniqueKey(),
      height: MediaQuery.of(context).size.height * .6,
      child: FutureBuilder<List<Lista>>(
        future: DBProvider.db.getToadasLista(),
        builder: (context, AsyncSnapshot<List<Lista>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data;

          //TODO : Cambiar mensaje
          if (lista.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    getTranlated(context, 'noList'),
                    style: TextStyle(
                      color: (prefs.color == 5)
                          ? Colors.white
                          : utils.cambiarColor(),
                      fontSize: 18,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: " ",
                        ),
                        WidgetSpan(
                          child: Icon(Icons.add_shopping_cart),
                        ),
                        TextSpan(
                          text: " ",
                        ),
                        TextSpan(
                          text: getTranlated(context, 'noList2'),
                          style: TextStyle(
                            color: (prefs.color == 5)
                                ? Colors.white
                                : utils.cambiarColor(),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
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
    List<Lista> lista = await DBProvider.db.getListIds(id);
    List<ProductModel> productModel = await DBProvider.db.getProdId(id);
    // final loco = lista.addAll(productModel.toList());
    List<List<String>> csvData = [
      //tittlos
      <String>[
        'Titulo',
        'fecha',
        'Supermecado',
        'Presuspuesto',
        'total',
        'diferencia'
      ],
      ...lista.map((e) => [
            e.title,
            e.fecha,
            e.superMaret,
            e.buget.toString(),
            e.total.toString(),
            e.diference.toString()
          ]),
      // headers
      <String>['Name', 'compeltado', 'cantidad', 'Comprado'],
      // data
      ...productModel.map((item) => [
            item.name,
            item.price.toString(),
            item.quantity.toString(),
            item.complete.toString()
          ]),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    DateTime now = new DateTime.now();
    var fecha = '${now.day}/${now.month}/${now.year}';
    var filename = csvData[1][0];
    //TODO: Cambiar nombre de archivo
    // final String dir = (await getExternalStorageDirectory()).path;
    final String dir = '/storage/emulated/0/Download';
    final String path = '$dir/$filename.csv';

    final File file = File(path);
    await file.writeAsString(csv);
  }

  pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    //TODO: fix de la pantalla que se corta
    // TODO: flusbar en caso psotivo y negtivo al agregar archivo
    if (result != null) {
      File file = File(result.files.single.path);
      final input = new File(file.path).openRead();

      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      await saveList(fields);
    }
  }

  saveList(List<dynamic> importedList) async {
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

    var importedItems = importedList.getRange(2, importedList.length).toList();
    var finalItems = importedItems.getRange(1, importedItems.length).toList();

    for (var item in finalItems) {
      var index = finalItems.indexOf(item);

      var tet = ProductModel(
          name: finalItems[index][0],
          price: finalItems[index][1],
          quantity: finalItems[index][2],
          complete: finalItems[index][3],
          listId: listaImportada.id);
      await DBProvider.db.newProd(tet);
    }
  }
}
