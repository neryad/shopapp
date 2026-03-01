import 'package:flutter/material.dart';

class AppTheme {
  static Color getPrimaryColor(int colorIndex, {int? customColor}) {
    if (colorIndex == 0 && customColor != null) {
      return Color(customColor);
    }
    // Fallback if index 0 but no custom color provided (from static contexts)
    if (colorIndex == 0) {
      return const Color.fromRGBO(255, 111, 94, 1);
    }

    switch (colorIndex) {
      case 1:
        return const Color.fromRGBO(255, 111, 94, 1); // Orange/Salmon
      case 2:
        return const Color(0xff0e5c68); // Teal
      case 3:
        return const Color(0xff2b7600); // Green
      case 4:
        return const Color(0xFFFF1493); // Deep Pink
      case 5:
        return const Color(0xFF424242); // Grey
      case 6:
        return const Color(0xff7e57c2); // Deep Purple
      case 7:
        return const Color(0xffe53935); // Red
      default:
        return const Color.fromRGBO(255, 111, 94, 1);
    }
  }

  static ThemeData getTheme(int colorIndex, bool isDark, {int? customColor}) {
    final seedColor = getPrimaryColor(colorIndex, customColor: customColor);
    final brightness = isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ).copyWith(
        primary: seedColor,
        onPrimary: Colors.white, // Standard for our app's style
      ),
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: seedColor,
        foregroundColor:
            Colors.white, // Ensure text is visible on colored appbar
        elevation: 0,
        centerTitle: true,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
    );
  }
}
