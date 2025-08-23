import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme.dart';
import '../../styles/toolbutton.dart';

class JxIconButton extends StatelessWidget {
  final Function()? onPressed;
  final String? label;
  final JxColor? color;
  final Icon? icon;
  final ButtonStyle? style;
  final String? tooltip;

  const JxIconButton({
    super.key,
    this.onPressed,
    this.label,
    this.color,
    this.icon,
    this.style,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: IconButton(
        icon: icon ?? const Icon(Icons.access_alarm),
        onPressed: onPressed,
        style: style ?? toolButtonStyle(color ?? JxColor.dbNav),
        tooltip: tooltip,
      ),
    );
  }
}
