import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supportedLocales = [
      {'locale': 'es', 'flag': '🇪🇸'},
      {'locale': 'en', 'flag': '🇺🇸'},
      {'locale': 'it', 'flag': '🇮🇹'}
    ];

    return DropdownButton<String>(
      value: context.locale.toString(),
      //  icon: const Icon(Icons.language),
      iconSize: 24,
      elevation: 16,
      //style: Theme.of(context).textTheme.bodyText2,
      // underline: Container(
      //   height: 2,
      //   color: Theme.of(context).accentColor,
      // ),
      onChanged: (String? value) async {
        //final Locale locale = Locale(newValue!);
        if (value != null) {
          return await context.setLocale(Locale(value));
          //  await context.updateLocale();
        }
      },
      items: supportedLocales.map((Map<String, String> locale) {
        return DropdownMenuItem<String>(
          value: locale['locale'],
          child: Row(children: [
            Text(locale['flag']!),
            const SizedBox(width: 10.0),
            Text(locale['locale']!.toUpperCase())
          ]),
        );
      }).toList(),
    );
  }
}
