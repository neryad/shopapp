import 'dart:io';

import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/models/List_model.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;

final prefs = new PreferenciasUsuario();
String datePdf,
    bugetPdf,
    quatiyPdf,
    namePdf,
    pricePdf,
    toalQaPdf,
    statusPdf,
    bought,
    notBought;

class ApiPdf {
  static Future<File> generateTAble(String id) async {
//or your textFieldController.text
    if ((prefs.lnge) == 'en') {
      datePdf = 'Date:';
      bugetPdf = 'Budget:';
      quatiyPdf = 'Quantity';
      statusPdf = 'Status';
      namePdf = 'Name';
      pricePdf = 'Price';
      toalQaPdf = 'Total quantity';
      bought = 'Bought';
      notBought = 'Not bought';
    } else {
      datePdf = 'Fecha:';
      bugetPdf = 'Presupuesto:';
      quatiyPdf = 'Cantidad';
      statusPdf = 'Estado';
      namePdf = 'Nombre';
      pricePdf = 'Precio';
      toalQaPdf = 'Total cantidad';
      bought = 'Comprado';
      notBought = 'No comprado';
    }
    final pdf = Document();

    final listData = await DBProvider.db.getListId(id);

    final data = await DBProvider.db.getProdId(id);
    data.sort((a, b) => a.name.compareTo(b.name));
    pdf.addPage(MultiPage(
        build: (context) => [
              buildTitle(listData),
              buildSubTitle(listData),
              Divider(),
              buildTable(data, context),
              //buildTotal(listData),
              Divider()
            ]));

    return saveDocument(name: 'Pocketlist', pdf: pdf);
  }

  static Future<File> saveDocument({String name, Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.pdf');
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Widget buildTitle(Lista list) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(list.title, style: TextStyle(fontSize: 24)),
      //Divider(),
      //SizedBox(height: 0.8 * PdfPageFormat.cm),
      Text(list.superMaret),
      //SizedBox(height: 0.8 * PdfPageFormat.cm),
    ]);
  }

  static Widget buildTable(List<ProductModel> products, context) {
    final headers = [namePdf, pricePdf, quatiyPdf, statusPdf, toalQaPdf];

    final filterData = products.map((e) {
      final total = e.price * e.quantity;
      return [
        e.name,
        e.price,
        e.quantity,
        e.complete == 1 ? bought : notBought,
        total
      ];
    }).toList();
    return Table.fromTextArray(
        data: filterData,
        headers: headers,
        headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight
        });
  }

  static Widget buildSubTitle(Lista list) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    datePdf,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    bugetPdf,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    list.fecha,
                  ),
                  Text('\$  ${utils.numberFormat(list.buget)}'),
                  Text(
                    '\$  ${utils.numberFormat(list.total)}',
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  static Widget buildTotal(Lista list) {
    return Container(
        alignment: Alignment.centerRight,
        child: Row(children: [
          Spacer(flex: 6),
          Expanded(
              flex: 4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 200,
                        child: Row(children: [
                          Expanded(
                              child: Text(
                                  'Total : \$  ${utils.numberFormat(list.total)}')),
                          SizedBox(height: 2 * PdfPageFormat.mm),
                          Container(height: 1, color: PdfColors.grey400),
                          SizedBox(height: 0.5 * PdfPageFormat.mm),
                          Container(height: 1, color: PdfColors.grey400),
                        ]))
                  ]))
        ]));
  }
}
