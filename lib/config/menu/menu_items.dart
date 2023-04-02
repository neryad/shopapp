import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String link;
  final IconData icon;

  const MenuItem({required this.title, required this.link, required this.icon});
}

final appMenuItems = <MenuItem>[
  MenuItem(
      title: 'mHomeTitle'.tr(),
      link: '/home',
      icon: Icons.shopping_cart_outlined),
  MenuItem(
      title: 'mMyLisTitle'.tr(),
      link: '/new-list',
      icon: Icons.add_shopping_cart_rounded),
  MenuItem(
      title: 'mExportImport'.tr(),
      link: '/export-import',
      icon: Icons.refresh_rounded),
  MenuItem(
      title: 'mSettingTitle'.tr(), link: '/settings', icon: Icons.settings),
  MenuItem(
      title: 'mNewsTitle'.tr(),
      link: '/news-page',
      icon: Icons.new_releases_sharp),
  MenuItem(title: 'mAboutTitle'.tr(), link: '/info-page', icon: Icons.info),
];
