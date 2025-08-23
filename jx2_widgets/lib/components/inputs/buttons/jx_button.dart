import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme.dart';

import '../../styles/button_style.dart';

class JxButton extends StatelessWidget {
  final Function()? onPressed;
  final String? label;
  final JxColor? color;
  final Icon? icon;
  final ButtonStyle? style;

  const JxButton({super.key, this.onPressed, this.label, this.color, this.icon, this.style});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon ?? const Icon(Icons.access_alarm),
      onPressed: onPressed,
      style: style ?? buttonStyle(color ?? JxColor.submit),
      label: Text(label ?? ""),
    );
  }
}
