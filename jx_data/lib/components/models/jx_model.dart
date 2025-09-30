// ignore_for_file: unnecessary_getters_setters

import 'package:jx_utils/jx_utils.dart';
import 'package:jx_utils/logs/jx_log.dart';

import 'jx_field.dart';

class JxModel {
  List<JxField>? _fields;

  JxModel([List<JxField>? fields]) : _fields = fields ?? [];

  JxModel.clone(JxModel original) {
    _fields = original._fields?.map((f) => JxField.from(f)).toList();
  }

  factory JxModel.fromFields(List<JxField> fields) {
    final clonedFields = fields.map((f) => JxField.from(f)).toList();
    return JxModel(clonedFields);
  }

  List<JxField>? get fields => _fields;

  String? _tableName;

  String get tableName => _tableName ?? "";
  set tableName(String v) => _tableName;

  set fields(List<JxField>? newFields) => _fields = newFields;

  dynamic operator [](String fieldName) {
    return _fields
        ?.firstWhere(
          (field) => field.jsonName == fieldName || field.name == fieldName,
          orElse: () => throw Exception('O campo $fieldName não existe na tabela'),
        )
        .value;
  }

  Map<String, String> fieldsValues() {
    return {for (var f in _fields ?? []) f.name: f.jsonName};
  }

  void setField(String key, dynamic value) {
    var field = _fields?.firstWhere(
      (f) => f.jsonName == key || f.name == key,
      orElse: () => throw Exception('O campo $key não existe na tabela'),
    );
    field?.value = value;
  }

  dynamic fieldByName(String fieldName) {
    var field = _fields?.firstWhere(
      (f) => f.jsonName == fieldName || f.name == fieldName,
      orElse: () => throw Exception('O campo $fieldName não existe na tabela'),
    );

    dynamic value = field?.value;
    if (value == null || value == "") {
      return value;
    }

    if (field?.type == FieldType.ftMoney || field?.type == FieldType.ftDouble) {
      var (parsedValue, success) = tryDouble(value);
      if (!success) {
        value = doubleRawValue(value); // Assume que esta função existe
      } else {
        value = parsedValue;
      }
    }

    return value;
  }

  void setFieldByName(String fieldName, dynamic value) {
    var field = _fields?.firstWhere(
      (f) => f.jsonName == fieldName || f.name == fieldName,
      orElse: () => throw Exception('O campo $fieldName não existe na tabela'),
    );
    field?.value = value;
    field?.modified = true;
    JxLog.trace("campo $fieldName => $value");
  }

  bool isModified() {
    return _fields?.any((field) => field.modified) ?? false;
  }

  Map<String, dynamic> field2Json() {
    if (_fields == null) {
      return {};
    }

    final editableFields = _fields?.where((field) => field.readOnly == false);
    final result = {for (var field in editableFields!) field.jsonName: field.rawValue()};
    return result;
  }

  factory JxModel.fromJson(Map<String, dynamic> json, List<JxField> fields) {
    return JxModel(json2Field(json, fields));
  }

  static DateTime? _parseDateTime(dynamic value) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      // Você pode querer tratar o erro ou simplesmente registrar um log.
      // Por exemplo, você poderia registrar o erro:
      JxLog.error("error: $e");
      return null;
    }
  }

  static List<JxField> json2Field(Map<String, dynamic> json, List<JxField> fields) {
    // Converte as chaves do JSON para minúsculas uma única vez para otimização.
    final jsonLowercase = json.map((k, v) => MapEntry(k.toLowerCase(), v));

    // Transforma os fields, mapeando os valores do JSON.
    JxLog.trace("json2Field inicio ...");
    final result = fields.map((field) {
      // Se o campo for calculado, retorna-o diretamente sem processar.
      if (field.calculated) {
        JxLog.info("... json2Field final calculated");
        return field;
      }

      dynamic value;

      if (field.joinTableField != null) {
        // Para campos de join, o Supabase retorna um objeto com o nome do campo como chave.
        // Ex: { "condominio_nome": { "nome": "Condo A" } }
        final joinKey = field.name.toLowerCase();
        if (jsonLowercase.containsKey(joinKey) && jsonLowercase[joinKey] is Map) {
          // Extrai o valor de dentro do objeto aninhado.
          // O nome do campo dentro do objeto é a última parte do 'joinTableField'.
          final joinedFieldKey = field.joinTableField!.split(RegExp(r'[!.]')).last.toLowerCase();
          value = jsonLowercase[joinKey][joinedFieldKey];
        }
      } else {
        // Lógica para campos normais
        final key = field.jsonName.toLowerCase();
        value = jsonLowercase[key];
      }

      if (value != null) {
        // Tenta converter o valor para DateTime se o tipo do campo for ftDate ou ftDateTime.
        // O uso de `is` garante que a conversão seja segura.
        if (field.type == FieldType.ftDate || field.type == FieldType.ftDateTime) {
          value = _parseDateTime(value);
        }
      }
      // Cria uma nova instância de JxField com o valor atualizado.
      //JxLog.info("field.name ${field.name} field.value ${field.value} value $value");
      return JxField.from(field..value = value);
    }).toList();

    JxLog.trace("... json2Field final");
    return result;
  }

  // Função auxiliar para tentar fazer o parse de uma string para DateTime.

  JxModel clone() {
    return JxModel.clone(this);
  }

  List<String> sqlFields() {
    if (fields == null) {
      return [];
    }
    final List<String> fieldList = [];
    for (var field in fields!) {
      fieldList.add(field.dbName);
    }
    return fieldList;
  }
}

// (dynamic, bool) tryDouble(dynamic value) {
//   try {
//     final parsedValue = double.parse(value.toString());
//     return (parsedValue, true);
//   } catch (_) {
//     return (value, false);
//   }
// }
