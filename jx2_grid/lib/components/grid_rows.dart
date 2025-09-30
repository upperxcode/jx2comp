import 'package:jx_data/jx_data.dart';
import 'package:jx_utils/logs/jx_log.dart';
import 'package:trina_grid/trina_grid.dart';

List<TrinaRow> gridRows(Store model) {
  List<TrinaRow> rows = [];
  JxLog.info("model vazio? ${model.isEmpty}");
  if (model.isNotEmpty) {
    model.first();
    do {
      Map<String, TrinaCell> cells = {};
      int index = 0;
      for (var item in model.fields!) {
        final currentCells = TrinaCell(
          value: item.isFormated ? item.getFormattedValue() : item.value,
        );
        if (index == 0) {
          cells["index"] = TrinaCell(value: model.recno);
        }
        if (item.fieldType != FieldType.ftPassword && item.visible) {
          // Usamos item.toString() que retorna o valor formatado do controller,
          // mas para tipos que não são texto (como números e datas),
          // passamos o valor bruto (item.value) para que o TrinaGrid possa
          // fazer a ordenação e formatação nativa corretamente.
          cells[item.name] = currentCells;
          //JxLog.info("${item.value}");
        }
        index++;
      }
      rows.add(TrinaRow(cells: cells));
    } while (model.next());
  }
  JxLog.info("grid rows: ${rows.length}");
  return rows;
}
