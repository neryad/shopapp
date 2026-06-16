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

void showUpdateDialog(BuildContext context, String appVersion, String storeVersion) {
  final theme = Theme.of(context);
  final primaryColor = theme.colorScheme.primary;
  final isDark = theme.brightness == Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 8,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    primaryColor.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Update Available',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A new version of PocketList is ready to install.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Current',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appVersion,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'New',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        storeVersion,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's New",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildChangelogItem('✨', 'Shared Lists', isDark),
                  const SizedBox(height: 8),
                  _buildChangelogItem('🐛', 'Bug fixes and stability', isDark),
                  const SizedBox(height: 8),
                  _buildChangelogItem('⚡', 'Faster performance', isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Later',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // TODO: Launch store URL
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                      shadowColor: primaryColor.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Update Now',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildChangelogItem(String emoji, String text, bool isDark) {
  return Row(
    children: [
      Text(emoji, style: const TextStyle(fontSize: 14)),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ),
    ],
  );
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
    String? storedAppVersion;
    String? storedStoreVersion;

    final upgrader = Upgrader(
      debugDisplayAlways: true,
      debugLogging: true,
      willDisplayUpgrade: ({required bool display, String? installedVersion, UpgraderVersionInfo? versionInfo, String? minAppVersion}) {
        storedAppVersion = installedVersion;
        storedStoreVersion = versionInfo?.appStoreVersion?.toString();
        if (display) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showUpdateDialog(
              context,
              storedAppVersion ?? '0.0.0',
              storedStoreVersion ?? '0.0.0',
            );
          });
        }
      },
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
        showLater: false,
        showReleaseNotes: false,
        showPrompt: false,
        child: child!,
      ),
    );
  }
}
