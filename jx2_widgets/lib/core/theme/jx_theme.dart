import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme/enums.dart';
import 'package:jx2_widgets/core/theme/jx_colors.dart';
import 'package:jx2_widgets/core/theme/theme.dart';
import 'package:jx_utils/logs/jx_log.dart';
import 'themes.json.dart';

class JxTheme {
  static AppThemeMode get currentThemeMode => AppTheme.currentThemeMode;
  static ThemeData get currentTheme => AppTheme.currentTheme;
  static void setTheme(AppThemeMode mode) => AppTheme.setTheme(mode);

  static final Map<String, JxColors> _currentSessionColors = {};
  static final Map<String, JxColors> _userOverrides = {};
  static Map<AppThemeMode, Map<String, Map<String, String>>> _predefinedThemesRaw = {};

  static Future<void> initializeTheme(AppThemeMode initialTheme) async {
    _loadPredefinedThemes();
    await _loadUserOverrides();
    _applyTheme(initialTheme);
  }

  static void _loadPredefinedThemes() {
    try {
      _predefinedThemesRaw = defaultTheme.map(
        (key, value) => MapEntry(
          AppThemeMode.values.firstWhere(
            (e) => e.toString().split('.').last == key,
            orElse: () => AppThemeMode.light, // Usando light como padrão
          ),
          (value as Map).map((k, v) => MapEntry(k as String, (v as Map).cast<String, String>())),
        ),
      );
    } catch (e) {
      JxLog.info('Erro ao carregar temas predefinidos: $e');
      _predefinedThemesRaw = {};
    }
  }

  static Future<void> _loadUserOverrides() async {
    final customOverrides = AppTheme.customThemeMap;
    final customTheme = _predefinedThemesRaw[AppThemeMode.custom];

    if (customOverrides.isNotEmpty && customTheme != null) {
      customOverrides.forEach((colorName, customColorMap) {
        if (customTheme.containsKey(colorName)) {
          final background = customColorMap['background'];
          final foreground = customColorMap['foreground'];

          if (background != null && foreground != null) {
            customTheme[colorName] = {'background': background, 'foreground': foreground};
          }
        }
      });
    }
  }

  static Future<void> _saveUserOverrides() async {
    // Implementar lógica de salvamento aqui
  }

  static void _applyTheme(AppThemeMode themeMode) {
    _currentSessionColors.clear();
    final themeDataRaw = _predefinedThemesRaw[themeMode];
    if (themeDataRaw != null) {
      themeDataRaw.forEach((key, value) {
        _currentSessionColors[key] = JxColors(
          _colorFromHex(value['background'] ?? 'FFFFFF'),
          _colorFromHex(value['foreground'] ?? '000000'),
        );
      });
    }
    // Aplicar as sobrescritas do usuário
    _userOverrides.forEach((key, value) {
      _currentSessionColors[key] = value;
    });
  }

  static void overrideColor({required JxColor color, required JxColors jxColor}) {
    _userOverrides[color.toString()] = jxColor;
    _currentSessionColors[color.toString()] = jxColor;
    _saveUserOverrides();
  }

  static void removeOverrideColor(JxColor color) {
    final colorName = color.toString();
    _userOverrides.remove(colorName);
    _applyTheme(currentThemeMode); // Reaplicar para remover da sessão
    _saveUserOverrides();
  }

  static void clearOverrides() {
    _userOverrides.clear();
    _applyTheme(currentThemeMode); // Reaplicar para limpar da sessão
    _saveUserOverrides();
  }

  static Future<void> changeTheme(AppThemeMode newTheme) async {
    setTheme(newTheme);
    _applyTheme(newTheme);
    _saveUserOverrides();
  }

  // Nova função para sobrepor cores diretamente no tema corrente
  static void overrideTheme({
    required AppThemeMode themeMode,
    required Map<String, Map<String, String>> overrides,
  }) {
    final themeDataRaw = _predefinedThemesRaw[themeMode];
    if (themeDataRaw != null) {
      overrides.forEach((colorName, colorValues) {
        if (themeDataRaw.containsKey(colorName)) {
          _currentSessionColors[colorName] = JxColors(
            _colorFromHex(
              colorValues['background'] ?? themeDataRaw[colorName]!['background'] ?? 'FFFFFF',
            ),
            _colorFromHex(
              colorValues['foreground'] ?? themeDataRaw[colorName]!['foreground'] ?? '000000',
            ),
          );
          _userOverrides[colorName] =
              _currentSessionColors[colorName]!; // Salvar como uma sobrescrita do usuário
        } else {
          // Lidar com cores não existentes no tema base, se necessário
          JxLog.info('A cor "$colorName" não existe no tema base "$themeMode".');
        }
      });
      _saveUserOverrides(); // Salvar as alterações
    } else {
      JxLog.info('O tema base "$themeMode" não foi encontrado.');
    }
  }

  static Color _colorFromHex(String hexColor) {
    final hex = hexColor.replaceAll("#", "");
    if (hex.length == 6) {
      return Color(int.parse("FF$hex", radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    } else {
      return Colors.transparent; // Ou outra cor padrão, ou lançar um erro
    }
  }

  static JxColors getColor(JxColor color) {
    return _currentSessionColors[color.toString()] ?? const JxColors(Colors.white, Colors.black);
  }
}
