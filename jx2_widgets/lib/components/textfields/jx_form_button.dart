import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme/enums.dart';
import 'package:jx2_widgets/core/theme/jx_theme.dart';

class JxFormButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final Color? color;
  final Color? backgroundColor;
  final Icon? icon;

  const JxFormButton({
    super.key,
    this.onPressed,
    required this.child,
    this.color,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon ?? const Icon(Icons.confirmation_num),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? JxTheme.getColor(JxColor.primary).background,
        fixedSize: const Size.fromHeight(50),
        foregroundColor: color ?? JxTheme.getColor(JxColor.primary).foreground,
      ),
      label: child,
    );
  }
}
