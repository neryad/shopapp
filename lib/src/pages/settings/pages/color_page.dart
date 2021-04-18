import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:flutter/material.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/localization/localization_constant.dart';
import '../../../../main.dart';

class ColorPage extends StatefulWidget {
  ColorPage({Key key}) : super(key: key);

  @override
  _ColorPageState createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  int _color;
  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    _color = prefs.color;
    //prefs.ultimaPagina = 'colorPage';
    super.initState();
  }

  _selectedRadio(int valor) {
    prefs.color = valor;
    _color = valor;
    MyApp.stateSet(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          getTranlated(context, 'themTitle'),
        ),
        backgroundColor: utils.cambiarColor(),
      ),
      body: Container(
        child: ListView(
          children: [
            RadioListTile(
              title: Text(
                getTranlated(context, 'nColor'),
                style: TextStyle(fontSize: 20),
              ),
              value: 1,
              groupValue: _color,
              onChanged: _selectedRadio,
              secondary: CircleAvatar(
                backgroundColor: Color.fromRGBO(255, 111, 94, 1),
              ),
            ),
            Divider(),
            RadioListTile(
              title: Text(
                getTranlated(context, 'bColor'),
                style: TextStyle(fontSize: 20),
              ),
              value: 2,
              groupValue: _color,
              onChanged: _selectedRadio,
              secondary: CircleAvatar(
                backgroundColor: Color(0xffb0e5c68),
              ),
            ),
            Divider(),
            RadioListTile(
              title: Text(
                getTranlated(context, 'geColor'),
                style: TextStyle(fontSize: 20),
              ),
              value: 3,
              groupValue: _color,
              onChanged: _selectedRadio,
              secondary: CircleAvatar(
                backgroundColor: Color(0xffb02b7600),
              ),
            ),
            Divider(),
            RadioListTile(
              title: Text(
                getTranlated(context, 'pColor'),
                style: TextStyle(fontSize: 20),
              ),
              value: 4,
              groupValue: _color,
              onChanged: _selectedRadio,
              secondary: CircleAvatar(
                backgroundColor: Color(0xffb0FF1493),
              ),
            ),
            Divider(),
            RadioListTile(
              title: Text(
                getTranlated(context, 'gyColor'),
                style: TextStyle(fontSize: 20),
              ),
              value: 5,
              groupValue: _color,
              onChanged: _selectedRadio,
              secondary: CircleAvatar(
                backgroundColor: Color(0xffb424242),
              ),
            ),
            Divider(),
            RadioListTile(
              title: Text(
                getTranlated(context, 'dpColor'),
                style: TextStyle(fontSize: 20),
              ),
              value: 6,
              groupValue: _color,
              onChanged: _selectedRadio,
              secondary: CircleAvatar(
                backgroundColor: Color(0xff7e57c2),
              ),
            ),
            Divider(),
            RadioListTile(
              title: Text(
                getTranlated(context, 'rColor'),
                style: TextStyle(fontSize: 20),
              ),
              value: 7,
              groupValue: _color,
              onChanged: _selectedRadio,
              secondary: CircleAvatar(
                backgroundColor: Color(0xffe53935),
              ),
            ),
            Divider()
          ],
        ),
      ),
    ));
  }
}
