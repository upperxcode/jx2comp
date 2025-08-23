import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/menu_drawer/core/menu_item.dart';
import 'package:jx2_widgets/core/theme.dart';

List<MenuEntry> menuItems = [
  MenuItem(
    title: 'Dashboard',
    icon: Icons.dashboard,
    route: '/',
    color: JxTheme.getColor(JxColor.menuItem).background,
    textColor: JxTheme.getColor(JxColor.menuItem).foreground,
  ),
  MenuItem(
    title: 'Home',
    icon: Icons.home,
    route: '/home',
    //color: Colors.yellow,
    textColor: Colors.black,
  ),
  MenuItem(
    title: 'Cidade',
    icon: Icons.home,
    route: '/cidade',
    //color: Colors.yellow,
    textColor: Colors.pink,
  ),
  MenuItem(
    title: 'Estado',
    icon: Icons.home,
    route: '/estado',
    //color: Colors.yellow,
    textColor: Colors.purple,
  ),
  MenuItem(
    title: 'Profile',
    icon: Icons.person,
    route: '/profile',
    color: Colors.yellow,
    textColor: Colors.black,
  ),
  MenuSection(
    sectionTitle: 'Settings',
    color: Colors.pink,
    textColor: Colors.black,
    items: [
      MenuItem(
        title: 'General Settings',
        icon: Icons.settings,
        route: '/settings/general',
        color: Colors.black45,
        textColor: Colors.grey,
      ),
      MenuItem(
        title: 'Privacy Settings',
        icon: Icons.lock,
        route: '/settings/privacy',
        //color: Colors.blue,
        textColor: Colors.black,
      ),
      MenuItem(
        title: 'Button Exemple Page',
        icon: Icons.lock,
        route: '/buttonPage',
        //color: Colors.blue,
        textColor: Colors.black,
      ),
    ],
  ),
];
