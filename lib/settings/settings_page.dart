import 'dart:math';

import 'package:PocketList/settings/provider/setting_priver.dart';
import 'package:PocketList/settings/widgets/language_drop_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class SettingsPages extends ConsumerWidget {
  const SettingsPages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settTitle'.tr()),
      ),
      body: _settingsView(),
    );
  }
}

class _settingsView extends ConsumerWidget {
  const _settingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkmode;
    final currentLocale = ref.read(localeProvider);
    final availableLocales = ref
        .read(availableLocalesProvider)
        .where((locale) => locale != currentLocale)
        .toList();
    return RefreshIndicator(
      onRefresh: () {
        return context.setLocale(Locale('es'));
      },
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          const ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Theme'),
            subtitle: Text('Change app theme color'),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          // const Divider(
          //   color: Colors.blue,
          // ),
          const ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('User customization'),
            subtitle: Text('Change app theme color'),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          const ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Data Administration'),
            subtitle: Text('Change app theme color'),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
              leading: Icon(Icons.brightness_6_outlined),
              title: const Text('Theme'),
              subtitle: const Text('Change app theme color'),
              trailing: IconButton(
                onPressed: () {
                  ref.read(themeNotifierProvider.notifier).toggleDarkMode();
                },
                icon: Icon(isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
              )),

          ListTile(
              leading: Icon(Icons.language),
              title: Text('mExportImport').tr(),
              subtitle: Text('Change app theme color'),
              trailing: LanguageDropdown()),
        ],
      ),
    );
  }
}
