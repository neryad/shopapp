import 'package:flutter/material.dart';
import 'package:PocketList/main.dart';
import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/data/class/language.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/widgets/Menu_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _color;
  TextEditingController _textEditingController;

  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    _color = prefs.color;
    prefs.ultimaPagina = 'settings';
    super.initState();
    _textEditingController =
        new TextEditingController(text: prefs.nombreUsuario);
  }

  void _changeLanguea(Language language) async {
    Locale _temp = await setLocal(language.languageCode);
    MyApp.setLocale(context, _temp);
  }

  _selectedRadio(int valor) {
    prefs.color = valor;
    _color = valor;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // var appLanguage = Provider.of< mmg.AppLanguage>(context);
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: DropdownButton(
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                //hint: new Text(getTranlated(context, 'lnHelp')),
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                        value: lang,
                        child: Row(
                          children: [
                            Text(lang.name),
                            SizedBox(
                              width: 5.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(lang.languageCode),
                            SizedBox(
                              width: 5.0,
                            ),
                          ],
                        )))
                    .toList(),
                onChanged: (Language language) {
                  _changeLanguea(language);
                }),
          ),
        ],
        title: Text(getTranlated(context, 'settTitle')),
        backgroundColor: utils.cambiarColor(),
      ),
      drawer: MenuWidget(),
      body: ListView(children: <Widget>[
        Container(
          padding: EdgeInsets.all(15.0),
          child: Text(
            getTranlated(context, 'themTitle'),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        RadioListTile(
          title: Text(
            getTranlated(context, 'nColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 1,
          groupValue: _color,
          onChanged: _selectedRadio,
        ),
        RadioListTile(
          title: Text(
            getTranlated(context, 'bColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 2,
          groupValue: _color,
          onChanged: _selectedRadio,
        ),
        RadioListTile(
          title: Text(
            getTranlated(context, 'geColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 3,
          groupValue: _color,
          onChanged: _selectedRadio,
        ),
        RadioListTile(
          title: Text(
            getTranlated(context, 'pColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 4,
          groupValue: _color,
          onChanged: _selectedRadio,
        ),
        RadioListTile(
          title: Text(
            getTranlated(context, 'gyColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 5,
          groupValue: _color,
          onChanged: _selectedRadio,
        ),
        Divider(),
        Container(
          padding: EdgeInsets.all(15.0),
          child: Text(
            getTranlated(context, 'userTitle'),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: getTranlated(context, 'userInpText'),
                // helperText: getTranlated(context, 'userInpText')
              ),
              onChanged: (value) {
                prefs.nombreUsuario = value;
              },
            )),
        Divider(),
        Container(
          padding: EdgeInsets.all(15.0),
          child: Text(
            getTranlated(context, 'dataTitle'),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Text(getTranlated(context, 'deletePar'),
                    style: TextStyle(fontSize: 18)),
                RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {
                    _validateEliminar(context);
                  },
                  child: Text(getTranlated(context, 'deleteAllList'),
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            )),
      ]),
    );
  }

  _validateEliminar(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(getTranlated(context, 'deleteAllList')),
            content: new Text(getTranlated(context, 'deleteDialo')),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    getTranlated(context, 'leave'),
                    style: TextStyle(color: utils.cambiarColor()),
                  )),
              FlatButton(
                  onPressed: () {
                    limpiarTodo();
                    utils.showSnack(
                        context, getTranlated(context, 'dataDelete'));
                  },
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
      DBProvider.db.deleteAllProd();
      //items.clear();
      setState(() {});
    });
    Navigator.of(context).pop();
  }
}
