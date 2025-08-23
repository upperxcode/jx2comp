import 'package:flutter/material.dart';

import 'jx_row_button.dart';

class BaseDbNavigator extends StatelessWidget {
  final List<Widget> buttons;
  final MainAxisAlignment? alignment;
  final double? padding;
  const BaseDbNavigator(
    this.buttons, {
    this.padding,
    this.alignment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return JxRowButton(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: alignment ?? MainAxisAlignment.center,
      padding: padding ?? 0.0,
      buttons: buttons,
    );
  }
}
