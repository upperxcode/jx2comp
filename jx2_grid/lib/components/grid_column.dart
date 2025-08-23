import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jx2_grid/components/align2trina.dart';
import 'package:jx2_grid/components/fieldtype2trina.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/components/models/jx_field.dart';
import 'package:trina_grid/trina_grid.dart';

class GridColumn extends TrinaColumn {
  final String? displayName;
  final String fieldName;
  final FieldType fieldType;
  final Color? color;
  final bool invisible;
  final TextAlign align;
  final int? decimals;
  final String? format;
  final double length;

  GridColumn({
    required this.displayName,
    required this.fieldName,
    required this.fieldType,
    required this.color,
    this.invisible = false,
    this.decimals = 2,
    this.format,
    required this.length,
    this.align = TextAlign.start,
  }) : super(
         field: fieldName,
         title: displayName ?? fieldName,
         type: type2Trina(fieldType, decimalsDigits: decimals, format: format),
         backgroundColor: color,
         readOnly: true,
         hide: invisible,
         textAlign: align2Trina(align),

         width: length,
         //width: length ?? ((displayName != null) ? displayName.length.toDouble() : fieldName.length.toDouble()) * fieldName.length.,
       );
}

List<GridColumn> gridColumns(List<JxField> fields, {Color? color, TextStyle? style}) {
  List<GridColumn> columns = [];
  int index = 0;

  double width(String str, double? lenght) {
    String txtLenght = str.toUpperCase();
    if (txtLenght.length < (lenght ?? 1)) {
      for (var i = 0; i <= lenght!.toInt() + 2; i++) {
        txtLenght += "A";
      }
    } else {
      txtLenght += txtLenght.length < 15 ? "AAAA" : "AA";
    }

    final text = TextSpan(
      text: txtLenght,
      style:
          style ??
          TextStyle(fontSize: 16, color: JxTheme.getColor(JxColor.formFieldText).foreground),
    );
    final txt = TextPainter(text: text, textDirection: TextDirection.ltr, maxLines: 1);
    txt.layout(maxWidth: 400.0);
    return txt.width;
  }

  for (var item in fields) {
    if (index == 0) {
      columns.add(
        GridColumn(
          displayName: "index",
          fieldName: "index",
          fieldType: FieldType.ftInteger,
          invisible: true,
          color: color,
          length: 1,
        ),
      );
    }
    if (item.fieldType != FieldType.ftPassword && item.visible) {
      columns.add(
        GridColumn(
          displayName: item.displayName,
          fieldName: item.name,
          fieldType: item.fieldType,
          color: color,
          decimals: item.decimals,
          align: item.align,
          format: item.format,
          length: width(item.displayName ?? item.name, item.size.toDouble()),

          //invisible: !item.visible!,
        ),
      );
    }
    index++;
  }
  log("gridcolumns");
  return columns;
}
