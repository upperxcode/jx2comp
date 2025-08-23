import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jx2_grid/components/current_row.dart';
import 'package:jx2_grid/components/datagrid.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/jx_data.dart';

import 'package:trina_grid/trina_grid.dart';

class GridPage extends StatefulWidget {
  final Store dataController;
  final Widget? dbNavigator;
  final DataGrid dataGrid;
  final bool darkMode;
  final Color Function(CurrentRow) rowColorCallback;

  const GridPage({
    super.key,
    required this.dataController,
    this.dbNavigator,
    required this.dataGrid,
    this.darkMode = false,
    required this.rowColorCallback,
  });

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  late Future<void> _initDataGridFuture;
  late TrinaGrid _dataGrid;

  @override
  void initState() {
    super.initState();
    // Inicialize o futuro que carrega os dados do grid
    log("gridPage initState");
    widget.dataGrid.rowColorCallback = widget.rowColorCallback;
    _initDataGridFuture = _loadDataGrid();
  }

  Future<void> _loadDataGrid() async {
    log("gridPage loagGrid init");
    await widget.dataGrid.refreshGrid();
    _dataGrid = widget.dataGrid.datagrid();
    log("gridPage loagGrid finally");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initDataGridFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Apenas construa o widget DataGrid após a inicialização estar completa.
          return Container(
            color: JxTheme.getColor(JxColor.panel).background,
            padding: const EdgeInsets.all(2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(flex: 11, child: _dataGrid),
                  //const SizedBox(height: 2),
                  if (widget.dbNavigator != null) Flexible(flex: 1, child: widget.dbNavigator!),
                ],
              ),
            ),
          );
        } else {
          // Alternativamente, mostre um indicador de carregamento enquanto os dados estão sendo preparados
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

/// TrinaGrid Example
//
/// For more examples, go to the demo web link on the github below.
class TrinaGridExamplePage extends StatefulWidget {
  const TrinaGridExamplePage({super.key});

  @override
  State<TrinaGridExamplePage> createState() => _TrinaGridExamplePageState();
}

class _TrinaGridExamplePageState extends State<TrinaGridExamplePage> {
  final List<TrinaColumn> columns = <TrinaColumn>[
    TrinaColumn(title: 'Id', field: 'id', type: TrinaColumnType.text()),
    TrinaColumn(title: 'Name', field: 'name', type: TrinaColumnType.text()),
    TrinaColumn(title: 'Age', field: 'age', type: TrinaColumnType.number()),
    TrinaColumn(
      title: 'Role',
      field: 'role',
      type: TrinaColumnType.select(<String>['Programmer', 'Designer', 'Owner']),
    ),
    TrinaColumn(
      title: 'Role 2',
      field: 'role2',
      type: TrinaColumnType.select(<String>['Programmer', 'Designer', 'Owner']),
    ),
    TrinaColumn(title: 'Joined', field: 'joined', type: TrinaColumnType.date()),
    TrinaColumn(title: 'Working time', field: 'working_time', type: TrinaColumnType.time()),
    TrinaColumn(
      title: 'salary',
      field: 'salary',
      type: TrinaColumnType.currency(),
      footerRenderer: (rendererContext) {
        return TrinaAggregateColumnFooter(
          rendererContext: rendererContext,
          formatAsCurrency: true,
          type: TrinaAggregateColumnType.sum,
          format: '#,###',
          alignment: Alignment.center,
          titleSpanBuilder: (text) {
            return [
              const TextSpan(
                text: 'Sum',
                style: TextStyle(color: Colors.red),
              ),
              const TextSpan(text: ' : '),
              TextSpan(text: text),
            ];
          },
        );
      },
    ),
  ];

  final List<TrinaRow> rows = [
    TrinaRow(
      cells: {
        'id': TrinaCell(value: 'user1'),
        'name': TrinaCell(value: 'Mike'),
        'age': TrinaCell(value: 20),
        'role': TrinaCell(value: 'Programmer'),
        'role2': TrinaCell(value: 'Programmer'),
        'joined': TrinaCell(value: '2021-01-01'),
        'working_time': TrinaCell(value: '09:00'),
        'salary': TrinaCell(value: 300),
      },
    ),
    TrinaRow(
      cells: {
        'id': TrinaCell(value: 'user2'),
        'name': TrinaCell(value: 'Jack'),
        'age': TrinaCell(value: 25),
        'role': TrinaCell(value: 'Designer'),
        'role2': TrinaCell(value: 'Designer'),
        'joined': TrinaCell(value: '2021-02-01'),
        'working_time': TrinaCell(value: '10:00'),
        'salary': TrinaCell(value: 400),
      },
    ),
    TrinaRow(
      cells: {
        'id': TrinaCell(value: 'user3'),
        'name': TrinaCell(value: 'Suzi'),
        'age': TrinaCell(value: 40),
        'role': TrinaCell(value: 'Owner'),
        'role2': TrinaCell(value: 'Owner'),
        'joined': TrinaCell(value: '2021-03-01'),
        'working_time': TrinaCell(value: '11:00'),
        'salary': TrinaCell(value: 700),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<TrinaColumnGroup> columnGroups = [
    TrinaColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    TrinaColumnGroup(title: 'User information', fields: ['name', 'age']),
    TrinaColumnGroup(
      title: 'Status',
      children: [
        TrinaColumnGroup(title: 'A', fields: ['role'], expandedColumn: true),
        TrinaColumnGroup(title: 'Etc.', fields: ['joined', 'working_time', 'role2']),
      ],
    ),
  ];

  /// [TrinaGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final TrinaGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: TrinaGrid(
          columns: columns,
          rows: rows,
          columnGroups: columnGroups,
          onLoaded: (TrinaGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
          },
          onChanged: (TrinaGridOnChangedEvent event) {
            print(event);
          },
          configuration: const TrinaGridConfiguration(),
          selectDateCallback: (TrinaCell cell, TrinaColumn column) async {
            return showDatePicker(
              context: context,
              initialDate:
                  TrinaDateTimeHelper.parseOrNullWithFormat(cell.value, column.type.date.format) ??
                  DateTime.now(),
              firstDate: column.type.date.startDate ?? DateTime(0),
              lastDate: column.type.date.endDate ?? DateTime(9999),
            );
          },
        ),
      ),
    );
  }
}
