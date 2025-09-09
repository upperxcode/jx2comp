// ignore_for_file: unnecessary_getters_setters, unused_element

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jx_utils/jx_utils.dart' as func;
import '../utils/constant.dart';
import '../models/jx_model.dart';
import '../models/jx_field.dart';
import 'enums.dart';

enum DbAction { insert, update, delete }

enum DbState { insert, update, delete, browser, canceling, loading, error, empty }

class Store extends BaseStore {
  final List<JxField> jxFields;
  Store(this.jxFields) : super(jxFields);
}

abstract class BaseStore with ChangeNotifier {
  late List<JxField> model;
  DbState _dbstate = DbState.browser;

  set dbstate(DbState v) {
    _dbstate = v;
    notifyListeners();
  }

  List<Map<String, dynamic>> _dataList = [];

  set dataList(List<Map<String, dynamic>> v) {
    _dataList = v;
    notifyListeners();
  }

  List<Map<String, dynamic>> get dataList => _dataList;

  Map<String, dynamic> updateData = {};
  String deleteData = '';

  static bool _isRefreshing = false; // Variável para controlar se uma atualização está em andamento

  Timer? _refreshTimeoutTimer;

  DbState get dbstate => _dbstate;

  final List<JxModel> _items = [];

  final Map<int, DbAction> _modified = {};
  Map<int, DbAction> get modified => _modified;

  List<String> _currentFilter = [];
  List<JxModel> _filteredItems = [];
  bool _isFiltered = false;

  bool get isFiltered => _isFiltered;

  List<String> get currentFilter => [..._currentFilter];

  /// Define um filtro para os itens do modelo
  ///
  /// O filtro é aplicado em todos os campos do modelo e atualiza a lista filtrada
  /// mantendo o índice atual na primeira posição válida.
  ///
  /// @param filter - Lista de strings com os textos de filtro a serem aplicados
  void setFilter(List<String> filter) {
    _currentFilter = filter;
    if (fields == null) {
      return;
    }

    if (filter.isEmpty) {
      // Se o filtro estiver vazio, restaura todos os itens
      _filteredItems = List.from(_items);
      _isFiltered = false;
    } else {
      // Aplica o filtro em todos os itens
      _filteredItems = _items.where((item) {
        // Verifica se o item corresponde a pelo menos um dos filtros
        for (var filterText in filter) {
          if (filterText.isNotEmpty) {
            // Verifica todos os campos do item
            bool matches = false;
            for (var field in fields!) {
              final fieldValue = item.fieldByName(field.name)?.toString() ?? '';
              if (fieldValue.toLowerCase().contains(filterText.toLowerCase())) {
                matches = true;
                break;
              }
            }
            if (matches) return true;
          }
        }
        return false;
      }).toList();

      _isFiltered = true;
    }

    // Atualiza o recno atual após filtrar
    if (_filteredItems.isNotEmpty) {
      recno = 0;
      _updateControllerByData();
    } else {
      recno = -1; // Nenhum item encontrado
    }
  }

  String errorMessage = '';

  int get count => isFiltered ? _filteredItems.length : _items.length;

  List<JxModel> get items => _isFiltered ? [..._filteredItems] : [..._items];

  List<JxModel> listWatch() {
    notifyListeners();
    return [..._items];
  }

  set items(List<JxModel> source) {
    _items.clear();
    for (var item in source) {
      _items.add(item);
    }
    if (isFiltered) {
      setFilter(currentFilter);
    }
  }

  int recno = 0;
  late String _fieldOrder;

  late String _message;
  String get message => _message;

  String get fieldOrder => _fieldOrder;
  set fieldOrder(String fieldName) {
    _fieldOrder = fieldName;
  }

  HomeState state = HomeState.unstate;

  // get fields => _items[recno].fields;
  List<JxField>? get fields {
    if (items.isNotEmpty) {
      return _items[recno].fields;
    }
    return model;
  }

  BaseStore(this.model) {
    _fieldOrder = 'id';
    _message = '';
    errorMessage = '';
  }

  Future<List<Map<String, dynamic>>> toListMap(String field1, field2) async {
    final items = isFiltered ? _filteredItems : _items;
    final List<Map<String, dynamic>> itemsMapList = items.map((item) {
      return {'id': item.fieldByName(field1), 'nome': item.fieldByName(field2)};
    }).toList();
    return itemsMapList;
  }

  Map<int, String> toLookupMap(String field1, field2, String? controle) {
    final Map<int, String> itemsMapList = {};

    log("lookupMap $controle");
    for (var el in _items) {
      itemsMapList[el.fieldByName(field1)] = el.fieldByName(field2);
    }
    return itemsMapList;
  }

  Future<bool> refresh([String? controle]) async {
    const int maxAttempts = 10;
    const int timeoutDuration = 30; // Tempo em segundos para o timeout
    int attempt = 0;
    bool success = false;

    // Lógica de verificação e timeout...
    // ... (Mantém a lógica de verificação e timeout inalterada)

    _isRefreshing = true;
    log("Iniciando refresh $controle ===>");

    _refreshTimeoutTimer = Timer(Duration(seconds: timeoutDuration), () {
      _isRefreshing = false;
      log("Timeout atingido. Permissão para nova atualização.");
    });

    while (attempt < maxAttempts && !success) {
      attempt++;
      log("Tentativa $attempt de $maxAttempts para refresh $controle ===>");
      state = HomeState.loading;
      dbstate = DbState.loading;

      try {
        beforeRefresh();

        // 1. Verifique se a lista está vazia antes de qualquer processamento
        if (_dataList.isEmpty) {
          log('O resultado da pesquisa está vazio. Nenhuma ação a ser tomada.');
          items = []; // Garante que a lista de itens seja vazia
          success = true; // Considere a operação um sucesso, apenas sem dados.
          state = HomeState.success; // Ou um estado como HomeState.empty
        } else {
          // 2. Prossiga com o mapeamento e processamento apenas se houver dados
          log("Mapeando dados...");
          items = _dataList.map((e) => JxModel.fromJson(e, model)).toList();
          success = true;
          state = HomeState.success;
        }

        dbstate = DbState.browser;
      } catch (e) {
        state = HomeState.error;
        dbstate = DbState.error;
        log('Erro ao acessar a API: $errorMessage => $e');

        if (attempt < maxAttempts) {
          log('Tentativa falhou, tentando novamente em 1 segundo...');
          await Future.delayed(Duration(seconds: 1));
        } else {
          log('Máximo de tentativas atingido. Falha na atualização.');
          success = false;
        }
      }
    }

    _refreshTimeoutTimer?.cancel();
    _isRefreshing = false;
    notifyListeners();

    if (success) {
      await afterRefresh();
    }

    log("refresh $controle <====");
    return success;
  }

  void log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  void beforeRefresh() {
    _modified.clear;
    clear();
    last();
    _isRefreshing = true;
    log("refresh => $_isRefreshing");
  }

  Future<void> afterRefresh() async {
    _updateControllerByData();
    _isRefreshing = false;
    log("refresh => $_isRefreshing");
  }

  Future<void> commit() async {
    _modified.forEach((key, value) {});
  }

  void dbStateMode(DbState v) {
    dbstate = v;
  }

  void updateControllerByData() {
    switch (dbstate) {
      case DbState.canceling:
        _cancelAppend();
        break;
      case DbState.update:
        break;
      case DbState.insert:
        break;
      default:
    }

    dbstate = DbState.browser;
    _updateControllerByData();
  }

  void _updateControllerByData() {
    final items = isFiltered ? _filteredItems : _items;

    if (items.isEmpty) return;
    final List<JxField> mdl = items[recno].fields ?? [];
    for (var item in mdl) {
      var value = fieldByName(item.name);
      if (item.type == FieldType.ftMoney) {
        String decimalPart = List.filled(item.decimals, '0').join();
        if (decimalPart.isNotEmpty) decimalPart = ".$decimalPart";
        final NumberFormat formatCurrency = NumberFormat("$moneyFormat$decimalPart", countryLocale);
        if (value == "") {
          value = 0;
        }
        value = formatCurrency.format(value ?? 0);
      } else if (item.type == FieldType.ftDouble) {
        String decimalPart = List.filled(item.decimals, '0').join();
        if (decimalPart.isNotEmpty) decimalPart = ".$decimalPart";
        final NumberFormat formatCurrency = NumberFormat(
          "$doubleFormat$decimalPart",
          countryLocale,
        );
        if (value == "") {
          value = 0;
        }
        value = formatCurrency.format(value ?? 0);
      } else if (item.calculated &&
          (item.type == FieldType.ftDouble || item.type == FieldType.ftInteger)) {
        value = _calculateFormula(item.calculation);
      } else {}

      field(item.name).controller.text = value != null ? "$value" : "";
    }

    log("updateController recno $recno");

    notifyListeners();
  }

  /// Interpreta a fórmula e faz o cálculo
  /// A fórmula deve ser uma lista de strings. O primeiro elemento é o
  /// valor inicial, e os subsequentes são pares [operador, campo].
  /// Exemplo: ['atual', '-', 'anterior'] ou ['atual', '-', 'anterior', '*', 'tamanho']
  int _calculateFormula(List<String> formula) {
    // A fórmula deve ter pelo menos 3 elementos e um número ímpar de elementos.
    if (formula.length < 3 || formula.length % 2 != 1) {
      return 0;
    }

    // 1. Pega o valor inicial do primeiro campo.
    int result = int.tryParse(field(formula[0]).value.toString()) ?? 0;

    // 2. Itera sobre a lista, pegando os operadores e campos em pares.
    for (int i = 1; i < formula.length; i += 2) {
      final operator = formula[i];
      final fieldName = formula[i + 1];

      final value = int.tryParse(field(fieldName).value.toString()) ?? 0;

      switch (operator) {
        case '+':
          result += value;
          break;
        case '-':
          result -= value;
          break;
        case '*':
          result *= value;
          break;
        case '/':
          if (value == 0) {
            result = 0;
          } else {
            result ~/= value;
          }
          break;
        default:
          return 0; // Operador inválido.
      }
    }

    return result;
  }

  Future<void> updateDataByController() async {
    final mdl = _items[recno].fields ?? [];
    for (final item in mdl) {
      final v = item.controller.text;
      dynamic value;

      if (item.readOnly || item.calculated) {
        return;
      }

      if (item.isMoney || item.isDouble) {
        value = func.doubleRawValue(v);
      } else if (item.isDigit) {
        value = int.tryParse(item.controller.text) ?? 0;
      } else if (item.fieldType == FieldType.ftBool) {
        value = v == "true" ? true : false;
      } else if (item.fieldType == FieldType.ftDateTime) {
        // Tratando campos do tipo DateTime
        final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss'); // Formato ISO 8601
        final DateTime dateTime = DateFormat('seuFormatoEntrada').parse(v, true);
        value = formatter.format(dateTime);
      } else {
        value = v;
      }
      setFieldByName(item.name, value);
    }

    if (dbstate == DbState.update) {
      _addModified(DbAction.update);
    }

    notifyListeners();
    updateData = _items[recno].field2Json();
  }

  void cancel() {
    _updateControllerByData();
  }

  void save() {
    final List<JxField> mdl = _items[recno].fields ?? [];
    for (var item in mdl) {
      dynamic value;
      final str = field(item.name).controller.text;
      switch (item.fieldType) {
        case FieldType.ftInteger:
          value = int.parse(str);
          break;
        case FieldType.ftDouble:
          value = int.parse(str);
          break;
        default:
          value = item.value;
      }
      setFieldByName(item.name, value);
    }
    notifyListeners();
  }

  bool _inModified(int rec) {
    return _modified.containsKey(rec);
  }

  bool _inModifiedInsert(int rec) {
    return _modified.containsKey(rec) && _modified[rec] == DbAction.insert;
  }

  bool _isDeleted(int rec) {
    return _modified.containsKey(rec) && _modified[rec] == DbAction.delete;
  }

  void _addModified(DbAction action) {
    if (!_inModifiedInsert(recno)) {
      _modified[recno] = action;
    }
    _modified.forEach((key, value) {
      debugPrint("modificado $key $value");
    });
  }

  Widget watch(String fieldName) {
    return ListenableBuilder(
      listenable: this,
      builder: (BuildContext context, Widget? child) {
        return Text(
          "${fieldByName(fieldName)}",
          style: const TextStyle(fontSize: 16, color: Colors.black),
        );
      },
    );
  }

  void _cancelAppend() {
    if (dbstate != DbState.canceling) {
      return;
    }
    dbstate = DbState.browser;
    last();
    _items.removeAt(recno);
    _modified.remove(recno);
    recno--;
  }

  Future<void> append() async {
    final JxModel mdl = _items[recno].clone();

    final int nextId = _items.isNotEmpty
        ? _items.last.fields!.firstWhere((f) => f.name == 'id').value + 1
        : 1;
    final Map<String, dynamic> fieldValues = {
      'id': nextId,
      'nome': 'nome $nextId',
      'senha': '1#dF123',
      'salario': 1900000,
    };

    // Aplicar valores ao modelo.
    for (var field in mdl.fields!) {
      field.value = fieldValues[field.name] ?? field.value;
    }

    _items.add(mdl);
    recno = _items.length - 1;
    log("append recno $recno");
    last();
    _updateControllerByData();
    dbstate = DbState.insert;
    _addModified(DbAction.insert);

    if (isFiltered) {
      setFilter(currentFilter);
    }
  }

  Future<void> update() async {
    dbstate = DbState.update;
    _addModified(DbAction.update);
  }

  void remove() {
    _setDeleted();
  }

  void _setDeleted() {
    log("delete $recno ${fieldByName('id')}");
    _addModified(DbAction.delete);
    if (!next()) {
      prior();
    }

    deleteData = fieldByName('id').toString();
    _updateControllerByData();
  }

  void clear() {
    _modified.clear();
    _items.clear();
    if (isFiltered) {
      setFilter(currentFilter);
    }
  }

  void first([bool updateController = false]) {
    recno = 0;
    log("first");
    if (updateController) {
      _updateControllerByData();
    }
  }

  void last([bool updateController = false]) {
    final items = isFiltered ? _filteredItems : _items;

    recno = items.length - 1;

    if (recno < 0) recno = 0;
    log("last");
    if (updateController) {
      _updateControllerByData();
    }
  }

  dynamic fieldByName(String key) {
    if (recno == -1) {
      _message = 'Item não encontrado!';
      last();
    }
    if (isFiltered ? _filteredItems.isEmpty : _items.isEmpty) {
      throw Exception('O resultado da pesquisa está vázio!');
    }
    return isFiltered ? _filteredItems[recno].fieldByName(key) : _items[recno].fieldByName(key);
  }

  void setFieldByName(String key, dynamic v) {
    isFiltered
        ? _filteredItems[recno].setFieldByName(key, v)
        : _items[recno].setFieldByName(key, v);
  }

  void changed(String fieldName, String v) {
    isFiltered
        ? _filteredItems[recno].setFieldByName(fieldName, v)
        : _items[recno].setFieldByName(fieldName, v);

    notifyListeners();
  }

  JxField field(String fieldName) {
    final items = (isFiltered ? _filteredItems : _items);
    if (items.isEmpty) {
      var order = 0;
      for (var it in model) {
        if (it.name == fieldName) {
          return model[order];
        }
        order++;
      }
      throw Exception('Field Not $fieldName Found');
    }
    final List<JxField> mdl = items[recno].fields ?? [];

    for (var item in mdl) {
      if (item.name == fieldName) {
        return item;
      }
    }
    throw Exception('Field Not $fieldName Found');
  }

  JxField fieldByOrder(int id) {
    final items = (isFiltered ? _filteredItems : _items);
    if (id > items.length) {
      throw Exception('Field Not $id Found');
    }
    final List<JxField> mdl = items[recno].fields ?? [];
    return mdl[id];
  }

  void orderBy(String fieldName) {
    if (_fieldOrder == fieldName) return;
    final vField = (_items[recno].fieldByName(fieldName) as JxField);

    switch (vField.type) {
      case FieldType.ftInteger:
      case FieldType.ftDouble:
        func.sortByNumber(_items, fieldName);
        break;
      case FieldType.ftDate:
      case FieldType.ftDateTime:
        func.sortByDate(_items, fieldName);
        break;
      case FieldType.ftString:
      default:
        func.sortByString(_items, fieldName);
    }
    _fieldOrder = fieldName;
  }

  void findByID(dynamic key) {
    recno = 0;
    orderBy('id');
    recno = func.binarySearch(key, _items, "id");
    if (_isDeleted(recno)) next();
  }

  bool next([bool updateController = false]) {
    if (_isFiltered && _filteredItems.isEmpty) return false;

    int oldRec = recno;
    bool ok = false;

    while (recno < (_isFiltered ? _filteredItems.length - 1 : _items.length - 1)) {
      recno++;
      //final item = _isFiltered ? _filteredItems[recno] : _items[recno];
      if (!_isDeleted(recno)) {
        ok = true;
        break;
      }
    }

    if (ok) {
      if (updateController) {
        _updateControllerByData();
      }
      return true;
    } else {
      recno = oldRec;
    }
    return false;
  }

  bool prior([bool updateController = false]) {
    int oldRec = recno;
    bool ok = false;

    while (recno > 0) {
      recno--;
      if (!_isDeleted(recno)) {
        ok = true;
        break;
      }
    }

    if (ok) {
      if (updateController) {
        _updateControllerByData();
      }
      return true;
    } else {
      recno = oldRec;
    }
    return false;
  }

  void findFirst(String fieldName, dynamic key) {
    recno = 0;
    orderBy(fieldName);
    recno = func.binarySearch(key, _items, fieldName);
    if (recno == -1) {
      _message = 'Item não encontrado!';
    }
  }
}
