import 'package:PocketList/src/pages/about/pages/authorPage.dart';
import 'package:PocketList/src/pages/details_page.dart';
import 'package:PocketList/src/pages/import_export_page.dart';
import 'package:PocketList/src/pages/news/news.dart';
import 'package:PocketList/src/pages/settings/pages/color_page.dart';
import 'package:PocketList/src/pages/settings/pages/data.dart';
import 'package:PocketList/src/pages/settings/pages/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:PocketList/src/Shared_Prefs/Prefrecias_user.dart';
import 'package:PocketList/src/localization/localization.dart';
import 'package:PocketList/src/localization/localization_constant.dart';
import 'package:PocketList/src/pages/about/about_page.dart';
import 'package:PocketList/src/pages/home_page.dart';
import 'package:PocketList/src/pages/New-List/newList.dart';
import 'package:PocketList/src/pages/settings/setting_page.dart';

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
  late Locale _locale;

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
    return DarkLightTheme(locale: _locale, prefs: prefs);
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
        'about': (BuildContext context) => AboutPage(),
        // 'help': (BuildContext context) => HelpPage(),
        'detailsPage': (BuildContext context) => DetailsPage(),
        'colorPage': (BuildContext context) => ColorPage(),
        'userPage': (BuildContext context) => UserPage(),
        'dataPage': (BuildContext context) => DataPage(),
        'authorPage': (BuildContext context) => AuthorPage(),
        'newsPage': (BuildContext context) => NewsPage(),
        'exportImport': (BuildContext context) => ImportExportPage()
      },
    );
  }
}
