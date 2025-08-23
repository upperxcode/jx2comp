import 'package:flutter/material.dart';

enum Jx2ButtonType { primary, secondary, success, danger, warning }

enum Jx2ButtonStyle { outlined, elevated, text, floating }

final Map<Jx2ButtonType, Color> jx2ButtonTypeColors = {
  Jx2ButtonType.primary: Colors.blue,
  Jx2ButtonType.secondary: Colors.grey,
  Jx2ButtonType.success: Colors.green,
  Jx2ButtonType.danger: Colors.red,
  Jx2ButtonType.warning: Colors.orange,
};
