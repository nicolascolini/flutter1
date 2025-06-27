import 'package:flutter/material.dart';

class FranceColors {
  static const Color blue = Color(0xFF0055A4);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFEF4135);
}

// Light Theme
final ThemeData appLightTheme = _buildTheme(Brightness.light);

// Dark Theme
final ThemeData appDarkTheme = _buildTheme(Brightness.dark);

// Função que monta os dois temas
ThemeData _buildTheme(Brightness brightness) {
  final bool isDark = brightness == Brightness.dark;

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: FranceColors.blue,
    brightness: brightness,
    secondary: FranceColors.red,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: FranceColors.blue,
      foregroundColor: FranceColors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: FranceColors.red,
        foregroundColor: FranceColors.white,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(color: colorScheme.onBackground),
      headlineMedium: TextStyle(color: colorScheme.onBackground),
      titleLarge: TextStyle(color: colorScheme.onBackground),
      bodyLarge: TextStyle(color: colorScheme.onBackground),
      bodyMedium: TextStyle(color: colorScheme.onBackground),
      labelLarge: TextStyle(color: colorScheme.onPrimary),
    ),
  );
}


// ThemeData appTheme([bool isDarkMode=false]) {
//   return isDarkMode ? franceDarkTheme : franceLightTheme;
// }