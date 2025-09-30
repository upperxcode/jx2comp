import 'package:flutter/material.dart';

abstract class MenuEntry {}

class MenuItem implements MenuEntry {
  final String title;
  final IconData icon;
  final String? route;
  final Function(dynamic)? func;
  final Color? color;
  final Color? textColor;

  MenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.func,
    this.textColor = Colors.black,
    this.color = Colors.white24,
  });
}

class MenuSection implements MenuEntry {
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

void defaultFunc(dynamic v) => {};
