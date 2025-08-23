import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme.dart';

ButtonStyle buttonDialogStyle(JxColor color) {
  final color_ = JxTheme.getColor(color);
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(10),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    minimumSize: const Size(80, 50),
    backgroundColor: color_.background,
    foregroundColor: color_.foreground,
    disabledForegroundColor: Colors.black45,
    disabledBackgroundColor: Colors.black12,
    shadowColor: Colors.black38,
    //elevation: 15,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    tapTargetSize: MaterialTapTargetSize.padded,
  );
}
