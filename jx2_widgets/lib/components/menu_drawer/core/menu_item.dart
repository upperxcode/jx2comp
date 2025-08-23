import 'package:flutter/material.dart';

abstract class MenuEntry {}

class MenuItem implements MenuEntry {
  final String title;
  final IconData icon;
  final String route;
  final Color? color;
  final Color? textColor;

  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.textColor = Colors.black,
    this.color = Colors.white24,
  });
}

class MenuSection implements MenuEntry{
  final String sectionTitle;
  final List<MenuItem> items;
  final Color? color;
  final Color? textColor;

  MenuSection({
    required this.sectionTitle,
    required this.items,
    this.textColor = Colors.black,
    this.color = Colors.white24,
  });
}