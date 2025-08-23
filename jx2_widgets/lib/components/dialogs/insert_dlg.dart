import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme.dart';

import '../styles/button_dialog.dart';
import 'dialog_base.dart';

Future<bool> insertDlg(BuildContext context) async {
  bool ok = false;
  await showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return DialogBase(
        "Please Confirm",
        const Text('Deseja incluir o item digitado na tabela?'),
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
              Navigator.of(context).pop();
            },
            style: buttonDialogStyle(JxColor.confirm),
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
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
