import 'package:flutter/material.dart';

class FieldTitle extends StatelessWidget {
  final String title;
  const FieldTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        backgroundColor: Colors.transparent,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }
}
