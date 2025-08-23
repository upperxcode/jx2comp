import 'package:flutter/material.dart';

class GenericFormModal {
  static Future<void> showFormModal({
    required BuildContext context,
    required Widget formContent,
    required GlobalKey<FormState> formKey,
    required VoidCallback onSave,
    String? title,
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Formulário'),
          content: Form(key: formKey, child: formContent),
          actions: <Widget>[
            TextButton(child: Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
            TextButton(onPressed: onSave, child: Text('Salvar')),
          ],
        );
      },
    );
  }
}
