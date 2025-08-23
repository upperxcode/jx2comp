import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/icons/double_icons_row.dart';
import 'package:jx2_widgets/components/screens/balloon_tooltips.dart';
import 'package:jx2_widgets/components/styles/form_text_style.dart';
import 'package:jx2_widgets/components/textfields/suffix_icon.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_data/components/widgets/field_title.dart';
import '../utils/type2icon.dart';
import '../utils/type2keyboard.dart';
import 'format.dart';
import 'utils.dart';
import 'validate.dart';

class JxFieldForm extends StatefulWidget {
  final JxField field;
  final Function(String)? onChanged;
  final bool? autofocus;
  final bool? readonly;

  const JxFieldForm(
    this.field, {
    this.onChanged,
    this.autofocus = false,
    this.readonly = false,
    super.key,
  });

  @override
  State<JxFieldForm> createState() => _JxFieldFormState();
}

class _JxFieldFormState extends State<JxFieldForm> {
  late FieldType type;
  late bool obscure;
  late Icon suffixIcon;
  final visibleIcon = const Icon(Icons.disabled_visible, color: Colors.red);
  final invisbleIcon = const Icon(Icons.remove_red_eye, color: Colors.blue);
  final clearIcon = Icon(
    Icons.backspace,
    color: JxTheme.getColor(JxColor.formTextIcon).background,
    size: 24,
  );
  String tipMessage = "";
  FocusNode focusNode = FocusNode();
  dynamic oldValue;

  void _obscureText() {
    setState(() {
      obscure = !obscure;
      suffixIcon = obscure ? visibleIcon : invisbleIcon;
    });
  }

  void _clearText() {
    setState(() {
      isEmpty = true;

      widget.field.controller.text = '';
    });
  }

  @override
  void initState() {
    super.initState();
    type = widget.field.type;
    obscure = (type == FieldType.ftPassword || type == FieldType.ftPasswordConfirm);
    suffixIcon = obscure ? visibleIcon : clearIcon;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // Salve o valor aqui
        saveValue(widget.field.value);
      }
    });
    switch (type) {
      case FieldType.ftInteger:
        tipMessage = "Somente número são aceitos.";
        break;
      case FieldType.ftDouble:
      case FieldType.ftMoney:
        tipMessage = "Somente número são aceitos, ao confirmar a formatação será aplicada.";
        break;
      default:
        tipMessage =
            "São aceitos qualquer caracter válido, mas evite o uso de aspas por prejudicarem em futuras buscas.";
    }
  }

  void saveValue(dynamic value) {
    // Salvando o valor em algum lugar
    oldValue = value;
    // Salve 'valueToSave' onde você precisar, como em SharedPreferences ou em um estado global
  }

  void _returnOldValue() {
    widget.field.value = oldValue;
    setState(() {
      isEmpty = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.field.tip.isNotEmpty
              ? Row(
                  children: [
                    FieldTitle(widget.field.displayName ?? widget.field.name),
                    const SizedBox(width: 5),
                    BalloonTooltip(message: "${widget.field.tip}$tipMessage"),
                  ],
                )
              : FieldTitle(widget.field.displayName ?? widget.field.name),
          const SizedBox(height: 5),
          SizedBox(
            height: isMobile() ? 60 : 45,
            child: TextFormField(
              keyboardType: type2Keyboard(type),
              readOnly: widget.field.readOnly,
              controller: widget.field.controller,
              autofocus: widget.autofocus!,
              focusNode: focusNode,

              //initialValue: "${widget.field.value}",
              onChanged: (v) {
                log("changed controller ${widget.field.controller.text}");
                log("changed value $v");
                log("changed field ${widget.field.value}");

                setState(() {
                  // widget.field.value = v;
                  isEmpty = v.isEmpty;
                  if (widget.onChanged != null) {
                    widget.onChanged!(v);
                  }
                });
                // Não altere o controller.text aqui para evitar seleção e substituição
              },
              maxLength: widget.field.size > 0 ? widget.field.size : null,
              obscureText: obscure,
              validator: (value) => validate(value, widget.field, widget.field.match),
              textAlign: widget.field.align,
              inputFormatters: format(widget.field),

              style: jxFormTextStyle(),
              decoration: InputDecoration(
                //helperText: null,
                //errorText: null,
                counter: const Offstage(),
                isDense: true,
                floatingLabelStyle: jxFormTextStyleFloat(),
                floatingLabelBehavior: FloatingLabelBehavior.always,

                labelStyle: jxFormTextStyleLabel(),
                errorStyle: jxErrorStyle(),
                contentPadding: padding(),
                label: null,

                //prefixIcon: widget.field.icon ?? type2Icon(type),
                suffixIcon: widget.field.readOnly
                    ? widget.field.icon ?? type2Icon(type)
                    : isEmpty
                    ? DoubleIconsRow(
                        onTap1: () => {},
                        onTap2: () => {},
                        icon1: widget.field.readOnly
                            ? widget.field.icon ?? type2Icon(type)
                            : isEmpty
                            ? widget.field.icon ??
                                  type2Icon(type, JxTheme.getColor(JxColor.formTextIcon).background)
                            : JxSuffixIcon(
                                onTap:
                                    (widget.field.type == FieldType.ftPassword ||
                                        widget.field.type == FieldType.ftPasswordConfirm)
                                    ? _obscureText
                                    : _clearText,
                                child: suffixIcon,
                              ),
                        icon2: null,
                      )
                    : DoubleIconsRow(
                        onTap1: _clearText,
                        onTap2: _returnOldValue,
                        icon1: suffixIcon,
                        icon2: const Icon(Icons.cancel_rounded, color: Colors.red, size: 24),
                      ),

                filled: true,
                border: jxFormTextBorderStyle(),
                hoverColor: JxTheme.getColor(JxColor.formTextHover).background,
                fillColor: JxTheme.getColor(JxColor.formTextFace).background,
                focusedBorder: jxFormTextBorderStyleFocus(),
                enabledBorder: jxFormTextBorderStyleEnabled(),
                hintText: widget.field.placeholder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
