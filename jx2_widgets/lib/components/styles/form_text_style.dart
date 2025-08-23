import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme.dart';

const radiuTextField = 5.0;

TextStyle jxFormTextStyle() {
  return TextStyle(
    fontSize: 18,
    height: 1,
    overflow: TextOverflow.clip,
    color: JxTheme.getColor(JxColor.formTextFont).foreground,
  );
}

TextStyle jxFormTextStyleLabel() {
  return TextStyle(
    color: JxTheme.getColor(JxColor.formTextFace).foreground,
    fontSize: 16,
    height: 0.8,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.clip,
  );
}

TextStyle jxFormTextStyleFloat() {
  return TextStyle(
    color: JxTheme.getColor(JxColor.formTextFace).foreground,
    backgroundColor: Colors.transparent,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1,
    overflow: TextOverflow.ellipsis,
  );
}

TextStyle jxErrorStyle() {
  return const TextStyle(fontSize: 10, height: 0.5, fontWeight: FontWeight.bold, color: Colors.red);
}

InputBorder jxFormTextBorderStyle() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: JxTheme.getColor(JxColor.formTextFace).background,
      width: 0,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(radiuTextField),
  );
}

BoxBorder jxBoxtBorderStyle() {
  return BoxBorder.all(
    color: JxTheme.getColor(JxColor.formTextFace).background,
    style: BorderStyle.solid,
  );
}

InputBorder jxFormTextBorderStyleEnabled() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black38, width: 1, style: BorderStyle.solid),
    borderRadius: BorderRadius.circular(radiuTextField),
  );
}

InputBorder jxFormTextBorderStyleFocus() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: JxTheme.getColor(JxColor.formTextHover).foreground,
      width: 2,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignOutside,
    ),
    borderRadius: BorderRadius.circular(radiuTextField),
  );
}
