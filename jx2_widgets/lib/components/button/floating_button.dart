import 'package:flutter/material.dart';

import 'core/button_base.dart';
import 'core/button_types.dart';

class Jx2FloatingButton extends Jx2ButtonBase {

  final double elevation;
  final Color? backgroundColor; // Renomeado para evitar conflito
  final Color? foregroundColor; // Renomeado para evitar conflito

  const Jx2FloatingButton({
    super.key,
    super.icon,
    super.type = Jx2ButtonType.primary,
    required super.onPressed,
    super.tooltip,
    super.enabled = true,
    super.isLoading = false,
    this.elevation = 6.0,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(
          style: Jx2ButtonStyle.floating,
          text: '', // Botão flutuante geralmente não tem texto
        );

  @override
  Color get myBackgroundColor {
    if (!enabled) return Colors.grey; // Botão desabilitado
    return backgroundColor ?? jx2ButtonTypeColors[type] ?? Colors.blue;
  }

  @override
  Color get myForegroundColor {
    return foregroundColor ?? Colors.white;
  }

  @override
  Widget buildButton() {
    
    return FloatingActionButton(
      backgroundColor: myBackgroundColor,
      foregroundColor: myForegroundColor,
      elevation: elevation,
      onPressed: enabled && !isLoading ? onPressed : null,
      tooltip: tooltip,
      child: isLoading
          ? CircularProgressIndicator(
              color: foregroundColor,
            )
          : Icon(icon),
    );
  }
}