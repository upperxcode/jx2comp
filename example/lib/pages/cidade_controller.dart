import 'package:jx2_grid/components/grid_data_source.dart';
import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_data/jx_data.dart';

class CidadeController extends Store implements GridDataSource {
  @override
  set dbstate(DbState? value) {
    // Handle nullable DbState here
    super.dbstate = value!;
  }

  CidadeController() : super(_fields) {
    // Inicialize o controlador aqui
    // Por exemplo, você pode carregar dados iniciais ou configurar variáveis
  }
  @override
  List<JxField> get fields => super.fields!;
  @override
  dynamic fieldByName(String key) {
    // Implemente a lógica para retornar o valor do campo pelo nome
    return super.fieldByName(key);
  }

  @override
  Future<bool> refresh([String? controle]) async {
    // Implemente a lógica para atualizar os dados
    return await super.refresh(controle);
  }

  @override
  void updateControllerByData() {
    // Implemente a lógica para atualizar o controlador com os dados
    super.updateControllerByData();
  }
}

final List<JxField> _fields = [
  JxField("id", "id", 0, FieldType.ftInteger, readOnly: true, dbName: "id", displayName: "ID"),
  JxField("nome", "nome", "", FieldType.ftString, dbName: "Nome", displayName: "Nome"),
  JxField(
    "estado",
    "estado_id",
    0,
    FieldType.ftInteger,
    readOnly: true,
    dbName: "estado_id",
    displayName: "Estado",
  ),
  JxField(
    "nome_estado",
    "nome_estado",
    "",
    FieldType.ftString,
    dbName: "nome_estado",
    displayName: "Nome Estado",
  ),
  JxField("ibge", "ibge", "", FieldType.ftString, dbName: "ibge", displayName: "IBGE"),
  JxField("cod_tom", "cod_tom", "", FieldType.ftString, dbName: "cod_tom", displayName: "cod_tom"),
  JxField(
    "created_at",
    "created_at",
    "",
    FieldType.ftDateTime,
    readOnly: true,
    dbName: "created_at",
    displayName: "Criado em",
  ),
  JxField(
    "updated_at",
    "updated_at",
    "",
    FieldType.ftDateTime,
    readOnly: true,
    dbName: "updated_at",
    displayName: "Atualizado em",
  ),
];
