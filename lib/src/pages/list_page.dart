import 'package:flutter/material.dart';
import 'package:shopapp/src/models/List_model.dart';
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
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[utils.saludos(), _imagen(), _wawa(context)],
          ),
        ),
      ),
    );
  }
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
              'No se han guadado alguna lista',
              style: TextStyle(
                color: utils.cambiarColor(),
                fontSize: 18,
              ),
            ),
          );
          //return Center(child: Text('data'));

        }

        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: lista.length,
          itemBuilder: (context, i) => _card(lista[i]),
        );
      },
    ),
  );
}
// wawaw(){
// return FutureBuilder<List<Lista>>(
//     future: DBProvider.db.getToadasLista(),
//     builder: (BuildContext context, AsyncSnapshot<List<Lista>> snapshot){

//      if (!snapshot.hasData) {
//         return Center(child: CircularProgressIndicator());
//       }

//       final lista = snapshot.data;

//       if(lista.length == 0 ){
//         return Center(child: Text('data'));
//       }

//       return ListView.builder(
//         padding: EdgeInsets.all(8.0),
//         itemCount: lista.length,
//         itemBuilder: (context,i) =>
//         _card(lista[i]
//         ),
//       );
//     },
//   );
// }

//  return  FutureBuilder<List<Lista>>(
//       future: DBProvider.db.getToadasLista(),
//       builder: (BuildContext context, AsyncSnapshot<List<Lista>> snapshot){

//        if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final lista = snapshot.data;

//         if(lista.length == 0 ){
//           return Center(child: Text('data'));
//         }

//         return ListView.builder(
//           padding: EdgeInsets.all(8.0),
//           itemCount: lista.length,
//           itemBuilder: (context,i) =>
//           _card(lista[i]
//           ),
//         );
//       },
//     );

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
  return Container(
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
  );
}
