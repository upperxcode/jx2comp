import 'package:flutter/material.dart';

import 'core/button_base.dart';
import 'core/button_types.dart';

class Jx2OutlinedButton extends Jx2ButtonBase {
  const Jx2OutlinedButton({
    super.key,
    required super.text,
    super.icon,
    super.type = Jx2ButtonType.primary,
    required super.onPressed,
    super.tooltip,
    super.textStyle,
    super.enabled = true,
    super.fullWidth = false,
    super.isLoading = false,
  }) : super(style: Jx2ButtonStyle.outlined);

  @override
  Widget buildButton() {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: myForegroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: enabled && !isLoading ? onPressed : null,
        child: isLoading
            ? CircularProgressIndicator(color: myForegroundColor)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) Icon(icon, size: 20),
                  if (icon != null) const SizedBox(width: 8),
                  Text(text, style: textStyle),
                ],
              ),
      ),
    );
  }
}