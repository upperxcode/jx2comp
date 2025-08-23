import 'package:flutter/material.dart';

import 'snackbar_message.dart';

class CircularProgress extends StatelessWidget {
  final String errorMsg;
  final SMType snackType;
  final void Function()? onPressed;
  const CircularProgress({
    super.key,
    required this.errorMsg,
    required this.snackType,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        width: 200,
        child: IconButton(
          onPressed:
              (onPressed == null)
                  ? () => {snackMessage(context, errorMsg, () => {}, 5, snackType)}
                  : onPressed,
          icon: const CircularProgressIndicator(
            //color: Colors.red,
          ),
        ),
      ),
    );
  }
}
