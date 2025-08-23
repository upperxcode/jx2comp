import 'package:flutter/material.dart';
import 'button_types.dart';


abstract class Jx2ButtonBase extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Jx2ButtonType type;
  final Jx2ButtonStyle style;
  final VoidCallback onPressed;
  final String? tooltip;
  final TextStyle? textStyle;
  final bool enabled;
  final bool fullWidth;
  final bool isLoading;

  const Jx2ButtonBase({
    super.key,
    required this.text,
    this.icon,
    this.type = Jx2ButtonType.primary,
    this.style = Jx2ButtonStyle.elevated,
    required this.onPressed,
    this.tooltip,
    this.textStyle,
    this.enabled = true,
    this.fullWidth = false,
    this.isLoading = false,
  });

  Color get myBackgroundColor {
    if (!enabled) return Colors.grey;
    return jx2ButtonTypeColors[type] ?? Colors.blue;
  }

  Color get myForegroundColor {
    return style == Jx2ButtonStyle.elevated ? Colors.white : myBackgroundColor;
  }

  Color get borderColor {
    return style == Jx2ButtonStyle.outlined ? myBackgroundColor : Colors.transparent;
  }

  Widget buildButton();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: buildButton(),
    );
  }
}