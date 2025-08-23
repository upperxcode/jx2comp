import 'package:flutter/material.dart';

class BalloonTooltip2 extends StatelessWidget {
  final String message;
  final Widget? child;

  const BalloonTooltip2({super.key, required this.message, this.child});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: const Duration(milliseconds: 500),
      message: message,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 20),
      decoration: ShapeDecoration(color: Colors.white, shape: BalloonShapeBorder()),
      textStyle: const TextStyle(color: Colors.black87),
      preferBelow: false,
      showDuration: const Duration(milliseconds: 500),
      child: child ?? const Icon(Icons.live_help_outlined, color: Colors.orangeAccent, size: 16),
    );
  }
}

class BalloonShapeBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.only();

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const arrowWidth = 10.0;
    const arrowHeight = 10.0;

    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10.0)));
    path.moveTo(rect.bottomCenter.dx - arrowWidth / 2, rect.bottomCenter.dy);
    path.lineTo(rect.bottomCenter.dx, rect.bottomCenter.dy + arrowHeight);
    path.lineTo(rect.bottomCenter.dx + arrowWidth / 2, rect.bottomCenter.dy);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
