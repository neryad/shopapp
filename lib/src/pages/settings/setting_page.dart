import 'package:flutter/material.dart';
import 'package:PocketList/main.dart';
import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/data/class/language.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/providers/db_provider.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:PocketList/src/widgets/Menu_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  //int _color;
  // ThemeData darktheme = ThemeData(brightness: Brightness.dark);

  // ThemeData lightTheme = ThemeData(brightness: Brightness.light);

  TextEditingController _textEditingController;

  final prefs = new PreferenciasUsuario();
  var light = false;
  @override
  void initState() {
    //_color = prefs.color;
    // prefs.ultimaPagina = 'settings';
    super.initState();
    _textEditingController =
        new TextEditingController(text: prefs.nombreUsuario);
  }

  void _changeLanguea(Language language) async {
    Locale _temp = await setLocal(language.languageCode);
    prefs.lnge = language.languageCode;
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
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
      //  drawer: MenuWidget(),
      body: ListView(children: <Widget>[
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text(getTranlated(context, 'themTitle'),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                //color: utils.cambiarColor()
              )),
          onTap: () => {
            // Navigator.pop(context),
            Navigator.pushNamed(context, 'colorPage')
          },
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.person_sharp),
          title: Text(getTranlated(context, 'userTitle'),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                //color: utils.cambiarColor()
              )),
          onTap: () => {
            // Navigator.pop(context),
            Navigator.pushNamed(context, 'userPage')
          },
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.data_usage),
          title: Text(getTranlated(context, 'dataTitle'),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                //color: utils.cambiarColor()
              )),
          onTap: () => {
            // Navigator.pop(context),
            Navigator.pushNamed(context, 'dataPage')
          },
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
        Divider(),
        SwitchListTile(
          title: Text(getTranlated(context, 'darkMode'),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                //color: utils.cambiarColor()
              )),
          value: prefs.darkLightTheme,
          onChanged: (state) {
            setState(() {
              light = state;
              _selectedRadio(light);
              print(light);
            });
          },
          secondary: const Icon(Icons.lightbulb_outline),
        ),
        Divider()
      ]),
    );
  }

  _selectedRadio(bool valor) {
    prefs.darkLightTheme = valor;
    light = valor;
    MyApp.stateSet(context);
  }
}
