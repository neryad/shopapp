import 'package:flutter/material.dart';
import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/pages/list_page.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/widgets/Menu_widget.dart';

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
  void initState() {
    super.initState();
    prefs.ultimaPagina = 'home';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text(
          getTranlated(context, 'mHomeTitle'),
        ),
        elevation: 0.0,
        backgroundColor: utils.cambiarColor(),
      ),
      body: ListPage(),
      drawer: MenuWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.pushReplacementNamed(context, 'newList')},
        child: const Icon(Icons.add),
        backgroundColor: utils.cambiarColor(),
      ),
    );
  }

  // _validateEliminar(BuildContext context){
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(getTranlated(context, 'deleteAllList')),
  //           actions: <Widget>[
  //             FlatButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: Text(
  //                   getTranlated(context, 'leave'),
  //                   style: TextStyle(color: utils.cambiarColor()),
  //                 )),
  //             FlatButton(
  //                 onPressed: () => limpiarTodo(),
  //                 child: Text(
  //                    getTranlated(context, 'accept'),
  //                   style: TextStyle(color: utils.cambiarColor()),
  //                 )),
  //           ],
  //         );
  //       });
  // }

  limpiarTodo() {
    setState(() {
      DBProvider.db.deleteAllList();
      setState(() {});
    });
    Navigator.of(context).pop();
  }
}
