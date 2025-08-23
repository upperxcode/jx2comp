import 'package:flutter/material.dart';

class JxRowForm extends StatelessWidget {
  final List<Widget> children;
  const JxRowForm({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: children);
  }
}
