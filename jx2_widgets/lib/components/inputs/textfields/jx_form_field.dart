import 'package:flutter/material.dart';

class JxFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final InputBorder? border;
  const JxFormField({
    this.controller,
    this.hintText,
    this.labelText,
    this.icon,
    this.border,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          counter: const Offstage(),
          icon: Icon(icon ?? Icons.calendar_today),
          hintText: hintText ?? "",
          labelText: labelText ?? "",
          border:
              border ??
              const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
      ),
    );
  }
}
