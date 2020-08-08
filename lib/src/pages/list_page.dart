import 'package:flutter/material.dart';
import 'package:shopapp/src/localization/localization_constant.dart';
import 'package:shopapp/src/models/List_model.dart';
import 'package:shopapp/src/pages/details_page.dart';
import 'package:shopapp/src/providers/db_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[utils.saludos(context), _imagen(), _wawa(context)],
          ),
        ),
      ),
    );
  }

  _wawa(BuildContext context) {
    return Container(
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
              child: Text(
                getTranlated(context, 'noList'),
                style: TextStyle(
                  color: utils.cambiarColor(),
                  fontSize: 18,
                ),
              ),
            );

          }
          lista.sort((a, b) => b.fecha.compareTo(a.fecha));
          return ListView.builder(
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
                    utils.showSnack(context, 'Lista eliminada');
                    DBProvider.db.deleteLista(lista[i].id);
                    lista.removeAt(i);
                    setState(() {});
                  },
                  child: _card(lista[i]),
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

  Widget _card(Lista lista) {
    return GestureDetector(
      onTap: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => DetailsPage(savelist: lista));
        Navigator.of(context).push(route);
      },
      child: Container(
        height: 100.00,
        child: Card(
          elevation: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.shopping_basket, color: utils.cambiarColor()),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(lista.title),
                  Text(lista.superMaret,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(lista.fecha),
                    Text(
                      utils.numberFormat(lista.total),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
