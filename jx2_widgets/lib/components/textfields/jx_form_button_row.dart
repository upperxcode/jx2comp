import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/textfields/jx_form_button.dart';

import '../icons/jx_icon_icons.dart';

class Screen {
  static const smallWidth = 500;
  static const bigWidth = 1200;
}

class JxFormSubmitCancelButton extends StatelessWidget {
  final Function()? onSubmit;
  final Function()? onCancel;
  const JxFormSubmitCancelButton({super.key, this.onSubmit, this.onCancel});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool small = (width >= Screen.smallWidth);
    List<Widget> list = [
      Expanded(
        child: JxFormButton(
          icon: const Icon(JxIcon.save),
          onPressed: onSubmit,
          child: const Text('Salvar'),
        ),
      ),
      SizedBox(width: small ? 10 : 0, height: !small ? 10 : 0),
      Expanded(
        child: JxFormButton(
          icon: const Icon(JxIcon.settings_backup_restore),
          onPressed: onCancel,
          color: Colors.red.shade400,
          child: const Text('Restaurar'),
        ),
      ),
    ];
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: width >= Screen.smallWidth ? RoWFormbutton(list) : ColFormbutton(list),
      ),
    );
  }
}

class RoWFormbutton extends StatelessWidget {
  final List<Widget> children;
  const RoWFormbutton(this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }
}

class ColFormbutton extends StatelessWidget {
  final List<Widget> children;
  const ColFormbutton(this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
