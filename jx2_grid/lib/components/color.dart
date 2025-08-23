import 'package:flutter/material.dart';

enum JxColor3 {
  darkTitle(Colors.black54, Colors.white60),
  darkBody(Colors.black12, Colors.white70),
  darkIndicator(Colors.lightBlue, Colors.black);

  final Color background;
  final Color foreground;
  const JxColor3(this.background, this.foreground);
}
