import 'package:example/pages/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:jx2_widgets/example/app_constants.dart';
import 'package:jx2_widgets/components/menu_drawer/jx2drawer.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget body;

  const BasePage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final background = NetworkImage(backgroundImage);
    final perfil = NetworkImage(perfilImage);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Jx2Drawer(
        menuItems: menuItems,
        backgroundImage: background,
        perfilimage: perfil,
        name: 'João Albuquerque',
        email: 'joao@gmail.com',
        notificationCount: 5,
      ),
      body: body,
    );
  }
}
