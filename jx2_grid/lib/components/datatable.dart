import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jx2_grid/components/current_row.dart';
import 'package:jx2_widgets/core/theme.dart';
import 'package:jx_utils/logs/jx_log.dart';
import 'package:trina_grid/trina_grid.dart';

enum TableAutoSizeMode { none, all, column }

enum TableMoveDirection { up, down }

class Jx2Datatable extends StatelessWidget {
  final List<TrinaColumn> columns;
  final List<TrinaRow> rows;
  final bool darkMode;
  final TableAutoSizeMode? autoSizeMode;
  final TextStyle? textStyle;
  final Color Function(int)? rowColorCallback;
  final GlobalKey<_Jx2DatatableState> _gridKey = GlobalKey<_Jx2DatatableState>();

  Jx2Datatable({
    super.key,
    required this.columns,
    required this.rows,
    this.darkMode = false,
    this.autoSizeMode,
    this.textStyle,
    this.rowColorCallback,
  });

  TrinaGridStateManager? get stateManager => _gridKey.currentState?.stateManager;
  int? get currentIndex => _gridKey.currentState?.currentIndex;
  int get activeRow => _gridKey.currentState?.activeRow ?? 0;
  set activeRow(int value) => _gridKey.currentState?.activeRow = value;
  List<TrinaColumn> get gridColumns => columns; // As colunas são imutáveis aqui
  List<TrinaRow> get gridRows => rows; // As linhas são imutáveis aqui
  Color Function(int)? get resolvedRowColorCallback => rowColorCallback;

  void removeCurrentRow() => _gridKey.currentState?.removeCurrentRow();
  Future<bool> refreshGrid() async => await _gridKey.currentState?.refreshGrid() ?? false;
  void first() => _gridKey.currentState?.first();
  void prior() => _gridKey.currentState?.prior();
  void next() => _gridKey.currentState?.next();
  void last() => _gridKey.currentState?.last();

  @override
  Widget build(BuildContext context) {
    return _Jx2DatatableStateful(
      key: _gridKey,
      columns: columns,
      rows: rows,
      darkMode: darkMode,
      autoSizeMode: autoSizeMode,
      textStyle: textStyle,
      rowColorCallback: rowColorCallback,
    );
  }
}

class _Jx2DatatableStateful extends StatefulWidget {
  final List<TrinaColumn> columns;
  final List<TrinaRow> rows;
  final bool darkMode;
  final TableAutoSizeMode? autoSizeMode;
  final TextStyle? textStyle;
  final Color Function(int)? rowColorCallback;

  const _Jx2DatatableStateful({
    super.key,
    required this.columns,
    required this.rows,
    this.darkMode = false,
    this.autoSizeMode,
    this.textStyle,
    this.rowColorCallback,
  });

  @override
  State<_Jx2DatatableStateful> createState() => _Jx2DatatableState();
}

class _Jx2DatatableState extends State<_Jx2DatatableStateful> {
  TrinaGridStateManager? _stateManager;
  bool _isGridLoaded = false;
  int _activeRow = 0;

  @override
  Widget build(BuildContext context) {
    return TrinaGrid(
      columns: widget.columns,
      rows: widget.rows,
      mode: TrinaGridMode.select,
      onLoaded: _onTrinaGridLoaded,
      configuration: _config(),
      rowColorCallback: _rowColor,
      onSorted: _onTrinaGridSortedEvent,
      onChanged: _onTrinaGridChangedEvent,
    );
  }

  @override
  void dispose() {
    _stateManager?.removeListener(_onRowStateChanged);
    super.dispose();
  }

  TrinaGridStateManager? get stateManager => _stateManager;
  int? get currentIndex => _isGridLoaded ? _stateManager?.currentRowIdx : null;

  int get activeRow => _activeRow;
  set activeRow(int value) {
    if (_activeRow != value) {
      setState(() {
        _activeRow = value;
        _moveCurrentCellPositionToActiveRowInternal();
      });
    }
  }

  void removeCurrentRow() {
    if (_isGridLoaded && _stateManager != null) {
      _stateManager!.removeCurrentRow();
    }
    _notifyListeners();
  }

  Future<bool> refreshGrid() async {
    if (_isGridLoaded && _stateManager != null) {
      _stateManager!.resetCurrentState();
    } else {
      setState(() {});
    }
    return true;
  }

  void first() {
    activeRow = 0;
  }

  void prior() {
    if (activeRow > 0) {
      activeRow--;
    }
  }

  void next() {
    if (activeRow < (widget.rows.isNotEmpty ? widget.rows.length - 1 : 0)) {
      activeRow++;
    }
  }

  void last() {
    activeRow = widget.rows.isNotEmpty ? widget.rows.length - 1 : 0;
  }

  void _onTrinaGridLoaded(TrinaGridOnLoadedEvent event) {
    _stateManager = event.stateManager;
    _stateManager?.setSelectingMode(TrinaGridSelectingMode.row);
    _stateManager?.addListener(_onRowStateChanged);
    _isGridLoaded = true;
  }

  void _onTrinaGridSortedEvent(TrinaGridOnSortedEvent event) {
    JxLog.info("Trina event $event");
  }

  void _onTrinaGridChangedEvent(TrinaGridOnChangedEvent event) {
    JxLog.info("Trina event $event");
  }

  void _onRowStateChanged() {
    JxLog.info("Trina event ${_stateManager?.currentRowIdx}");
    _syncRowsInternal();
  }

  void _syncRowsInternal() {
    JxLog.info("_syncRowsInternal ...");
    if (_isGridLoaded && _stateManager != null) {
      final activeRowIndex = _stateManager!.currentRowIdx ?? 0;
      _activeRow = activeRowIndex;
      if (activeRowIndex != 0) {
        final relativeRow = _stateManager!.currentRow?.cells.values.elementAt(0).value ?? 0;
        JxLog.info("currentRow => $relativeRow");
      }
    }
    JxLog.info("... _syncRowsInternal");
  }

  void _moveCurrentCellPositionToActiveRowInternal() {
    if (_isGridLoaded && _stateManager != null) {
      try {
        _stateManager!.moveCurrentCellByRowIdx(_activeRow, TrinaMoveDirection.down, notify: true);
      } catch (e) {
        JxLog.info("error moving cell: $e");
      }
    }
  }

  Color _rowColor(TrinaRowColorContext colorContext) {
    return widget.rowColorCallback?.call(colorContext.rowIdx) ??
        (colorContext.rowIdx.isEven ? Colors.white38 : Colors.black26);
  }

  TrinaGridConfiguration _config() {
    return TrinaGridConfiguration(
      localeText: _localeText(),
      columnSize: TrinaGridColumnSizeConfig(
        autoSizeMode: widget.autoSizeMode == TableAutoSizeMode.none
            ? TrinaAutoSizeMode.none
            : TrinaAutoSizeMode.scale,
        resizeMode: TrinaResizeMode.normal,
      ),
      style: TrinaGridStyleConfig(
        rowHeight: 30,
        columnHeight: 35,
        columnTextStyle: widget.textStyle ?? const TextStyle(fontSize: 16),

        borderColor: JxTheme.getColor(JxColor.gridBorder).background,
        gridBackgroundColor: JxTheme.getColor(JxColor.grid).background,
        activatedColor: JxTheme.getColor(JxColor.gridSelection).background,
        evenRowColor: JxTheme.getColor(JxColor.gridEven).background,
        oddRowColor: JxTheme.getColor(JxColor.gridEven).background,
        columnCheckedColor: JxTheme.getColor(JxColor.gridChecked).background,
      ),
    );
  }

  TrinaGridLocaleText _localeText() {
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

  void _notifyListeners() {
    if (_isGridLoaded && _stateManager != null) {
      _stateManager!.notifyListeners();
    }
  }
}
