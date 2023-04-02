import 'package:flutter/material.dart';

const colorList = <Color>[
  Color(0xffb0e5c68),
  Color(0xffb02b7600),
  Color(0xffb0FF1493),
  Color(0xffb424242),
  Color(0xff7e57c2),
  Color(0xffe53935),
];

class AppTheme {
  final int selectedColor;
  final bool isDarkmode;

  AppTheme({this.selectedColor = 0, this.isDarkmode = false})
      : assert(selectedColor >= 0, 'Selected color most be greater then 0'),
        assert(selectedColor < colorList.length,
            'Selected color most less or equal that ${colorList.length}');

  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colorList[5],
      appBarTheme: const AppBarTheme(centerTitle: false));

  AppTheme copyWith({int? selectedColor, bool? isDarkmode}) => AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkmode: isDarkmode ?? this.isDarkmode);
}
