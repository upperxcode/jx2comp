import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';

List<TrinaColumn> columns = [
  /// Text Column definition
  TrinaColumn(title: 'Text', field: 'text_field', type: TrinaColumnType.text()),

  /// Number Column definition
  TrinaColumn(
    title: 'number',
    field: 'number_field',
    type: TrinaColumnType.number(),
    backgroundColor: Colors.purple,
  ),

  /// Select Column definition
  TrinaColumn(
    title: 'select column',
    field: 'select_field',
    type: TrinaColumnType.select(['item1', 'item2', 'item3']),
  ),

  /// Datetime Column definition
  TrinaColumn(title: 'date column', field: 'date_field', type: TrinaColumnType.date()),

  /// Time Column definition
  TrinaColumn(
    title: 'time column',
    field: 'time_field',
    type: TrinaColumnType.time(),
    backgroundColor: Colors.yellow,
  ),
];

List<TrinaRow> rows = [
  TrinaRow(
    checked: true,
    type: TrinaRowType.normal(),
    cells: {
      'text_field': TrinaCell(value: 'Text cell value1'),
      'number_field': TrinaCell(value: 2020),
      'select_field': TrinaCell(value: 'item1'),
      'date_field': TrinaCell(value: '2020-08-06'),
      'time_field': TrinaCell(value: '12:30'),
    },
  ),
  TrinaRow(
    cells: {
      'text_field': TrinaCell(value: 'Text cell value2'),
      'number_field': TrinaCell(value: 2021),
      'select_field': TrinaCell(value: 'item2'),
      'date_field': TrinaCell(value: '2020-08-07'),
      'time_field': TrinaCell(value: '18:45'),
    },
  ),
  TrinaRow(
    cells: {
      'text_field': TrinaCell(value: 'Text cell value3'),
      'number_field': TrinaCell(value: 2022),
      'select_field': TrinaCell(value: 'item3'),
      'date_field': TrinaCell(value: '2020-08-08'),
      'time_field': TrinaCell(value: '23:59'),
    },
  ),
];

class GridExemple extends StatelessWidget {
  const GridExemple({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TrinaGrid Demo')),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: TrinaGrid(
          columns: columns,
          rows: rows,
          onChanged: (TrinaGridOnChangedEvent event) {
            log("event $event");
          },
          onLoaded: (TrinaGridOnLoadedEvent event) {
            event.stateManager.setSelectingMode(TrinaGridSelectingMode.row);

            //stateManager = event.stateManager;
          },
          rowColorCallback: (TrinaRowColorContext rowColorContext) {
            var color = Colors.white70;
            if (rowColorContext.rowIdx.isEven) {
              color = Colors.amber;
            }
            if (rowColorContext.row.cells.entries.elementAt(2).value.value == 'item3') {
              return Colors.blueAccent;
            } else if (rowColorContext.row.cells.entries.elementAt(2).value.value == 'item2') {
              return Colors.cyanAccent;
            }

            return color;
          },
        ),
      ),
    );
  }
}
