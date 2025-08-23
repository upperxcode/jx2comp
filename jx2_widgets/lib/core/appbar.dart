import 'package:flutter/material.dart';

class Jx2AppBar extends StatefulWidget implements PreferredSizeWidget {
  const Jx2AppBar({
    super.key,
    required this.title,
    required this.actions,
    required this.backgroundColor,
  });

  final String title;
  final List<Widget> actions;
  final Color backgroundColor;

  @override
  State<Jx2AppBar> createState() => _JxAppBarState();

  @override
  Size get preferredSize => Size(double.infinity, 60.0);
}

class _JxAppBarState extends State<Jx2AppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: widget.actions,
      backgroundColor: widget.backgroundColor,
    );
  }
}
