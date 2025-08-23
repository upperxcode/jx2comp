import 'package:flutter/material.dart';

import 'utils.dart';

class JxTooltip extends StatelessWidget {
  final String message;
  const JxTooltip(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: const Duration(milliseconds: 400),
      showDuration: const Duration(seconds: 1),
      triggerMode: TooltipTriggerMode.tap,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Icon(
        Icons.info_outlined,
        color: Colors.blue.shade300,
        size: isMobile() ? 24 : 16,
      ),
    );
  }
}
