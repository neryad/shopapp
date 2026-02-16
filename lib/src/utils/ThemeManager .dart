// lib/src/providers/theme_manager.dart
import 'package:flutter/material.dart';
import 'package:pocketlist/src/Shared_Prefs/Prefrecias_user.dart';

class ThemeManager extends ChangeNotifier {
  final PreferenciasUsuario _prefs = PreferenciasUsuario();

  // Colores predefinidos
  static const List<Color> predefinedColors = [
    Color(0xFFFF6F5E), // Naranja/Rojo original
    Color(0xFF0E5C68), // Azul
    Color(0xFF2B7600), // Verde
    Color(0xFFFF1493), // Rosa/Magenta
    Color(0xFF424242), // Gris oscuro
    Color(0xFF7E57C2), // Morado
    Color(0xFFE53935), // Rojo
    Color(0xFF00897B), // Teal
    Color(0xFFFF6F00), // Naranja
    Color(0xFF5E35B1), // Morado profundo
    Color(0xFFC62828), // Rojo oscuro
    Color(0xFF00695C), // Verde azulado
  ];

  Color get seedColor {
    // Obtener color guardado o usar el predefinido según prefs.color
    final colorIndex = _prefs.color - 1;
    if (colorIndex >= 0 && colorIndex < predefinedColors.length) {
      return predefinedColors[colorIndex];
    }
    return predefinedColors[0];
  }

  bool get isDarkMode => _prefs.darkLightTheme;

  void setSeedColor(Color color) {
    // Buscar si el color está en predefinidos
    final index = predefinedColors.indexOf(color);
    if (index != -1) {
      _prefs.color = index + 1;
    } else {
      // Si es personalizado, guardar en una preferencia especial
      _prefs.customColorValue = color.value;
      _prefs.color = 0; // 0 indica color personalizado
    }
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _prefs.darkLightTheme = isDark;
    notifyListeners();
  }

  Color getCustomColor() {
    if (_prefs.color == 0) {
      return Color(_prefs.customColorValue);
    }
    return seedColor;
  }
}
