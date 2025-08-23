import 'package:flutter/material.dart';

class JxSuffixIcon extends StatelessWidget {
  final Function() onTap;
  final Widget child;
  const JxSuffixIcon({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}
