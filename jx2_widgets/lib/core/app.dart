import 'package:flutter/material.dart';

class Jx2App extends StatefulWidget {
  final String title;
  final ThemeData theme;
  final Widget? home;
  final Map<String, Widget Function(BuildContext)>? routes;
  final Map<String, dynamic>? profileData;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  const Jx2App({
    super.key,
    required this.title,
    required this.theme,
    this.home,
    this.routes,
    this.profileData,
    this.scaffoldMessengerKey,
  });

  @override
  State<Jx2App> createState() => _AppState();
}

class _AppState extends State<Jx2App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: widget.scaffoldMessengerKey,
      title: widget.title,
      theme: widget.theme,
      home: widget.home,
      routes: widget.routes ?? {},
    );
  }
}
