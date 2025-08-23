import 'package:flutter/material.dart';

import 'package:jx2_widgets/components/dialogs/dialog_base.dart';
import 'package:jx2_widgets/components/styles/button_dialog.dart';
import 'package:jx2_widgets/core/theme.dart';

Future<bool> msgQuestion(BuildContext context, String msg) async {
  bool ok = false;
  // showDialog<void> since we are not using the result of showDialog
  await showDialog<void>(
    context: context,
    builder: (BuildContext ctx) {
      return DialogBase(
        "Por favor confirme",
        Text(msg),
        icon: const Icon(
          Icons.circle_notifications_rounded,
          color: Colors.red,
          size: 60,
        ),
        actions: [
          // The "Yes" button
          TextButton(
            onPressed: () {
              ok = true;
              Navigator.of(
                ctx,
              ).pop(); // Use ctx which is the context of the dialog
            },
            style: buttonDialogStyle(JxColor.confirm),
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                ctx,
              ).pop(); // Use ctx to ensure we're popping the dialog's context
            },
            style: buttonDialogStyle(JxColor.warning),
            child: const Text('No'),
          ),
        ],
      );
    },
  );
  return ok;
}
