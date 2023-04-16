import 'package:PocketList/config/router/app_router.dart';
import 'package:PocketList/settings/provider/setting_priver.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(ProviderScope(
    child: EasyLocalization(
        saveLocale: true,
        useFallbackTranslations: true,
        supportedLocales: const [Locale('en'), Locale('es'), Locale('it')],
        fallbackLocale: Locale('en'),
        path: 'i18n',
        child: const MyApp()),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(themeNotifierProvider);

    // final locale = ref.watch(languageProvider);
    // print('object $locale');
    rebuildAllChildren(context);
    return MaterialApp.router(
      // key: UniqueKey(),
      theme: appTheme.getTheme(),
      routerConfig: appRouter,
      title: 'Material App',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}
