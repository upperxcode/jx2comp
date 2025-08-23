import 'package:flutter/material.dart';
import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_data/components/widgets/jx_field_form.dart';

class JxFieldFormExp extends StatelessWidget {
  final int flex;
  final JxField field;
  const JxFieldFormExp(this.field, {super.key, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: JxFieldForm(field));
  }
}
