// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/icons/double_icons_row.dart';
import 'package:jx2_widgets/components/screens/balloon_tooltips.dart';
import 'package:jx2_widgets/components/styles/form_text_style.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_data/components/utils/type2icon.dart';
import 'package:jx_data/components/widgets/field_title.dart';
import 'package:jx_data/components/widgets/utils.dart';

class SimpleDropdown extends StatefulWidget {
  final JxField field;

  const SimpleDropdown({super.key, required this.field});
  @override
  _DropdownWithDecorationState createState() => _DropdownWithDecorationState();
}

class _DropdownWithDecorationState extends State<SimpleDropdown> {
  final tipMessage = 'Click no campo para alternar as opções.';

  @override
  Widget build(BuildContext context) {
    log("Value boolean => ${widget.field.value}");
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFieldTitle(),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            style: jxFormTextStyle(),
            value: widget.field.value == true ? "SIM" : "NÃO",
            decoration: buildInputDecoration(widget.field),
            onChanged: (String? newValue) {
              setState(() {
                widget.field.value = newValue == "SIM" ? true : false;
                widget.field.controller.text = newValue == "SIM" ? "true" : "false";
                log("changed controller ${widget.field.controller.text}");
              });
            },
            items:
                <String>['SIM', 'NÃO'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildFieldTitle() {
    return widget.field.tip.isNotEmpty
        ? Row(
          children: [
            FieldTitle(widget.field.displayName ?? widget.field.name),
            const SizedBox(width: 5),
            BalloonTooltip(message: "${widget.field.tip}$tipMessage"),
          ],
        )
        : FieldTitle(widget.field.displayName ?? widget.field.name);
  }

  InputDecoration buildInputDecoration(JxField field) {
    return InputDecoration(
      counter: const Offstage(),
      isDense: true,
      floatingLabelStyle: jxFormTextStyleFloat(),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: jxFormTextStyleLabel(),
      errorStyle: jxErrorStyle(),
      contentPadding: padding(),
      suffixIcon: DoubleIconsRow(
        onTap1: () => {},
        onTap2: () => {},
        icon1:
            field.icon ??
            type2Icon(field.fieldType, JxTheme.getColor(JxColor.formTextIcon).background),
        icon2: null,
      ),
      filled: true,
      border: jxFormTextBorderStyle(),
      hoverColor: JxTheme.getColor(JxColor.formTextHover).background,
      fillColor: JxTheme.getColor(JxColor.formTextHover).foreground,
      focusedBorder: jxFormTextBorderStyleFocus(),
      enabledBorder: jxFormTextBorderStyleEnabled(),
      hintText: field.placeholder,
    );
  }
}
