import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme.dart';

ButtonStyle buttonStyleFull(JxColor color) {
  final color_ = JxTheme.getColor(color);
  return ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    minimumSize: const Size(360, 260),
    backgroundColor: color_.background,
    foregroundColor: color_.foreground,
    disabledForegroundColor: Colors.black45,
    disabledBackgroundColor: Colors.white54,
    shadowColor: Colors.black,
    elevation: 5,
    side: BorderSide(
      color: color_.foreground,
      width: 0.5,
      style: BorderStyle.solid,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    tapTargetSize: MaterialTapTargetSize.padded,
  );
}
