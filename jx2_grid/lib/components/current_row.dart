import 'package:trina_grid/trina_grid.dart';

class CurrentRow {
  CurrentRow();
  bool get isEven => _context!.rowIdx.isEven;

  TrinaRowColorContext? _context;

  set context(v) => _context = v;
  TrinaRowColorContext? get context => _context;
  int get rowIndex => _context!.rowIdx;

  bool get isOdd => _context!.rowIdx.isOdd;
  dynamic value(int column) {
    if (_context == null) return 0;
    final row = _context!.row.cells.entries;
    final el = row.elementAt(column).value.value;
    return el;
  }
}
