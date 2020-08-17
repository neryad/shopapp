import 'package:flutter/material.dart';
import 'package:shopapp/main.dart';
import 'package:shopapp/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:shopapp/src/data/class/language.dart';
import 'package:shopapp/src/localization/localization_constant.dart';
import 'package:shopapp/src/providers/db_provider.dart';
import 'package:shopapp/src/utils/utils.dart' as utils;
import 'package:shopapp/src/widgets/Menu_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _genero;
  TextEditingController _textEditingController;

  final prefs = new PreferenciasUsuario();

  @override
  void initState() {
    _genero = prefs.genero;
    super.initState();
    _textEditingController =
        new TextEditingController(text: prefs.nombreUsuario);
  }

  void _changeLanguea(Language language) async {
    Locale _temp = await setLocal(language.languageCode);
    MyApp.setLocale(context, _temp);
  }

  _selectedRadio(int valor) {
    prefs.genero = valor;
    _genero = valor;
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
            padding: const EdgeInsets.all(4.0),
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
                            
                              SizedBox(width: 5.0,),
                             
                               SizedBox(width: 5.0,),
                                Text(lang.languageCode),
                           SizedBox(width: 5.0,),
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
          padding: EdgeInsets.all(5.0),
          child: Text(
            getTranlated(context, 'themTitle'),
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),

        Divider(),
        RadioListTile(
          title: Text(
            getTranlated(context, 'nColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 1,
          groupValue: _genero,
          onChanged: _selectedRadio,
        ),
        RadioListTile(
          title: Text(
            getTranlated(context, 'bColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 2,
          groupValue: _genero,
          onChanged: _selectedRadio,
        ),
        RadioListTile(
          title: Text(
            getTranlated(context, 'geColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 3,
          groupValue: _genero,
          onChanged: _selectedRadio,
        ),
        RadioListTile(
          title: Text(
            getTranlated(context, 'pColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 4,
          groupValue: _genero,
          onChanged: _selectedRadio,
        ),
        RadioListTile(
          title: Text(
            getTranlated(context, 'gyColor'),
            style: TextStyle(fontSize: 20),
          ),
          value: 5,
          groupValue: _genero,
          onChanged: _selectedRadio,
        ),
        Divider(),
        Container(
          padding: EdgeInsets.all(5.0),
          child: Text(
            getTranlated(context, 'userTitle'),
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.all(5.0),
          child: Text(
            getTranlated(context, 'dataTitle'),
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),

        Divider(),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Text(getTranlated(context, 'deletePar'),
                    style: TextStyle(fontSize: 18)),
                // FlatButton(
                // color: Colors.red,
                // textColor: Colors.white,
                // //disabledColor: Colors.grey,
                // //disabledTextColor: Colors.black,
                // //padding: EdgeInsets.all(8.0),
                // splashColor: Colors.redAccent,
                // onPressed: () {
                //   _validateEliminar(context);
                //   // utils.showSnack(context, getTranlated(context, 'dataDelete'));
                // },
                // child: Row(
                //   mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Text(
                //       getTranlated(context, 'deleteAllList'),
                //       style: TextStyle(fontSize: 20),
                //     ),

                //     Icon(Icons.delete_forever)
                //   ],
                // )
                // ),
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
        // Container(
        //   padding: EdgeInsets.all(5.0),
        //   child: Text(
        //     getTranlated(context, 'lngTitle'),
        //     style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        //   ),
        // ),
        // Container(
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 20.0),
        //     child: DropdownButton(
        //         hint: new Text(getTranlated(context, 'lnHelp')),
        //         items: Language.languageList()
        //             .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
        //                 value: lang,
        //                 child: Row(
        //                   children: [Text(lang.name)],
        //                 )))
        //             .toList(),
        //         onChanged: (Language language) {
        //           _changeLanguea(language);
        //         }),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20.0),
        //   child: Text('Current language : ${wawa}'),
        // ),
        // RaisedButton(
        //         onPressed: () {
        //           Language language;
        //           language.languageCode = "es";
        //          // appLanguage.changeLanguage(Locale("es"));
        //          _changeLanguea(language);
        //         },
        //         child: Text('Mensaje'),
        //       )
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
