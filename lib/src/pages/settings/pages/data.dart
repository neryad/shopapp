import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;

class DataPage extends StatefulWidget {
  DataPage({Key? key}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            getTranlated(context, 'dataTitle')!,
          ),
          backgroundColor: utils.cambiarColor(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
              //padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
            children: [
              Text(getTranlated(context, 'deletePar')!,
                  style: TextStyle(fontSize: 18)),
              //TODO boton anterior era RaisedButton
              TextButton(
                // color: Colors.red,
                // textColor: Colors.white,
                onPressed: () {
                  _validateEliminar(context);
                },
                child: Text(getTranlated(context, 'deleteAllList')!,
                    style: TextStyle(fontSize: 20)),
              ),
            ],
          )),
        ),
      ),
    );
  }

  limpiarTodo() {
    setState(() {
      DBProvider.db.deleteAllList();
      DBProvider.db.deleteAllProd();
      //items.clear();
      setState(() {});
    });
    Navigator.of(context).pop();
  }

  _validateEliminar(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'deleteAllList')!),
            content: new Text(getTranlated(context, 'deleteDialo')!),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'leave')!,
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              TextButton(
                  onPressed: () {
                    limpiarTodo();
                    utils.showSnack(
                        context, getTranlated(context, 'dataDelete')!);
                  },
                  child: Text(
                    getTranlated(context, 'accept')!,
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
            ],
          );
        });
  }
}
