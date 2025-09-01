// ignore_for_file: unnecessary_getters_setters

import 'package:jx_utils/jx_utils.dart';

import 'jx_field.dart';

class JxModel {
  List<JxField>? _fields;

  JxModel([List<JxField>? fields]) : _fields = fields ?? [];

  JxModel.clone(JxModel original) {
    _fields = original._fields?.map((f) => JxField.from(f)).toList();
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
  }

  bool isModified() {
    return _fields?.any((field) => field.modified) ?? false;
  }

  Map<String, dynamic> field2Json() {
    return _fields?.asMap().map((i, field) => MapEntry(field.jsonName, field.rawValue())) ?? {};
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
      print('Erro ao fazer parse do DateTime: $e');
      return null;
    }
  }

  static List<JxField> json2Field(Map<String, dynamic> json, List<JxField> fields) {
    // Converte as chaves do JSON para minúsculas uma única vez para otimização.
    final jsonLowercase = json.map((k, v) => MapEntry(k.toLowerCase(), v));

    // Transforma os fields, mapeando os valores do JSON.
    return fields.map((field) {
      // Se o campo for calculado, retorna-o diretamente sem processar.
      if (field.calculated) {
        return field;
      }

      final key = field.jsonName.toLowerCase();
      dynamic value = jsonLowercase[key];

      // Lança uma exceção se o valor correspondente não for encontrado.
      // Isso é crucial para garantir a integridade dos dados.
      if (value == null) {
        throw Exception('O campo "${field.jsonName}" não foi encontrado na tabela.');
      }

      // Tenta converter o valor para DateTime se o tipo do campo for ftDate ou ftDateTime.
      // O uso de `is` garante que a conversão seja segura.
      if (field.type == FieldType.ftDate || field.type == FieldType.ftDateTime) {
        value = _parseDateTime(value);
      }

      // Cria uma nova instância de JxField com o valor atualizado.
      return JxField.from(field..value = value);
    }).toList();
  }

  // Função auxiliar para tentar fazer o parse de uma string para DateTime.

  JxModel clone() {
    return JxModel.clone(this);
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
