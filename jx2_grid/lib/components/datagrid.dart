import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_data/components/stores/jx_store.dart';
import 'package:jx_utils/logs/jx_log.dart';

import 'package:trina_grid/trina_grid.dart';
import 'grid_column.dart';
import 'grid_rows.dart';

class DataGrid {
  TrinaGridStateManager? stateManager;
  final Store controller;
  List<TrinaColumn>? columns;
  List<TrinaRow>? rows;
  late Color Function(int)? rowColorCallback;
  final TrinaAutoSizeMode? autoSizeMode;
  final TextStyle? textStyle;
  final bool darkMode;
  bool loaded = false;

  int _activeRow = 0;
  TrinaGrid? _trinaGrid;

  DataGrid(
    this.controller, {
    this.autoSizeMode,
    this.textStyle,
    this.rowColorCallback,
    this.darkMode = false,
  }) {
    JxLog.trace("Constructor: DataGrid created.");
    rowColorCallback ?? (v) => Colors.white;
  }

  /// Define a função de callback para a cor da linha.
  set colorCallBack(Color Function(int) func) {
    rowColorCallback = func;
  }

  /// Aplica um filtro ao grid com base em um valor e uma coluna.
  void setFilter(String filterValue, String filterColumn) {
    _setFilter(filterValue, filterColumn);
  }

  /// Limpa todos os filtros aplicados ao grid.
  void clearFilter() {
    // Passa uma lista de filtros vazia para o gerenciador de estado
    stateManager!.setFilterWithFilterRows([]);
    stateManager!.setShowColumnFilter(false);
  }

  void _setFilter(String filterColumn, String filterValue) {
    // Create a filter row with a `contains` operator for the 'name_field'
    JxLog.info("filtrando $filterColumn $filterValue ");
    TrinaRow filterRow = FilterHelper.createFilterRow(
      columnField: filterColumn,
      filterType: const TrinaFilterTypeEquals(),
      filterValue: filterValue,
    );

    // Set the new filter on the state manager
    stateManager!.setFilterRows([filterRow]);
    stateManager!.setShowColumnFilter(true);
  }

  // Método privado para garantir a inicialização única do grid.
  Future<void> _ensureTrinaGridIsInitialized() async {
    if (loaded && _trinaGrid != null) {
      JxLog.trace("initTrinaGrid: Grid already initialized.");
      return;
    }

    JxLog.trace("initTrinaGrid: Creating new grid instance.");
    _trinaGrid = await _createTrinaGrid();
    loaded = true;
  }

  /// Ponto de entrada seguro para obter o widget do grid, garantindo sua inicialização.
  Future<TrinaGrid> datagrid() async {
    await _ensureTrinaGridIsInitialized();

    if (!await refreshGrid()) {
      JxLog.trace("datagrid: Failed to refresh grid data.");
    }

    return _trinaGrid!;
  }

  /// Atualiza os dados do grid, buscando novas informações do controller.
  Future<bool> refreshGrid([bool force = true]) async {
    JxLog.trace("refreshGrid inicio ...");

    try {
      if (stateManager == null) {
        JxLog.trace("refreshGrid: stateManager is null, creating initial grid.");
        columns = gridColumns(controller.fields!, style: textStyle);
        if (force) await controller.refresh("gride stataManager == null");
        rows = gridRows(controller);
        JxLog.error("... refreshGrid fim stateManager null ...");
        return true;
      }

      stateManager?.setShowLoading(true);
      if (force) await controller.refresh("gride!");
      final newRows = gridRows(controller);

      stateManager?.resetCurrentState(notify: false);
      stateManager?.removeAllRows();
      if (controller.isNotEmpty) stateManager?.appendRows(newRows);
      stateManager?.setShowLoading(false);
      stateManager?.notifyListeners();
    } catch (e) {
      JxLog.error("Erro! Não foi possível fazer o refresh no grid. $e");
      stateManager?.setShowLoading(false);

      return false;
    }

    JxLog.trace("... refreshGrid fim");
    return true;
  }

  /// Retorna o índice da linha ativa.
  int get activeRow => _activeRow;

  /// Retorna o índice da linha atualmente selecionada no grid.
  int get currentIndex => stateManager?.currentRowIdx ?? 0;

  /// Atualiza o grid com base no estado do controller (inserção ou atualização).
  void updateGrid() {
    JxLog.trace("updateGrid inicio ...");
    if (controller.dbstate == DbState.update) {
      JxLog.trace("updateGrid update");
      _updateRow();
    } else if (controller.dbstate == DbState.insert) {
      JxLog.trace("updateGrid insert");
      _insertRow();
    }
    JxLog.trace("final updateGrid inicio");
  }

  /// Verifica se alguma célula está selecionada no grid.
  bool isCellSelected() => stateManager?.currentCellPosition != null;

  void _newRow(int position, {bool replace = false}) {
    JxLog.trace('_newRow');
    if (stateManager == null) {
      JxLog.trace('StateManager is not available.');
      return;
    }

    int rowCount = stateManager!.rows.length;
    if (position < 0 || position > rowCount) {
      JxLog.trace('Position is out of bounds.');
      return;
    }

    final row = _createRowData(position, replace: replace);

    if (replace) {
      if (stateManager!.currentRowIdx == null) {
        JxLog.trace('No current row selected to replace.');
        return;
      }
      stateManager!.removeRows([stateManager!.rows[position]]);
    }

    stateManager!.insertRows(position, [TrinaRow(cells: row)]);
    stateManager!.setCurrentCellPosition(TrinaGridCellPosition(columnIdx: 0, rowIdx: position));
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
    JxLog.trace('_createRowData');
    final row = <String, TrinaCell>{};
    if (!replace) controller.last();
    row["index"] = TrinaCell(value: position);
    for (var field in controller.fields!) {
      var value = controller.fieldByName(field.name);
      JxLog.trace("field = ${field.name} value => $value");
      row[field.name] = TrinaCell(value: value);
    }
    return row;
  }

  Future<TrinaGrid> _createTrinaGrid() async {
    columns = gridColumns(controller.fields!, style: textStyle);
    rows = gridRows(controller);

    return TrinaGrid(
      columns: columns!,
      rows: rows!,
      mode: TrinaGridMode.select,
      configuration: _config(),
      rowColorCallback: _rowColor,
      onLoaded: _onGridLoaded,
      onSorted: _onTrinaGridSortedEvent,
      onChanged: _onTrinaGridChangedEvent,
      onSelected: (event) {
        JxLog.trace(
          "Onselect event.rowIdx: ${event.rowIdx} controller.recno: ${controller.recno} ",
        );
        if (event.rowIdx != null && controller.recno != event.rowIdx) {
          controller.recno = event.rowIdx!;
        }
      },
    );
  }

  void _onGridLoaded(TrinaGridOnLoadedEvent event) {
    JxLog.trace("_onGridLoaded");
    stateManager = event.stateManager;
    stateManager?.setSelectingMode(TrinaGridSelectingMode.row);
    stateManager?.addListener(_onRowStateChanged);

    JxLog.trace("_onGridLoaded $stateManager");
  }

  void _onTrinaGridChangedEvent(TrinaGridOnChangedEvent event) {
    JxLog.trace("Trina event $event");
  }

  void _onTrinaGridSortedEvent(TrinaGridOnSortedEvent event) {
    JxLog.trace("Trina event $event");
  }

  Color _rowColor(TrinaRowColorContext colorContext) {
    if (rowColorCallback != null) {
      return rowColorCallback!(colorContext.rowIdx);
    }

    return Colors.blue.withValues(alpha: 0.5, red: 0.5, colorSpace: ColorSpace.sRGB);
  }

  void _onRowStateChanged() {
    JxLog.trace("_onRowStateChanged");
    if (controller.dbstate == DbState.browser) {
      JxLog.trace("_onRowStateChanged browser");
      _syncRows();
      //controller.updateControllerByData();
    } else if (controller.dbstate == DbState.update) {
      JxLog.trace("_onRowStateChanged update");
    }
  }

  void _syncRows() {
    JxLog.trace("_syncRows inicio ...");
    _activeRow = stateManager?.currentRowIdx ?? 0;

    final relativeRow = stateManager?.currentRow?.cells.values.elementAt(0).value ?? 0;
    JxLog.trace("relativeRow => $relativeRow");
    controller.recno = relativeRow;

    JxLog.trace("... _syncRows fim");
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
        oddRowColor: JxTheme.getColor(JxColor.gridOdd).background,
        columnCheckedColor: JxTheme.getColor(JxColor.gridChecked).background,
        cellActiveColor: JxTheme.getColor(JxColor.gridFocus).background,
        cellTextStyle: TextStyle(color: JxTheme.getColor(JxColor.grid).foreground),
      ),
    );
  }

  /// Remove a linha atualmente selecionada do grid.
  void removeCurrentRow() {
    stateManager?.removeCurrentRow();
    stateManager?.notifyListeners();
  }

  /// Move a seleção para a primeira linha do grid.
  void first() {
    _activeRow = 0;
    _moveCurrentCellPositionToActiveRow();
  }

  /// Move a seleção para a linha anterior no grid.
  void prior() {
    if (_activeRow > 0) {
      _activeRow--;
      _moveCurrentCellPositionToActiveRow();
    }
  }

  /// Move a seleção para a próxima linha no grid.
  void next() {
    if (_activeRow < stateManager!.rows.length - 1) {
      _activeRow++;
      _moveCurrentCellPositionToActiveRow();
    }
  }

  /// Move a seleção para a última linha do grid.
  void last() {
    _activeRow = stateManager!.rows.length - 1;
    _moveCurrentCellPositionToActiveRow();
  }

  void _moveCurrentCellPositionToActiveRow() {
    try {
      stateManager?.moveCurrentCellByRowIdx(_activeRow, TrinaMoveDirection.down);
    } catch (e) {
      JxLog.error("error: $e");
    }
  }

  /// Retorna o texto de localização para os componentes do grid.
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
