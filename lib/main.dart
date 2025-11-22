import 'package:pocketlist/src/localization/localization.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/pages/New-List/newList.dart';
import 'package:pocketlist/src/pages/about/about_page.dart';
import 'package:pocketlist/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:pocketlist/src/pages/import_export_page.dart';
import 'package:pocketlist/src/pages/news/news.dart';
import 'package:pocketlist/src/pages/settings/pages/color_page.dart';
import 'package:pocketlist/src/pages/settings/pages/data.dart';
import 'package:pocketlist/src/pages/settings/pages/user.dart';
import 'package:pocketlist/src/pages/settings/setting_page.dart';

final prefs = new PreferenciasUsuario();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = new PreferenciasUsuario();
  await prefs.initPrefes();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  //runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  static void stateSet(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setState(() {});
  }

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      prefs.lnge = locale.languageCode;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
        prefs.lnge = locale.languageCode;
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
      return DarkLightTheme(locale: _locale!, prefs: prefs);
    }
  }
}

ThemeData darktheme = ThemeData(brightness: Brightness.dark);

ThemeData lightTheme = ThemeData(brightness: Brightness.light);

class DarkLightTheme extends StatelessWidget {
  const DarkLightTheme({
    Key? key,
    required Locale locale,
    required this.prefs,
  })  : _locale = locale,
        super(key: key);

  final Locale _locale;
  final PreferenciasUsuario prefs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: prefs.darkLightTheme ? darktheme : lightTheme,
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
          if (locale.languageCode == deviceLocale?.languageCode &&
              locale.countryCode == deviceLocale?.countryCode) {
            return deviceLocale;
          }
        }

        return supportedLocales.first;
      },
      title: 'PocketList',
      initialRoute: 'home',
      home: HomePage(),
      // home: SplashScreen(),
      debugShowCheckedModeBanner: true,
      routes: {
        'home': (BuildContext context) => HomePage(),
        'newList': (BuildContext context) => NewList(),
        'settings': (BuildContext context) => SettingPage(),
        'colorPage': (BuildContext context) => ColorPage(),
        'about': (BuildContext context) => AboutPage(),
        'exportImport': (BuildContext context) => ImportExportPage(),
        'userPage': (BuildContext context) => UserPage(),
        'dataPage': (BuildContext context) => DataPage(),
        'newsPage': (BuildContext context) => NewsPage(),
      },
    );
  }
}
