import 'dart:developer';

import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_data/jx_data.dart';
import 'package:trina_grid/trina_grid.dart';

List<TrinaRow> gridRows(BaseStore model) {
  List<TrinaRow> rows = [];

  model.first();
  do {
    Map<String, TrinaCell> cells = {};
    int index = 0;
    for (var item in model.fields!) {
      if (index == 0) {
        cells["index"] = TrinaCell(value: model.recno);
      }
      if (item.fieldType != FieldType.ftPassword && item.visible) {
        cells[item.name] = TrinaCell(value: item.value);
        //log("${item.value}");
      }
      index++;
    }
    rows.add(TrinaRow(cells: cells));
  } while (model.next());
  log("grid rows: ${rows.length}");
  return rows;
}
