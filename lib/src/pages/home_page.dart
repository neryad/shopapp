import 'package:flutter/material.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:shopapp/src/localization/localization_constant.dart';
import 'package:shopapp/src/pages/list_page.dart';
import 'package:shopapp/src/providers/db_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//Text("Mis listas")
class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text(getTranlated(context, 'mHomeTitle'),),
        actions: <Widget>[
          //IconButton(icon: Icon(Icons.delete_forever, ), onPressed: () => _validateEliminar(context),tooltip: 'Borrar todas las listas',),
           IconButton(icon: Icon(Icons.add_shopping_cart, ), onPressed: () => {Navigator.pushReplacementNamed(context, 'newList')})
        ],
        elevation: 0.0,
        backgroundColor: utils.cambiarColor(),
      ),
      body: ListPage(),
      drawer: MenuWidget(),
    );
  }

  _validateEliminar(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'deleteAllList')),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'leave'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () => limpiarTodo(),
                  child: Text(
                     getTranlated(context, 'accept'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }

    limpiarTodo() {
    setState(() {
      DBProvider.db.deleteAllList();
      //items.clear();
      setState(() {
        
      });
    });
    Navigator.of(context).pop();
  }
}
