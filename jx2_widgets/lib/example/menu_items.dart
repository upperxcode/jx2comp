import 'package:flutter/material.dart';

import '../components/menu_drawer/core/menu_item.dart';



List<MenuEntry> menuItems = [
   MenuItem(
    title: 'Dashboard',
    icon: Icons.dashboard,
    route: '/',
    color: Colors.yellow,
    textColor: Colors.black,
  ),
  MenuItem(
    title: 'Home',
    icon: Icons.home,
    route: '/home',
    //color: Colors.yellow,
    textColor: Colors.black,
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