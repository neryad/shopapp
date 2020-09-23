import 'package:PocketList/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/localization/localization.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/pages/about_page.dart';
import 'package:PocketList/src/pages/home_page.dart';
import 'package:PocketList/src/pages/newList.dart';
import 'package:PocketList/src/pages/setting_page.dart';
import 'package:PocketList/src/pages/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefes();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        locale: _locale,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('es', 'US'),
        ],
        localizationsDelegates: [
          Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          //GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }

          return supportedLocales.first;
        },
        title: 'PocketList',
        initialRoute: prefs.ultimaPagina,
        home: SplashScreen(),
        debugShowCheckedModeBanner: true,
        routes: {
          'home': (BuildContext context) => HomePage(),
          'newList': (BuildContext context) => NewList(),
          'settings': (BuildContext context) => SettingPage(),
          'about': (BuildContext context) => AboutPage(),
          'splahs': (BuildContext context) => SplashScreen(),
        },
      );
    }
  }
}
