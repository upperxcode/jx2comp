import 'package:jx_data/components/models/jx_field.dart';

import 'base_store.dart';

abstract class Store extends BaseStore {
  final List<JxField> jxFields;
  Store(this.jxFields) : super(jxFields);

  /// Deleta o registro atual da fonte de dados.
  Future<bool?> deleteRecord();

  /// Salva o registro atual (novo ou modificado) na fonte de dados.
  Future<bool?> saveRecord();

  /// Busca os dados da fonte de dados (ex: API, banco de dados).
  Future<void> fetchData() async {}

  /// Hook executado após a conclusão do [fetchData].
  void onAfterFetchData() {}
}
