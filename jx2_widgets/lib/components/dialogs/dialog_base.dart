import 'package:flutter/material.dart';

class DialogBase extends StatelessWidget {
  final Widget content;
  final List<Widget> actions;
  final String title;
  final Icon? icon;
  const DialogBase(this.title, this.content, {required this.actions, this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon ?? const Icon(Icons.circle_notifications, color: Colors.redAccent, size: 60.0),
          Text(title),
        ],
      ),
      content: content,
      actions: actions,
    );
  }
}
