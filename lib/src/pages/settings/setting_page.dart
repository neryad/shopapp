import 'package:flutter/material.dart';
import 'package:PocketList/main.dart';
import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/data/class/language.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/utils/utils.dart' as utils;
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  //int _color;
  // ThemeData darktheme = ThemeData(brightness: Brightness.dark);

  // ThemeData lightTheme = ThemeData(brightness: Brightness.light);

  late TextEditingController _textEditingController;

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
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(15.0),
        //     child: DropdownButton(
        //         underline: SizedBox(),
        //         icon: Icon(
        //           Icons.language,
        //           color: Colors.white,
        //         ),
        //         //hint: new Text(getTranlated(context, 'lnHelp')),
        //         items: Language.languageList()
        //             .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
        //                 value: lang,
        //                 child: Row(
        //                   children: [
        //                     Text(lang.name),
        //                     SizedBox(
        //                       width: 5.0,
        //                     ),
        //                     SizedBox(
        //                       width: 5.0,
        //                     ),
        //                     Text(lang.languageCode),
        //                     SizedBox(
        //                       width: 5.0,
        //                     ),
        //                   ],
        //                 )))
        //             .toList(),
        //         onChanged: (Language language) {
        //           _changeLanguea(language);
        //         }),
        //   ),
        // ],
        title: Text(getTranlated(context, 'settTitle')!),
        backgroundColor: utils.cambiarColor(),
      ),
      //  drawer: MenuWidget(),
      body: ListView(children: <Widget>[
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text(getTranlated(context, 'themTitle')!,
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
          title: Text(getTranlated(context, 'userTitle')!,
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
          title: Text(getTranlated(context, 'dataTitle')!,
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
          title: Text(getTranlated(context, 'darkMode')!,
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
              //print(light);
            });
          },
          secondary: const Icon(Icons.lightbulb_outline),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.language),
          title: Text(getTranlated(context, 'lngTitle')!,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                //color: utils.cambiarColor()
              )),
          onTap: () => {
            // Navigator.pop(context),
            //Navigator.pushNamed(context, 'dataPage')
          },
          trailing: SizedBox(
            child: DropdownButton(
                underline: SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  //color: Colors.white,
                ),
                //hint: new Text(getTranlated(context, 'lnHelp')),
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                        value: lang,
                        child: Row(
                          children: [
                            // Text(lang.name),
                            // SizedBox(
                            //   width: 5.0,
                            // ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(lang.flag),
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
                onChanged: (Language? language) {
                  _changeLanguea(language!);
                }),
          ),
        ),
        Divider(),

        // DropdownButton(
        //     underline: SizedBox(),
        //     icon: Icon(
        //       Icons.arrow_drop_down,
        //       //color: Colors.white,
        //     ),
        //     //hint: new Text(getTranlated(context, 'lnHelp')),
        //     items: Language.languageList()
        //         .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
        //             value: lang,
        //             child: Row(
        //               children: [
        //                 Text(lang.name),
        //                 SizedBox(
        //                   width: 5.0,
        //                 ),
        //                 SizedBox(
        //                   width: 5.0,
        //                 ),
        //                 Text(lang.languageCode),
        //                 SizedBox(
        //                   width: 5.0,
        //                 ),
        //               ],
        //             )))
        //         .toList(),
        //     onChanged: (Language language) {
        //       _changeLanguea(language);
        //     }),
        // ListTile(
        //   leading: Icon(Icons.language),
        //   title: Text(getTranlated(context, 'lngTitle'),
        //       style: TextStyle(
        //         fontSize: 20.0,
        //         fontWeight: FontWeight.bold,
        //         //color: utils.cambiarColor()
        //       )),
        //   onTap: () => {
        //     // Navigator.pop(context),
        //     Navigator.pushNamed(context, 'lngPage')
        //   },
        //   trailing: Icon(Icons.arrow_forward_ios_rounded),
        // ),

        ListTile(
          title: Text(getTranlated(context, 'Terms')!,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )),
          //subtitle: Text(getTranlated(context, 'aboutDonation')),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            _launchURL('https://neryad.github.io/pocketPage/docs/Terms.pdf');
          },
        ),
        Divider(),
        ListTile(
          title: Text(getTranlated(context, 'privacyPol')!,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )),
          //subtitle: Text(getTranlated(context, 'aboutDonation')),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            _launchURL(
                'https://neryad.github.io/pocketPage/docs/PrivacyPolicy.pdf');
          },
        ),
      ]),
    );
  }

  _selectedRadio(bool valor) {
    prefs.darkLightTheme = valor;

    light = valor;
    MyApp.stateSet(context);
  }

  // void _launchURL(String url) async => await canLaunchUrl(Uri.parse(url))
  //     ? await launchUrl(Uri.parse(url))
  //     : throw 'Could not launch';
  void _launchURL(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print(e);
    }
  }
}
