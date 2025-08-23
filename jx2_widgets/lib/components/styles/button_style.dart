import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme.dart';

ButtonStyle buttonStyle(JxColor color) {
  final color_ = JxTheme.getColor(color);
  return ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    minimumSize: const Size(60, 60),
    backgroundColor: color_.background,
    foregroundColor: color_.foreground,
    disabledForegroundColor: Colors.black45,
    disabledBackgroundColor: Colors.white54,
    shadowColor: Colors.black,
    elevation: 10,
    side: BorderSide(
      color: color_.foreground,
      width: 0.5,
      style: BorderStyle.solid,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    tapTargetSize: MaterialTapTargetSize.padded,
  );
}

List<BoxShadow> boxInset() {
  return [
    BoxShadow(
      color: Colors.grey.shade600,
      offset: const Offset(-5, -5),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Colors.white,
      offset: Offset(5, 5),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];
}

List<BoxShadow> boxOutset() {
  return [
    BoxShadow(
      color: Colors.grey.shade600,
      spreadRadius: 0.5,
      blurRadius: 12,
      offset: const Offset(5, 5),
    ),
    const BoxShadow(
      color: Colors.white,
      offset: Offset(-5, -1),
      blurRadius: 12,
      spreadRadius: 0.5,
    ),
  ];
}
