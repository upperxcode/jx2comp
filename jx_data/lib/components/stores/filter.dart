/// Operadores disponíveis para filtros
enum FilterOperator {
  equal, // =
  notEqual, // !=
  greaterThan, // >
  lessThan, // <
  greaterThanOrEqual, // >=
  lessThanOrEqual, // <=
  contains, // contém
  startsWith, // inicia com
  endsWith, // termina com
}

/// Estrutura que representa uma expressão de filtro
class FilterExpress {
  final String fieldName;
  final FilterOperator operator;
  final dynamic value;

  FilterExpress(this.fieldName, this.operator, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterExpress &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName &&
          operator == other.operator &&
          value == other.value;

  @override
  int get hashCode => Object.hash(fieldName, operator, value);
}

/// Exemplo de uso do setFilter:
///
/// // Filtro simples - condominio igual a "1"
/// var filtro1 = FilterExpress("condominio", FilterOperator.equal, "1");
/// setFilter([filtro1]);
///
/// // Filtro composto - condominio igual a "1" E nome contém "joão"
/// var filtro2 = FilterExpress("condominio", FilterOperator.equal, "1");
/// var filtro3 = FilterExpress("nome", FilterOperator.contains, "joão");
/// setFilter([filtro2, filtro3]);
///
/// // Filtro com diferentes operadores
/// var filtro4 = FilterExpress("idade", FilterOperator.greaterThan, 18);
/// var filtro5 = FilterExpress("email", FilterOperator.endsWith, "@gmail.com");
/// setFilter([filtro4, filtro5]);
///
/// // Resetar filtro (limpar todos os filtros)
/// setFilter([]);
