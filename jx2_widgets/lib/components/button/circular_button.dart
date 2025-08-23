import 'package:flutter/material.dart';

import 'core/button_base.dart';
import 'core/button_types.dart';

class Jx2CircularButton extends Jx2ButtonBase {
  @override
  final IconData icon;
  final double size;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const Jx2CircularButton({
    super.key,
    required this.icon,
    this.size = 56.0, // Tamanho padrão do botão circular
    super.type = Jx2ButtonType.primary,
    required super.onPressed,
    super.tooltip,
    super.enabled = true,
    super.isLoading = false,
    this.elevation = 6.0,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(
         style: Jx2ButtonStyle.elevated,
         text: '', // Botão circular geralmente não tem texto
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
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: myBackgroundColor,
          foregroundColor: myForegroundColor,
          elevation: elevation,
          shape: const CircleBorder(), // Formato circular
          padding: EdgeInsets.zero, // Remove padding interno
        ),
        onPressed: enabled && !isLoading ? onPressed : null,
        child:
            isLoading
                ? CircularProgressIndicator(color: myForegroundColor)
                : Icon(
                  icon,
                  size: size * 0.5,
                ), // Tamanho do ícone proporcional ao botão
      ),
    );
  }
}
