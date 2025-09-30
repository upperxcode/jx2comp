// ignore_for_file: unnecessary_getters_setters, unused_element

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jx2_grid/components/datagrid.dart';
import 'package:jx_utils/jx_utils.dart' as func;
import 'package:jx_utils/logs/jx_log.dart';
import '../utils/constant.dart';
import '../models/jx_model.dart';
import '../models/jx_field.dart';
import 'enums.dart';
import 'filterable.dart';
import 'filter_mixin.dart';

/// Classe base abstrata que implementa a interface [Filterable] e estende [ChangeNotifier].
/// Esta é a classe na qual o [FilteringMixin] será aplicado.
abstract class BaseStoreWithInterface extends ChangeNotifier implements Filterable {
  @override
  late List<JxField> model;
  DbState _dbstate = DbState.browser;
  set dbstate(DbState v) {
    _dbstate = v;
    notifyListeners();
  }

  String? _tableName;
  String get tableName => _tableName!;
  set tableName(String v) => _tableName = v;

  // Raw data from the source (API, Supabase, etc.)
  List<Map<String, dynamic>> _dataList = [];

  /// Define a lista de dados brutos e notifica os ouvintes.
  set dataList(List<Map<String, dynamic>> v) {
    _dataList = v;
    notifyListeners();
  }

  @override
  List<Map<String, dynamic>> get dataList => _dataList;

  // Data converted to JxModel objects
  @override
  List<JxModel> _items = [];

  // Filtered data
  @override
  List<JxModel> _filteredItems = [];

  /// Returns the active list of items (filtered or all)
  List<JxModel> get _localItems => isFiltered ? _filteredItems : _items;

  /// Returns the list of items (filtered or complete).
  @override
  List<JxModel> get items => isFiltered ? [..._filteredItems] : [..._items];

  /// Sets the list of items for the store.
  @override
  set items(List<JxModel> source) {
    _items.clear();
    for (var item in source) {
      _items.add(item);
    }
    if (isFiltered) {
      setFilter(currentFilter);
    }
  }

  @override
  set filteredItems(List<JxModel> value) {
    _filteredItems = value;
  }

  @override
  List<JxModel> get filteredItems => _filteredItems;

  /// Verifica se o store contém dados.
  bool get isNotEmpty => isFiltered ? _filteredItems.isNotEmpty : _items.isNotEmpty;

  /// Verifica se o store está vazio.
  bool get isEmpty => isFiltered ? _filteredItems.isEmpty : _items.isEmpty;

  Map<String, dynamic> updateData = {};

  String deleteData = '';

  /// Retorna o estado atual do banco de dados.
  @override
  DbState get dbstate => _dbstate; // Getter

  DataGrid? _dataGrid;

  /// Retorna a instância do [DataGrid] associada a este store.
  DataGrid? get dataGrid => _dataGrid;

  /// Define a instância do [DataGrid] para este store.
  set dataGrid(DataGrid? v) {
    _dataGrid = v;
  }

  /// Retorna um mapa de registros modificados e a ação correspondente.
  final Map<int, DbAction> _modified = {};
  Map<int, DbAction> get modified => _modified;

  @override // from Filterable
  int recno = 0;
  late String _fieldOrder;
  late String _message;
  String errorMessage = '';
  HomeState state = HomeState.unstate;

  /// Retorna a mensagem de estado atual.
  String get message => _message;

  /// Retorna o nome do campo usado para ordenação.
  String get fieldOrder => _fieldOrder;

  /// Define o campo para ordenação.
  set fieldOrder(String fieldName) {
    _fieldOrder = fieldName;
  }

  /// Retorna o número de itens (considerando o filtro, se ativo).
  int get count => isFiltered ? _filteredItems.length : _items.length;

  // endregion

  // region Constructor

  BaseStoreWithInterface(this.model) {
    _fieldOrder = 'id';
    _message = '';
    errorMessage = '';
  }

  // endregion

  // region Data Access & Manipulation

  // get fields => _localItems[recno].fields;
  /// Retorna a lista de campos [JxField] para o registro atual.
  List<JxField>? get fields {
    if (_localItems.isNotEmpty) {
      return _localItems[recno].fields;
    }
    return model;
  }

  /// Converte os itens do store em uma lista de mapas para uso em lookups.
  Future<List<Map<String, dynamic>>> toListMap(String field1, field2) async {
    final List<Map<String, dynamic>> itemsMapList = _localItems.map((item) {
      return {'id': item.fieldByName(field1), 'nome': item.fieldByName(field2)};
    }).toList();
    return itemsMapList;
  }

  /// Converte os itens do store em um mapa de chave-valor para uso em lookups.
  Map<int, String> toLookupMap(String field1, field2, String? controle) {
    final Map<int, String> itemsMapList = {};

    JxLog.trace("lookupMap $controle");
    for (var el in _localItems) {
      itemsMapList[el.fieldByName(field1)] = el.fieldByName(field2);
    }
    return itemsMapList;
  }

  /// Retorna o valor de um campo específico do registro atual.
  dynamic fieldByName(String key) {
    if (recno == -1) {
      _message = 'Item não encontrado!';
      last();
    }
    if (isFiltered ? _filteredItems.isEmpty : _localItems.isEmpty) {
      throw Exception('O resultado da pesquisa está vázio!');
    }
    return isFiltered
        ? _filteredItems[recno].fieldByName(key)
        : _localItems[recno].fieldByName(key);
  }

  /// Define o valor de um campo específico no registro atual.
  void setFieldByName(String key, dynamic v) {
    if (recno < 0) return;
    _localItems[recno].setFieldByName(key, v);
  }

  /// Altera o valor de um campo e notifica os ouvintes.
  void changed(String fieldName, String v, {bool notify = true}) {
    if (recno >= 0 && recno < _localItems.length) {
      _localItems[recno].setFieldByName(fieldName, v);
    } else {
      JxLog.warning(
        'changed: recno ($recno) is out of bounds for _localItems length (${_localItems.length}).',
      );
    }

    if (notify) notifyListeners();
  }

  /// Retorna a instância [JxField] de um campo específico do registro atual.
  JxField field(String fieldName) {
    if (_localItems.isEmpty) {
      recno = 0;
      var order = 0;
      for (var it in model) {
        if (it.name == fieldName) {
          return model[order];
        }
        order++;
      }
      throw Exception('Field Not $fieldName Found');
    }
    final List<JxField> mdl = _localItems[recno].fields ?? [];

    for (var item in mdl) {
      if (item.name == fieldName) {
        return item;
      }
    }
    throw Exception('Field Not $fieldName Found');
  }

  /// Retorna a instância [JxField] de um campo com base em sua ordem (índice).
  JxField fieldByOrder(int id) {
    if (id > _localItems.length) {
      throw Exception('Field Not $id Found');
    }
    final List<JxField> mdl = _localItems[recno].fields ?? [];
    return mdl[id];
  }

  // endregion

  // region Data Refresh Cycle

  static bool _isRefreshing = false; // Variável para controlar se uma atualização está em andamento
  Timer? _refreshTimeoutTimer;

  /// Atualiza os dados do store, buscando-os novamente da fonte de dados.
  Future<bool> refresh([String? controle]) async {
    const int maxAttempts = 10;
    const int timeoutDuration = 30; // Tempo em segundos para o timeout
    int attempt = 0;
    bool success = false;

    // Lógica de verificação e timeout...
    // ... (Mantém a lógica de verificação e timeout inalterada)

    _isRefreshing = true;
    JxLog.trace("Iniciando refresh $controle ===>");

    _refreshTimeoutTimer = Timer(Duration(seconds: timeoutDuration), () {
      _isRefreshing = false;
      JxLog.trace("Timeout atingido. Permissão para nova atualização.");
    });

    while (attempt < maxAttempts && !success) {
      attempt++;
      JxLog.trace("Tentativa $attempt de $maxAttempts para refresh $controle ===>");
      state = HomeState.loading;
      dbstate = DbState.loading;

      try {
        beforeRefresh();

        // 1. Verifique se a lista está vazia antes de qualquer processamento
        if (_dataList.isEmpty) {
          JxLog.error('O resultado da pesquisa está vazio. Nenhuma ação a ser tomada.');
          _items = []; // Garante que a lista de itens seja vazia
          success = true; // Considere a operação um sucesso, apenas sem dados.
          state = HomeState.success; // Ou um estado como HomeState.empty
          JxLog.info('O _dataList está vazio. A lista de itens será limpa.');
          _items = [];
        } else {
          // 2. Prossiga com o mapeamento e processamento apenas se houver dados
          JxLog.info("Mapeando dados... ${dataList.length}");
          _items = _dataList.map((e) => JxModel.fromJson(e, model)).toList();
          success = true;
          state = HomeState.success;
          JxLog.info("Mapeando ${_dataList.length} registros de _dataList para _items.");
          // Adicionando log para inspecionar o primeiro registro
          if (_dataList.isNotEmpty) {
            JxLog.trace("Primeiro registro em _dataList: ${_dataList.first}");
          }
          _items = _dataList.map((e) {
            // Log para cada item sendo mapeado
            // JxLog.trace("Mapeando item: $e");
            return JxModel.fromJson(e, model);
          }).toList();
        }

        success = true;
        state = HomeState.success;
        dbstate = DbState.browser;
      } catch (e) {
        success = false;
        state = HomeState.error;
        dbstate = DbState.error;

        JxLog.error('Erro ao acessar a API: $errorMessage => $e');

        if (attempt < maxAttempts) {
          JxLog.trace('Tentativa falhou, tentando novamente em 1 segundo...');
          await Future.delayed(Duration(seconds: 1));
        } else {
          JxLog.trace('Máximo de tentativas atingido. Falha na atualização.');
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

    JxLog.trace("refresh $controle <====");
    JxLog.info("refresh de dados $tableName => ${items.length} => $success");
    return success;
  }

  /// Executa ações antes do processo de atualização de dados.
  void beforeRefresh() {
    _modified.clear;
    clear();
    last();
    _isRefreshing = true;
    JxLog.trace("refresh => $_isRefreshing");
  }

  /// Executa ações após o processo de atualização de dados ser concluído com sucesso.
  Future<void> afterRefresh() async {
    _updateControllerByData();
    _isRefreshing = false;
    JxLog.trace("refresh => $_isRefreshing");
  }

  // endregion

  // region UI & Data Binding

  /// Define o modo de estado do banco de dados.
  void dbStateMode(DbState v) {
    dbstate = v;
  }

  /// Atualiza os controladores de UI com base nos dados do registro atual.
  @override
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

  /// Retorna os dados do registro atual como um mapa JSON.
  Map<String, dynamic> get currentData {
    if (recno >= 0 && recno < _localItems.length) {
      return _localItems[recno].field2Json();
    }
    return {};
  }

  void _updateControllerByData() {
    if (dbstate != DbState.browser) return;

    if (!isFilterON && isFiltered) setFilter(currentFilter);

    JxLog.info("updateController recno  inicio ...");

    if (_localItems.isEmpty) return;
    final List<JxField> mdl = _localItems[recno].fields ?? [];
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

    JxLog.info("total de updates ${mdl.length} em ${tableName}");

    JxLog.trace("... updateController final recno $recno");

    notifyListeners();
  }

  /// Atualiza os dados do modelo com os valores dos controladores de UI.
  Future<void> updateDataByController() async {
    JxLog.trace("updateDataByController inicio... recno $recno");
    final mdl = _localItems[recno].fields ?? [];
    for (final item in mdl) {
      final v = item.controller.text;
      dynamic value;

      if (item.readOnly || item.calculated) {
        continue;
      }

      if (item.isMoney || item.isDouble) {
        value = func.doubleRawValue(v);
      } else if (item.isDigit) {
        value = int.tryParse(_onlyDigits(item.controller.text)) ?? 0;
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
      JxLog.trace("nome ${item.name} valor $value");
    }

    if (dbstate == DbState.update) {
      _addModified(DbAction.update);
    }

    notifyListeners();
    updateData = _localItems[recno].field2Json();
    JxLog.trace("... updateDataByController final");

    JxLog.info("total de updates ${mdl.length} em ${tableName}");
  }

  /// Cria um widget `Text` que observa e exibe o valor de um campo específico.
  Widget watch(String fieldName) {
    return ListenableBuilder(
      listenable: this,
      builder: (BuildContext context, Widget? child) {
        return Text(
          fieldByName(fieldName).toString(),
          style: const TextStyle(fontSize: 16, color: Colors.black),
        );
      },
    );
  }

  /// Notifica os ouvintes e retorna a lista de itens.
  List<JxModel> listWatch() {
    notifyListeners();
    return [..._items];
  }

  // endregion

  // region Internal Helpers & Utilities

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

  String _onlyDigits(String texto) {
    final RegExp nonNumericRegex = RegExp(r'[^0-9]');
    return texto.replaceAll(nonNumericRegex, '');
  }

  /// Salva os valores dos controladores de UI no modelo de dados.
  void save() {
    final List<JxField> mdl = _localItems[recno].fields ?? [];
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
      JxLog.trace("modificado $key $value");
    });
  }

  void _cancelAppend() {
    if (dbstate != DbState.insert && dbstate != DbState.canceling) return;

    // Remove o último item (o que estava sendo inserido) de ambas as listas.
    if (_items.isNotEmpty) {
      _items.removeLast();
    }
    if (isFiltered && _filteredItems.isNotEmpty) {
      _filteredItems.removeLast();
    }

    // Volta para o último registro válido e atualiza a UI.
    recno = _localItems.isNotEmpty ? _localItems.length - 1 : -1;
    dbstate = DbState.browser;
  }

  @override
  int getRecnoById(int id) {
    return _localItems.indexWhere((item) => item.fieldByName('id') == id);
  }

  @override
  int currentIdByRecno(int recno) {
    if (recno < 0 || _localItems.isEmpty || recno >= _localItems.length) return 0;
    return _localItems[recno].fieldByName('id');
  }

  /// Imprime uma mensagem no console se estiver em modo de depuração.
  void log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  // endregion

  // region CRUD Operations

  /// Cancela a operação atual (ex: inserção) e reverte os dados para o estado anterior.
  void cancel() {
    if (dbstate == DbState.insert) {
      _cancelAppend();
    }
    _updateControllerByData(); // Reverte para os dados do registro atual (anterior ao cancelado)
  }

  /// Adiciona um novo registro em branco ao final da lista de itens.
  Future<void> append() async {
    // 1. Cria um novo modelo em branco a partir da estrutura base.
    final JxModel newModel = JxModel.fromFields(model);
    for (var field in newModel.fields!) {
      field.value = null;
    }

    // 2. Adiciona o novo modelo à lista principal (_items).
    // Isso garante que o novo registro nunca seja perdido, mesmo com filtros ativos.
    _items.add(newModel);

    // 3. Se um filtro estiver ativo, adiciona o novo item também à lista filtrada
    // para que ele apareça imediatamente na UI.
    if (isFiltered) {
      _filteredItems.add(newModel);
    }

    // 4. Move o ponteiro para o novo registro, que agora é o último da lista local.
    recno = _localItems.length - 1;

    // 5. Define o estado para 'insert' e marca o registro como modificado.
    dbstate = DbState.insert;
    _addModified(DbAction.insert);

    // 6. Notifica a UI para refletir a adição.
    notifyListeners();
  }

  /// Coloca o store em modo de atualização para o registro atual.
  Future<void> update() async {
    dbstate = DbState.update;
    _addModified(DbAction.update);
  }

  /// Marca o registro atual para exclusão.
  void remove() {
    _setDeleted();
  }

  void _setDeleted() {
    JxLog.trace("delete $recno ${fieldByName('id')}");
    _addModified(DbAction.delete);
    if (!next()) {
      prior();
    }

    deleteData = fieldByName('id').toString();
    _updateControllerByData();
  }

  /// Limpa todos os itens e modificações do store.
  void clear() {
    _modified.clear();
    _items.clear();
    _filteredItems.clear();
    if (isFiltered) {
      setFilter(currentFilter);
    }
  }

  // endregion

  // region Record Navigation

  /// Move o ponteiro para o primeiro registro.
  void first([bool updateController = false]) {
    recno = 0;
    JxLog.trace("first");
    if (updateController) {
      _updateControllerByData();
    }
  }

  /// Move o ponteiro para o último registro.
  void last([bool updateController = false]) {
    recno = (_localItems.length) - 1;

    if (recno < 0) recno = 0;
    JxLog.trace("last");
    if (updateController && _localItems.isNotEmpty) {
      _updateControllerByData();
    }
  }

  /// Ordena os itens com base em um campo específico.
  void orderBy(String fieldName) {
    if (_fieldOrder == fieldName) return;
    final vField = field(fieldName);

    switch (vField.type) {
      case FieldType.ftInteger:
      case FieldType.ftDouble:
        func.sortByNumber(_localItems, fieldName);
        break;
      case FieldType.ftDate:
      case FieldType.ftDateTime:
        func.sortByDate(_localItems, fieldName);
        break;
      case FieldType.ftString:
      default:
        func.sortByString(_localItems, fieldName);
    }
    _fieldOrder = fieldName;
  }

  /// Procura um registro pelo seu ID.
  void findByID(int key) {
    final order = _fieldOrder;
    recno = 0;
    orderBy('id');
    recno = func.binarySearch(key, _localItems, "id");
    if (_isDeleted(recno)) next();
    orderBy(order);
  }

  /// Move para o próximo registro válido.
  bool next([bool updateController = false]) {
    if (isFiltered && _filteredItems.isEmpty) return false;

    int oldRec = recno;
    bool ok = false;

    while (recno < (_localItems.length - 1)) {
      recno++;
      //final item = _isFiltered ? _filteredItems[recno] : _localItems[recno];
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

  /// Move para o registro válido anterior.
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

  /// Encontra o primeiro registro que corresponde a um valor em um campo específico.
  void findFirst(String fieldName, dynamic key) {
    final order = _fieldOrder;
    recno = 0;

    orderBy(fieldName);
    recno = func.binarySearch(key, _localItems, fieldName);
    if (recno == -1) {
      _message = 'Item não encontrado!';
    }
    orderBy(order);
  }

  // endregion

  // region Persistence
  /// Persiste todas as alterações (inserções, atualizações, exclusões) na fonte de dados.
  Future<void> commit() async {
    _modified.forEach((key, value) {});
  }

  // endregion
}

abstract class BaseStore = BaseStoreWithInterface with FilteringMixin;
