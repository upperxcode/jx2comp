import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme/enums.dart';
import 'package:jx2_widgets/core/theme/jx_theme.dart';
import 'package:jx_utils/logs/jx_log.dart';

class AppTheme {
  static AppThemeMode _currentThemeMode = AppThemeMode.light; // Variável estática para o tema atual

  static AppThemeMode get currentThemeMode => _currentThemeMode;

  static Color _customSeed = Colors.green;
  static Brightness _customBrightness = Brightness.dark;

  static ThemeData get currentTheme {
    try {
      switch (_currentThemeMode) {
        case AppThemeMode.light:
          return lightTheme;
        case AppThemeMode.dark:
          return darkTheme;
        case AppThemeMode.custom:
          return customTheme ?? ThemeData.light(); // Provide a default value if customTheme is null
        case AppThemeMode.purple:
          return purpleTheme;
      }
    } catch (e) {
      JxLog.error(e.toString());
    }
    throw Exception('Invalid AppThemeMode: $_currentThemeMode');
  }

  static Map<String, Map<String, String>>? _customThemeMap;

  static set customSeed(Color color) => _customSeed = color;

  static set customBrightness(Brightness brightness) => _customBrightness = brightness;

  static set customThemeMap(Map<String, Map<String, String>> map) => _customThemeMap = map;

  static Map<String, Map<String, String>> get customThemeMap => _customThemeMap ?? {};

  static void setTheme(AppThemeMode mode) {
    _currentThemeMode = mode;

    if (mode == AppThemeMode.custom) {
      ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: _customSeed, brightness: _customBrightness),
      );
    }
    JxTheme.initializeTheme(mode);
  }

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, brightness: Brightness.light),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black45, brightness: Brightness.dark),
  );

  static ThemeData? customTheme;

  static final ThemeData purpleTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple, brightness: Brightness.dark),
    textTheme: TextTheme(displayLarge: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
  );
}
