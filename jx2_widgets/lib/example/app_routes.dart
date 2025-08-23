import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/dashboard/dashboard_screen.dart';
import 'package:jx2_widgets/example/pages/button_page.dart';
import 'app_constants.dart';
import 'base_page.dart';
import 'pages.dart';

Map<String, WidgetBuilder> get appRoutes => {
      dashboardRoute: (context) => BasePage(title: '/', body: DashboardScreen()),
      homeRoute: (context) => BasePage(title: 'Home', body: HomePage()),
      profileRoute: (context) => BasePage(title: 'Profile', body: ProfilePage()),
      settingsGeneralRoute: (context) => BasePage(title: 'Settings General', body: SettingsGeneralPage()),
      settingsPrivacyRoute: (context) => BasePage(title: 'Settings Privacy', body: SettingsPrivacyPage()),
      buttonPageRoute: (context) => BasePage(title: 'Settings Privacy', body: ButtonPage()),
    };