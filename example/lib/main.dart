import 'dart:convert';
import 'dart:developer';

import 'package:example/pages/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jx2_widgets/core/app.dart';
import 'package:jx2_widgets/core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppTheme.customSeed = Colors.red;
  AppTheme.customBrightness = Brightness.dark;
  AppTheme.customThemeMap = await loadJsonAsset("assets/themes/custom.json");
  AppTheme.setTheme(AppThemeMode.custom);
  log(AppTheme.currentThemeMode.toString());
  var app = Jx2App(
    title: "Flutter teste",
    theme: AppTheme.currentTheme,
    //home: Home(),
    routes: appRoutes,
  );
  runApp(app);
}

// Função para carregar o JSON do asset (fora da classe AppTheme)
Future<Map<String, Map<String, String>>> loadJsonAsset(String path) async {
  try {
    final jsonString = await rootBundle.loadString(path);
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    return jsonData.map((key, value) => MapEntry(key, Map<String, String>.from(value)));
  } catch (e) {
    print("Erro ao carregar o JSON do asset '$path': $e");
    return {};
  }
}
