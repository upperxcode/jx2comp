import 'package:jx_data/components/models/jx_model.dart';
import 'package:jx_data/components/stores/enums.dart';
import 'package:jx_data/components/stores/filter.dart';
import 'package:jx_data/components/stores/filterable.dart';
import 'package:jx_utils/logs/jx_log.dart';

/// Mixin que encapsula a lógica de filtragem para um BaseStore.
mixin FilteringMixin on Filterable {
  List<FilterExpress> _currentFilter = [];
  bool _isFiltered = false;
  // Variável interna para o mixin, não precisa estar na interface.
  bool _isFilterON = false;

  /// Indica se há um filtro ativo.
  @override
  bool get isFiltered => _isFiltered;

  /// Retorna uma cópia da lista de filtros atual.
  @override
  List<FilterExpress> get currentFilter => [..._currentFilter];
  @override
  bool get isFilterON => _isFilterON;

  /// Define um filtro para os itens do modelo.
  ///
  /// O filtro é uma lista de expressões de filtro que podem ser combinadas para criar filtros complexos.
  /// Cada elemento da lista representa uma condição de filtro com campo, operador e valor.
  /// Exemplo: [FilterExpress("condominio", FilterOperator.equal, "1"), FilterExpress("nome", FilterOperator.contains, "joão")]
  ///
  /// @param filter - Lista de expressões de filtro para aplicar
  @override
  void setFilter(List<FilterExpress> filter) {
    if (dbstate != DbState.browser) return;
    final currentId = currentIdByRecno(recno);
    _currentFilter = filter;

    if (filter.isEmpty) {
      // Se o filtro estiver vazio, restaura todos os itens e reseta o filtro
      filteredItems = [];
      items = dataList
          .map((e) => JxModel.fromJson(e, model))
          .toList(); // Garante que _items seja recarregado
      _isFiltered = false;
      recno = items.isNotEmpty ? 0 : -1;
      updateControllerByData();
      return;
    }

    // Aplica os filtros
    final filteredData = dataList.where((rawData) => _itemMatchesFilter(rawData, filter)).toList();

    filteredItems = filteredData.map((e) => JxModel.fromJson(e, model)).toList();
    _isFiltered = true;

    JxLog.trace("filtro aplicado ${filteredItems.length} registros sem filtro ${dataList.length}");

    // Atualiza o recno atual após filtrar
    if (filteredItems.isNotEmpty) {
      final currentRecno = getRecnoById(currentId);
      if (currentRecno != -1) {
        recno = currentRecno;
      } else {
        recno = 0;
      }
      _isFilterON ? updateControllerByData() : _isFilterON = false;
    } else {
      recno = -1;
    }
  }

  /// Verifica se um único item (em formato de mapa bruto) corresponde a um conjunto de filtros.
  bool _itemMatchesFilter(Map<String, dynamic> rawData, List<FilterExpress> filter) {
    try {
      final item = JxModel.fromJson(rawData, model);

      for (var filterExpr in filter) {
        final fieldName = filterExpr.fieldName;
        final operator = filterExpr.operator;
        final filterValue = filterExpr.value;

        final fieldValue = item.fieldByName(fieldName);

        // Log para depuração
        JxLog.trace(
          "Filtrando: Campo '$fieldName' (valor: $fieldValue) ${operator.toString().split('.').last} (filtro: $filterValue)",
        );

        bool fieldMatches = false;
        switch (operator) {
          case FilterOperator.equal:
            fieldMatches = (fieldValue == filterValue);
            break;
          case FilterOperator.notEqual:
            fieldMatches = (fieldValue != filterValue);
            break;
          case FilterOperator.greaterThan:
            if (fieldValue is num && filterValue is num) {
              fieldMatches = fieldValue > filterValue;
            }
            break;
          case FilterOperator.lessThan:
            if (fieldValue is num && filterValue is num) {
              fieldMatches = fieldValue < filterValue;
            }
            break;
          case FilterOperator.greaterThanOrEqual:
            if (fieldValue is num && filterValue is num) {
              fieldMatches = fieldValue >= filterValue;
            }
            break;
          case FilterOperator.lessThanOrEqual:
            if (fieldValue is num && filterValue is num) {
              fieldMatches = fieldValue <= filterValue;
            }
            break;
          case FilterOperator.contains:
            fieldMatches = fieldValue.toString().toLowerCase().contains(
              filterValue.toString().toLowerCase(),
            );
            break;
          case FilterOperator.startsWith:
            fieldMatches = fieldValue.toString().toLowerCase().startsWith(
              filterValue.toString().toLowerCase(),
            );
            break;
          case FilterOperator.endsWith:
            fieldMatches = fieldValue.toString().toLowerCase().endsWith(
              filterValue.toString().toLowerCase(),
            );
            break;
        }

        if (!fieldMatches) {
          JxLog.trace(" -> Resultado: Falso");
          return false; // Se qualquer filtro falhar, o item não corresponde.
        }
      }

      JxLog.trace(" -> Resultado: Verdadeiro (todas as condições passaram)");
      return true; // Se todos os filtros passarem, o item corresponde.
    } catch (e) {
      JxLog.error("Erro ao filtrar item: $e");
      return false;
    }
  }
}
