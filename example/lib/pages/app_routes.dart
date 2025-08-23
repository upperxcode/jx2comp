import 'package:example/pages/button_page.dart';
import 'package:example/pages/cidade_page.dart';
import 'package:example/pages/estado_page.dart';
import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/dashboard/dashboard_screen.dart';

import 'app_constants.dart';
import 'base_page.dart';
import 'pages.dart';

Map<String, WidgetBuilder> get appRoutes => {
  dashboardRoute: (context) => BasePage(title: '/', body: DashboardScreen()),
  homeRoute: (context) => BasePage(title: 'Home', body: HomePage()),
  cidadeRoute: (context) => BasePage(title: 'Cidade', body: CidadePage()),
  estadoRoute: (context) => BasePage(title: 'Estado', body: EstadoPage()),
  profileRoute: (context) => BasePage(title: 'Profile', body: ProfilePage()),
  settingsGeneralRoute:
      (context) =>
          BasePage(title: 'Settings General', body: SettingsGeneralPage()),
  settingsPrivacyRoute:
      (context) =>
          BasePage(title: 'Settings Privacy', body: SettingsPrivacyPage()),
  buttonPageRoute:
      (context) => BasePage(title: 'Settings Privacy', body: ButtonPage()),
};
