import 'package:flutter/material.dart';

class HLine extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;
  const HLine({this.height, this.thickness, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 5,
      thickness: thickness ?? 0.5,
      color: color ?? Colors.black38,
    );
  }
}
