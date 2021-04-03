import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/models/List_model.dart';
import 'package:PocketList/src/pages/details_page.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:share_extend/share_extend.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

final pdf = pw.Document();

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final prefs = new PreferenciasUsuario();
  @override
  void initState() {
    prefs.ultimaPagina = 'home';
    super.initState();
    //deleteFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              utils.saludos(context),
              _imagen(),
              _listContainer(context)
            ],
          ),
        ),
      ),
    );
  }

  _listContainer(BuildContext context) {
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

          if (lista.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    getTranlated(context, 'noList'),
                    style: TextStyle(
                      color: utils.cambiarColor(),
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
                            color: utils.cambiarColor(),
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
          lista.sort((a, b) => b.fecha.compareTo(a.fecha));
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: lista.length,
              itemBuilder: (context, i) {
                return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.red,
                        child: Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Text(
                                getTranlated(context, 'delete'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    key: Key(lista[i].title + lista.length.toString()),
                    onDismissed: (direction) {
                      utils.showSnack(
                          context, getTranlated(context, 'deletedList'));
                      DBProvider.db.deleteLista(lista[i].id);
                      lista.removeAt(i);
                      setState(() {});
                    },
                    child: card(lista[i])

                    //_card(lista[i]),
                    );
              });
        },
      ),
    );
  }

  Widget _imagen() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          utils.cambiarHomeImage(),
        ],
      ),
    );
  }

  Widget card(Lista lista) {
    return Card(
      elevation: 8,
      child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            // color: Color(0xFFF5F7FB),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                          backgroundColor: Color(0xFFF5F7FB),
                          child: Icon(
                            Icons.shopping_bag_sharp,
                            color: utils.cambiarColor(),
                          ))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        Text(
                          lista.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Row(children: [
                        Text(
                          lista.superMaret,
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ])
                    ],
                  ),

                  Column(
                    children: [
                      Row(children: [
                        Text(
                          '\$  ${utils.numberFormat(lista.total)}',
                          style: TextStyle(
                            color: utils.cambiarColor(),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ])
                    ],
                  ),

                  // Column(),
                ],
              ),
              // Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () async {
                        String name = getRandomString(5);

                        await writeOnPdf(context, lista.id, name);
                        Future.delayed(Duration(seconds: 15), () {
                          deleteFile(name);
                        });
                      },
                      child: Icon(Icons.share)),
                  TextButton(
                      onPressed: () {
                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DetailsPage(savelist: lista));
                        Navigator.of(context).push(route);
                      },
                      child: Icon(Icons.edit, color: Colors.yellow[600])),
                  TextButton(
                      onPressed: () {
                        utils.showSnack(
                            context, getTranlated(context, 'deletedList'));
                        DBProvider.db.deleteLista(lista.id);
                        // TODO : revisar el flushbR
                        //lista.removeAt(i);
                        setState(() {});
                      },
                      child: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red[500],
                      ))
                ],
              )
            ],
          )),
    );
  }

  // Widget _card(Lista lista) {
  //   return GestureDetector(
  //     onTap: () {
  //       var route = new MaterialPageRoute(
  //           builder: (BuildContext context) => DetailsPage(savelist: lista));
  //       Navigator.of(context).push(route);
  //     },
  //     child: Container(
  //       height: 100.00,
  //       child: Card(
  //         elevation: 10.0,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: <Widget>[
  //             Row(
  //               children: [
  //                 Icon(Icons.shopping_basket, color: utils.cambiarColor()),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     Text(lista.title),
  //                     Text(lista.superMaret,
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                         )),
  //                   ],
  //                 ),
  //                 Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Text(lista.fecha),
  //                       Text(
  //                         utils.numberFormat(lista.total),
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       )
  //                     ]),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 new FlatButton.icon(
  //                   // Un icono puede recibir muchos atributos, aqui solo usaremos icono, tamaño y color
  //                   icon: const Icon(Icons.delete_forever_sharp,
  //                       color: Colors.red),
  //                   label: const Text('Like'),
  //                   // Esto mostrara 'Me encanta' por la terminal
  //                   onPressed: () {
  //                     print('Me encanta');
  //                   },
  //                 ),
  //                 new FlatButton.icon(
  //                   icon: const Icon(Icons.edit, color: Colors.yellow),
  //                   label: const Text('Comment'),
  //                   onPressed: () {
  //                     print('Comenta algo');
  //                   },
  //                 ),
  //                 new FlatButton.icon(
  //                   icon: const Icon(Icons.share, color: Colors.blueAccent),
  //                   label: const Text('Share'),
  //                   onPressed: () {
  //                     print('Compartelo');
  //                   },
  //                 )
  //               ],
  //             ),
  //             // Icon(Icons.shopping_basket, color: utils.cambiarColor()),
  //             // Column(
  //             //   mainAxisAlignment: MainAxisAlignment.center,
  //             //   children: <Widget>[
  //             //     Text(lista.title),
  //             //     Text(lista.superMaret,
  //             //         style: TextStyle(
  //             //           fontWeight: FontWeight.bold,
  //             //         )),
  //             //   ],
  //             // ),
  //             // Column(
  //             //     mainAxisAlignment: MainAxisAlignment.center,
  //             //     children: <Widget>[
  //             //       Text(lista.fecha),
  //             //       Text(
  //             //         utils.numberFormat(lista.total),
  //             //         style: TextStyle(
  //             //           fontWeight: FontWeight.bold,
  //             //         ),
  //             //       )
  //             //     ]),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  String getRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  writeOnPdf(BuildContext context, String id, String name) async {
    final titles = ['Name', 'Price', 'Quantity'];
    final data = await DBProvider.db.getProdId(id);
    final filterData = data.map((e) {
      return [e.name, e.quantity, e.price];
    }).toList();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a5,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(level: 0, child: pw.Text("Pocketlist")),
          pw.Table.fromTextArray(
              data: filterData,
              headers: titles,
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.topLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
              })
        ];
      },
    ));
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.pdf');
    await file.writeAsBytes(bytes);
    final url = file.path;
    //await openFile(file);
    ShareExtend.share(url, 'file');
    //await file.delete();
    // if (File(url).existsSync()) {
    //   print('object');
    //   await deleteFile();
    // }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('path ${path}');
    return File('$path/lista.pdf');
  }

  Future<int> deleteFile(String name) async {
    // final directory = await getApplicationDocumentsDirectory();
    // final path = directory.path;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.pdf');
    //  final dir = await getApplicationDocumentsDirectory();
    // final file = File('${dir.path}/lista.pdf');
    // await file.writeAsBytes(bytes);
    // final url = file.path;
    try {
      //final file = await _localFile;

      await file.delete();
    } catch (e) {
      return 0;
    }
  }
}
