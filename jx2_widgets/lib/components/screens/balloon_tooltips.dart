import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class BalloonTooltip extends StatelessWidget {
  final String message;
  final Widget? child;

  const BalloonTooltip({super.key, required this.message, this.child});

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      backgroundColor: Colors.white,
      waitDuration: const Duration(milliseconds: 500),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(message, style: TextStyle(color: Colors.black87)),
      ),
      child: const Material(
        color: Colors.white,
        shape: CircleBorder(),
        elevation: 4.0,
        child: Icon(Icons.help_outlined, color: Colors.orangeAccent, size: 16),
      ),
    );
  }
}








// Tooltip(
//       waitDuration: const Duration(milliseconds: 500),
//       message: message,
//       padding: const EdgeInsets.all(10),
//       margin: const EdgeInsets.only(top: 20),
//       decoration: ShapeDecoration(
//         color: Colors.white,
//         shape: BalloonShapeBorder(),
//       ),
//       textStyle: const TextStyle(color: Colors.black87),
//       preferBelow: false,
//       showDuration: const Duration(milliseconds: 500),
//       child: child ?? const Icon(Icons.live_help_outlined, color: Colors.orangeAccent, size: 16),
//     );