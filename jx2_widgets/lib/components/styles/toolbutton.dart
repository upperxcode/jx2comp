import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme.dart';

ButtonStyle toolButtonStyle([JxColor? color, bool isCircle = true]) {
  final clr = JxTheme.getColor(color ?? JxColor.warning);
  return IconButton.styleFrom(
    minimumSize: const Size(30, 30),

    backgroundColor: clr.background,
    foregroundColor: clr.foreground,
    disabledForegroundColor: Colors.black45,
    disabledBackgroundColor: Colors.black12,
    hoverColor: JxTheme.getColor(JxColor.formTextHover).background,
    shadowColor: Colors.grey,

    shape:
        isCircle ? CircleBorder() : RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    side: BorderSide(color: Colors.black54, width: 2, style: BorderStyle.solid),

    elevation: 5,
    // side: const BorderSide(
    //     color: Colors.black54, width: 1, style: BorderStyle.solid),
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(0),
    // ),
    tapTargetSize: MaterialTapTargetSize.padded,
  );
}
