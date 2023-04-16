import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme/app_theme.dart';

final isDarkModeProvider = StateProvider((ref) => false);

// final colorListProvider = Provider((ref) => colorList);

final selectedColorProvider = StateProvider((ref) => 0);

// final randomNameProvider = StateProvider<Locale>((ref) {
//   state = ref;
// });

final localeProvider = StateProvider<Locale>((ref) => Locale('en'));

final availableLocalesProvider = Provider<List<Locale>>((ref) => [
      Locale('en'),
      Locale('es'),
    ]);

final languageProvider = StateNotifierProvider((ref) => LanguageNotifier());

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  // ThemeNotifier(super.state);

  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    state = state.copyWith(isDarkmode: !state.isDarkmode);
  }

  void changeColorIndex(int colorIndex) {
    state = state.copyWith(selectedColor: colorIndex);
  }
}

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(Locale('es'));

  void setLanguage(String languageCode, BuildContext context) {
    context.locale = Locale(languageCode.toString());
  }
}
