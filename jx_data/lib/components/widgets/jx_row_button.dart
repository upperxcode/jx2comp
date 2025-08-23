import 'package:flutter/material.dart';

class JxRowButton extends StatelessWidget {
  final List<Widget> buttons;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double padding;
  const JxRowButton({
    required this.buttons,
    this.padding = 0.0,
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: buttons,
      ),
    );
  }
}
