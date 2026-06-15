import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

mixin PackageInfoMixin<T extends StatefulWidget> on State<T> {
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        packageInfo = info;
      });
    }
  }
}
