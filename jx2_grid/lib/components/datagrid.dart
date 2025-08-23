import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jx2_grid/components/current_row.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/jx_data.dart';

import 'package:trina_grid/trina_grid.dart';
import 'grid_column.dart';
import 'grid_rows.dart';

class DataGrid {
  TrinaGridStateManager? stateManager;
  final Store controller;
  List<TrinaColumn>? columns;
  List<TrinaRow>? rows;
  late CurrentRow currentRow = CurrentRow();
  late Color Function(CurrentRow)? rowColorCallback;
  final TrinaAutoSizeMode? autoSizeMode;
  final TextStyle? textStyle;
  final bool darkMode;
  bool loaded = false;

  int _activeRow = 0;
  TrinaGrid? _trinaGrid;

  DataGrid(
    this.controller, {
    required this.rowColorCallback,
    this.autoSizeMode,
    this.textStyle,
    this.darkMode = false,
  }) {
    //columns = gridColumns(controller.fields, style: textStyle);
    //rows = gridRows(controller);
    log("refreshGrid datagrid 1");
    //refreshGrid();
  }

  set colorCallBack(Color Function(CurrentRow) func) {
    rowColorCallback = func;
  }

  void initTrinaGrid() {
    if (loaded) return;
    log("refreshGrid datagrid 2");
    //refreshGrid();
    _trinaGrid = _createTrinaGrid();
    loaded = true;
  }

  Future<bool> refreshGrid() async {
    try {
      if (stateManager == null) {
        if (columns != null) {
          columns = gridColumns(controller.fields!, style: textStyle);
        }
        await controller.refresh("gride stataManager == null");
        rows = gridRows(controller);
        return true;
      }
      stateManager?.setShowLoading(true); // Inicie o indicador de carregamento.

      // Atualize os dados chamando a função refresh do controller.
      await controller.refresh("gride!");

      // Obtenha as novas linhas baseadas nos dados atualizados do controller.
      final newRows = gridRows(controller);

      // Reinicialize o estado do grid e adicione as novas linhas, sem notificar ainda.
      stateManager?.resetCurrentState(notify: false);
      stateManager?.removeAllRows();
      stateManager?.appendRows(newRows);

      // Finalmente, desative o indicador de carregamento.
      stateManager?.setShowLoading(false);

      // Notifique os ouvintes após a atualização bem-sucedida dos dados.
      stateManager?.notifyListeners();
    } catch (e) {
      stateManager?.setShowLoading(false);
      return false; // Retorne false devido ao erro.
    }

    return true; // Retorne true quando a atualização for bem-sucedida.
  }

  int get activeRow => _activeRow;
  int get currentIndex => stateManager?.currentRowIdx ?? 0;

  void updateGrid() {
    if (controller.dbstate == DbState.update) {
      _updateRow();
    } else if (controller.dbstate == DbState.insert) {
      _insertRow();
    }
  }

  bool isCellSelected() => stateManager?.currentCellPosition != null;

  void _newRow(int position, {bool replace = false}) {
    if (stateManager == null) {
      // Handle the case when stateManager is not initialized.
      log('StateManager is not available.');
      return;
    }

    // Ensure the position is within the range of existing rows.
    int rowCount = stateManager!.rows.length;
    if (position < 0 || position > rowCount) {
      // Handle the case when the position is out of bounds.
      log('Position is out of bounds.');
      return;
    }

    // Create a new row data.
    final row = _createRowData(position, replace: replace);

    // Replace the current row if needed.
    if (replace) {
      // Ensure we have a current row selected.
      if (stateManager!.currentRowIdx == null) {
        log('No current row selected to replace.');
        return;
      }
      // Remove the current row.
      stateManager!.removeRows([stateManager!.rows[position]]);
    }

    // Insert the new row at the specified position.
    stateManager!.insertRows(position, [TrinaRow(cells: row)]);

    // Set the newly inserted row as the current row.
    stateManager!.setCurrentCellPosition(TrinaGridCellPosition(columnIdx: 0, rowIdx: position));

    // Refresh the UI.
    stateManager!.notifyListeners();
  }

  void _insertRow() {
    if (controller.dbstate != DbState.insert) return;
    _newRow(stateManager!.rows.length);
    controller.dbstate = DbState.browser;
  }

  void _updateRow() {
    if (controller.dbstate != DbState.update) return;
    _newRow(_activeRow, replace: true);
    controller.dbstate = DbState.browser;
  }

  Map<String, TrinaCell> _createRowData(int position, {bool replace = false}) {
    final row = <String, TrinaCell>{};
    if (!replace) controller.last();
    row["index"] = TrinaCell(value: position);
    for (var field in controller.fields!) {
      var value = controller.fieldByName(field.name);
      row[field.name] = TrinaCell(value: value);
    }
    return row;
  }

  TrinaGrid datagrid() {
    //columns = gridColumns(controller.fields, style: textStyle);
    //rows = gridRows(controller);
    initTrinaGrid();
    return _trinaGrid ?? const TrinaGrid(columns: [], rows: []);
  }

  TrinaGrid _createTrinaGrid() {
    return TrinaGrid(
      columns: columns ?? gridColumns(controller.fields!, style: textStyle),
      rows: rows ?? gridRows(controller),
      mode: TrinaGridMode.select,
      // autoSizeMode is not a valid parameter, removing it
      configuration: _config(),
      rowColorCallback: _rowColor,
      onLoaded: _onGridLoaded,
      onSorted: _onTrinaGridSortedEvent,
      onChanged: _onTrinaGridChangedEvent,
    );
  }

  void _onGridLoaded(TrinaGridOnLoadedEvent event) {
    stateManager = event.stateManager;
    stateManager?.setSelectingMode(TrinaGridSelectingMode.row);
    stateManager?.addListener(_onRowStateChanged);
  }

  void _onTrinaGridChangedEvent(TrinaGridOnChangedEvent event) {
    log("Trina event $event");
  }

  void _onTrinaGridSortedEvent(TrinaGridOnSortedEvent event) {
    log("Trina event $event");
  }

  Color _rowColor(TrinaRowColorContext colorContext) {
    if (rowColorCallback != null) {
      final currentRow = CurrentRow();
      currentRow.context = colorContext;
      final rowColor = rowColorCallback!(currentRow);
      return rowColor;
    }

    return Colors.blue.withValues(alpha: 0.5, red: 0.5, colorSpace: ColorSpace.sRGB);
  }

  void _onRowStateChanged() {
    if (controller.dbstate == DbState.browser) {
      _syncRows();
      controller.updateControllerByData();
    }
  }

  //sincroniza o vetor da tabela no mesmo item que está selecionado no gride
  void _syncRows() {
    //se não existe linha selecionada, não é possível posicionar cursor no vetor da tabela
    _activeRow = stateManager?.currentRowIdx ?? 0;
    //usa a primeira coluna que guarda a posição absuluta da linha no vetor da tabela
    //essa coluna não é visível
    if (_activeRow != 0) {
      final relativeRow = stateManager?.currentRow?.cells.values.elementAt(0).value;
      log("currentRow => $relativeRow");
      controller.recno = relativeRow;
    }
  }

  TrinaGridConfiguration _config() {
    return TrinaGridConfiguration(
      localeText: localeText(),
      columnSize: TrinaGridColumnSizeConfig(
        autoSizeMode: autoSizeMode ?? TrinaAutoSizeMode.scale,
        resizeMode: TrinaResizeMode.normal,
      ),
      style: TrinaGridStyleConfig(
        rowHeight: 30,
        columnHeight: 35,
        columnTextStyle: textStyle ?? const TextStyle(fontSize: 16),

        borderColor: JxTheme.getColor(JxColor.gridBorder).background,
        gridBackgroundColor: JxTheme.getColor(JxColor.grid).background,
        activatedColor: JxTheme.getColor(JxColor.gridSelection).background,

        evenRowColor: JxTheme.getColor(JxColor.gridEven).background,
        oddRowColor: JxTheme.getColor(JxColor.gridEven).background,
        columnCheckedColor: JxTheme.getColor(JxColor.gridChecked).background,
        cellActiveColor: JxTheme.getColor(JxColor.gridFocus).background,
        cellTextStyle: TextStyle(color: JxTheme.getColor(JxColor.grid).foreground),
      ),
    );
  }

  void removeCurrentRow() {
    stateManager?.removeCurrentRow();
    stateManager?.notifyListeners();
  }

  void first() {
    _activeRow = 0;
    _moveCurrentCellPositionToActiveRow();
  }

  void prior() {
    if (_activeRow > 0) {
      _activeRow--;
      _moveCurrentCellPositionToActiveRow();
    }
  }

  void next() {
    if (_activeRow < stateManager!.rows.length - 1) {
      _activeRow++;
      _moveCurrentCellPositionToActiveRow();
    }
  }

  void last() {
    _activeRow = stateManager!.rows.length - 1;
    _moveCurrentCellPositionToActiveRow();
  }

  void _moveCurrentCellPositionToActiveRow() {
    try {
      stateManager?.moveCurrentCellByRowIdx(_activeRow, TrinaMoveDirection.down);
    } catch (e) {
      log("error: $e");
    }
  }

  TrinaGridLocaleText localeText() {
    return TrinaGridLocaleText(
      unfreezeColumn: 'descongela',

      freezeColumnToStart: 'congela para o início',
      freezeColumnToEnd: 'congela para o final',
      autoFitColumn: 'largura auto',
      hideColumn: 'esconde coluna',
      setColumns: 'seta colunas',
      setFilter: 'seta filtro',
      resetFilter: 'reseta filtro',
      setColumnsTitle: 'títula da coluna',
      filterColumn: 'coluna',
      filterType: 'tipo',
      filterValue: 'valor',
      filterAllColumns: 'todas as colunas',
      filterContains: 'contém',
      filterEquals: 'igual',
      filterStartsWith: 'início com',
      filterEndsWith: 'final com',
      filterGreaterThan: 'maior que',
      filterGreaterThanOrEqualTo: 'maior ou igual a',
      filterLessThan: 'menor que',
      filterLessThanOrEqualTo: 'menor ou igual a',
      sunday: 'Dom',
      monday: 'Seg',
      tuesday: 'Ter',
      wednesday: 'Qua',
      thursday: 'Qui',
      friday: 'Sex',
      saturday: 'Sab',
      hour: 'Hora',
      minute: 'Minuto',
      loadingText: 'carregando...',
    );
  }
}
