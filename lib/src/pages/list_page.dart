import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/utils/pdf.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/models/List_model.dart';
import 'package:PocketList/src/pages/details_page.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // utils.saludos(context),
              Container(
                color: Colors.white,
                child: Column(children: [
                  _imagen(),
                ]),
              ),

              //utils.saludos(context),
              // _imagen(),
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
                  child: card(lista[i]),
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
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    lista.fecha,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        final pdf = await ApiPdf.generateTAble(lista.id);
                        ApiPdf.openFile(pdf);
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
                        _validateEliminar(context, lista.id);
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

  _validateEliminar(BuildContext context, String id) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'delete')),
            content: new Text(getTranlated(context, 'deleteListDia')),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'leave'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              TextButton(
                  onPressed: () {
                    DBProvider.db.deleteLista(id);
                    Navigator.of(context).pop();
                    utils.showSnack(
                        context, getTranlated(context, 'deletedList'));
                    setState(() {});
                  },
                  child: Text(
                    getTranlated(context, 'accept'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }
}
