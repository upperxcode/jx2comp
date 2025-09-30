import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_data/components/models/jx_model.dart';
import 'package:jx_data/components/stores/enums.dart';
import 'package:jx_data/components/stores/filter.dart';

/// Define o contrato que uma classe deve seguir para usar o [FilteringMixin].
/// Isso evita a herança recursiva, desacoplando o mixin da implementação concreta do BaseStore.
abstract class Filterable {
  DbState get dbstate;
  int get recno;
  set recno(int value);
  List<Map<String, dynamic>> get dataList;
  List<JxField> get model;
  List<JxModel> get items;
  set items(List<JxModel> value);
  List<JxModel> get filteredItems;
  set filteredItems(List<JxModel> value);

  bool get isFiltered;
  bool get isFilterON;
  List<FilterExpress> get currentFilter;

  void setFilter(List<FilterExpress> filter);

  void updateControllerByData();
  int currentIdByRecno(int recno);
  int getRecnoById(int id);
}
