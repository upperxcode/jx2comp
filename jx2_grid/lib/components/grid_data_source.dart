import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_data/jx_data.dart';

abstract class GridDataSource {
  List<JxField> get fields;
  dynamic fieldByName(String name);
  Future<void> refresh(String reason);
  void last();

  DbState? get dbstate;
  set dbstate(DbState? value);
  void updateControllerByData();
  // Adicione outros métodos necessários da sua classe Store que o GridController precisa
}
