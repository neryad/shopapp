import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:pocketlist/src/localization/localization.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/Shared_Prefs/Preferencias_user.dart';

import 'package:pocketlist/src/pages/home_page.dart';
import 'package:pocketlist/src/pages/New-List/newList.dart';
import 'package:pocketlist/src/pages/settings/setting_page.dart';
import 'package:pocketlist/src/pages/settings/pages/color_page.dart';
import 'package:pocketlist/src/pages/settings/pages/data.dart';
import 'package:pocketlist/src/pages/settings/pages/user.dart';
import 'package:pocketlist/src/pages/about/about_page.dart';
import 'package:pocketlist/src/pages/about/pages/authorPage.dart';
import 'package:pocketlist/src/pages/import_export_page.dart';

import 'package:upgrader/upgrader.dart';

import 'package:pocketlist/src/theme/app_theme.dart';

class CustomUpgraderMessages extends UpgraderMessages {
  CustomUpgraderMessages({super.code});

  @override
  String get title {
    return 'New Update Available';
  }

  @override
  String get body {
    return 'We have a new version of {{appName}} ready for you!\n\nCurrent version: {{currentInstalledVersion}}\nNew version: {{currentAppStoreVersion}}';
  }

  @override
  String get prompt {
    return 'Update now to enjoy the latest features and improvements.';
  }

  @override
  String get buttonTitleUpdate {
    return 'Update Now';
  }

  @override
  String get buttonTitleLater {
    return 'Maybe Later';
  }

  @override
  String get buttonTitleIgnore {
    return 'Skip This Version';
  }
}

final PreferenciasUsuario prefs = PreferenciasUsuario();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await prefs.initPrefes();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  /// 🔄 Fuerza rebuild global (compatibilidad con tu código actual)
  static void stateSet(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()?.rebuild();
  }

  /// 🌍 Cambia idioma globalmente
  static void setLocale(BuildContext context, Locale locale) {
    context.findAncestorStateOfType<_MyAppState>()?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final locale = await getLocale();
    setState(() {
      _locale = locale;
      prefs.lnge = locale.languageCode;
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      prefs.lnge = locale.languageCode;
    });
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return DarkLightTheme(locale: _locale!);
  }
}

class DarkLightTheme extends StatelessWidget {
  final Locale locale;

  const DarkLightTheme({
    Key? key,
    required this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final upgrader = Upgrader(
      debugDisplayAlways: true,
      debugLogging: true,
      messages: CustomUpgraderMessages(),
    );
    final navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'PocketList',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        prefs.color,
        false,
        customColor: prefs.customColorValue,
      ),
      darkTheme: AppTheme.getTheme(
        prefs.color,
        true,
        customColor: prefs.customColorValue,
      ),
      themeMode: prefs.darkLightTheme ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == deviceLocale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomePage(),
        'newList': (_) => ShoppingListPage(),
        'settings': (_) => const SettingPage(),
        'colorPage': (_) => ColorPage(),
        'about': (_) => const AboutPage(),
        'exportImport': (_) => ImportExportPage(),
        'userPage': (_) => UserPage(),
        'dataPage': (_) => DataPage(),
        'authorPage': (_) => const AuthorPage(),
      },
      builder: (context, child) => UpgradeAlert(
        upgrader: upgrader,
        navigatorKey: navigatorKey,
        showIgnore: false,
        showLater: true,
        showReleaseNotes: true,
        child: child!,
      ),
    );
  }
}
