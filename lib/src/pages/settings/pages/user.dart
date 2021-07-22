import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;

import '../../../../main.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final prefs = new PreferenciasUsuario();
  TextEditingController _textEditingController;
  void initState() {
    //_color = prefs.color;
    // prefs.ultimaPagina = 'settings';
    super.initState();
    _textEditingController =
        new TextEditingController(text: prefs.nombreUsuario);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              getTranlated(context, 'userTitle'),
            ),
            backgroundColor: utils.cambiarColor(),
          ),
          body: Container(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(getTranlated(context, 'userNameConf'),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Divider(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        fillColor: utils.cambiarColor(),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                new BorderSide(color: utils.cambiarColor())),
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.save,
                              color: utils.cambiarColor(),
                            ),
                            onPressed: () {
                              prefs.nombreUsuario = _textEditingController.text;
                              MyApp.stateSet(context);
                              showSnack(context,
                                  getTranlated(context, 'changeComplete'));
                            }),
                        labelText: getTranlated(context, 'userInpText'),
                        labelStyle: TextStyle(color: utils.cambiarColor())

                        // helperText: getTranlated(context, 'userInpText')
                        ),
                    onChanged: (value) {
                      prefs.nombreUsuario = value;
                    },
                  )),
            ],
          ))),
    );
  }

  void showSnack(BuildContext context, String msg) {
    Flushbar(
      //title: 'This action is prohibited',
      message: msg,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: utils.cambiarColor(),
      ),
      leftBarIndicatorColor: utils.cambiarColor(),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}

//TODO: poner flusbar aqui
