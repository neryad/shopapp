import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'i18n',
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: Column(children: [
            Text('aImgs'.tr()),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    context.setLocale(const Locale('en'));
                  });
                },
                child: const Text('to EN')),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    context.setLocale(const Locale('es'));
                  });
                },
                child: const Text('to ES'))
          ]),
        ),
      ),
    );
  }
}
