import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/app.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx2_widgets/home.dart';
// ignore: unused_import
import 'example/app_routes.dart';

void main() {
  var app = Jx2App(
    title: "Flutter teste",
    theme: AppTheme.darkTheme,
    home: Home(),
    //routes: appRoutes,
  );
  runApp(app);
}
