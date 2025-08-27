// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jx_data/components/utils/constant.dart';
import 'package:jx_data/jx_data.dart';
import 'package:jx_utils/jx_utils.dart';

enum FieldType {
  ftString,
  ftInteger,
  ftDouble,
  ftMoney,
  ftDate,
  ftDateTime,
  ftPassword,
  ftPasswordConfirm,
  ftEmail,
  ftCep,
  ftBool,
}

class JxField {
  final String name;
  final String jsonName;
  final String dbName;
  final FieldType type;
  final int size;
  final int minSize;
  final bool validate;
  final bool notNull;
  final String placeholder;
  final bool readOnly;
  final bool visible;
  final double min;
  final double max;
  final int decimals;
  final TextAlign align;
  final Icon? icon;
  final TextEditingController _controller;
  bool _modified = false;
  final String? displayName;
  final Store? lookupTable;
  final bool loockup;
  final JxField? match; // Garantir que este campo seja inicializado.
  final String? format;
  final String tip;
  final bool calculated;
  final List<String> calculation;
  dynamic _value;

  static JxField createField({
    required String name,
    required String jsonName,
    required dynamic defaultValue,
    required FieldType type,
    String displayName = '',
    String dbName = '',
    String tip = '',
    int size = 0,
    TextAlign align = TextAlign.left,
    bool loockup = false,
    dynamic lookupTable,
    int decimals = 0,
    bool visible = true,
    readOnly = false,
    calculated = false,
    calculation = "",
  }) {
    return JxField(
      name,
      jsonName,
      defaultValue,
      type,
      displayName: displayName,
      dbName: dbName == '' ? jsonName : dbName,
      tip: tip,
      size: size,
      align: align,
      loockup: loockup,
      lookupTable: lookupTable,
      decimals: decimals,
      visible: visible,
      readOnly: readOnly,
      calculated: calculated,
      calculation: calculation,
    );
  }

  /// Cria uma nova instância de `JxField` com valores padrão baseados no tipo.
  ///
  /// Este construtor de fábrica é ideal para inicializar campos de forma rápida
  /// sem a necessidade de definir um valor inicial manualmente.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// final nomeCampo = JxField.of("nome", FieldType.ftString);
  /// print(nomeCampo.value); // Saída: ""
  /// ```
  factory JxField.of(
    String name,
    FieldType type, {
    dynamic lookupTable,
    List<String> calculation = const [],
    bool visible = true,
    bool readOnly = false,
    String displayName = "",
  }) {
    return JxField(
      name,
      name,
      [FieldType.ftDouble, FieldType.ftMoney, FieldType.ftInteger, FieldType.ftCep].contains(type)
          ? 1
          : "",
      type,
      displayName: displayName == "" ? name : displayName,
      dbName: name,
      loockup: lookupTable != null,
      lookupTable: lookupTable,
      visible: visible,
      readOnly: readOnly,
      calculated: calculation.isEmpty ? false : true,
      calculation: calculation,
    );
  }

  JxField(
    this.name,
    this.jsonName,
    dynamic value,
    this.type, {
    this.lookupTable,
    this.displayName,
    this.dbName = '',
    this.size = 0,
    this.minSize = 0,
    this.decimals = 2,
    this.validate = true,
    this.notNull = true,
    this.placeholder = '',
    this.readOnly = false,
    this.visible = true,
    this.min = double.negativeInfinity,
    this.max = double.infinity,
    this.icon,
    this.align = TextAlign.start,
    this.format,
    this.tip = "",
    this.loockup = false,
    this.match, // Adiciona o campo match ao construtor para inicialização.
    this.calculated = false,
    this.calculation = const [],
    TextEditingController? controller,
  }) : _controller = controller ?? TextEditingController() {
    if (loockup && lookupTable == null) {
      throw ArgumentError('Para campos do tipo ftLookup, o lookupTable deve ser definido.');
    }
    _controller.text = value.toString();

    _value = value;
  }

  TextEditingController get controller => _controller;

  set value(dynamic v) {
    if (v != _value) {
      _value = _parseValue(v);
      _modified = true;
      _controller.text = _value.toString();
    }
  }

  dynamic rawValue() {
    return _parseRawValue(_value);
  }

  dynamic get value => _value;

  bool get modified => _modified;

  set modified(bool v) {
    _modified = v;
  }

  FieldType get fieldType => type;

  int toInt() {
    final valor = int.tryParse(_controller.text) ?? 0;
    return valor;
  }

  @override
  String toString() {
    final valor = _controller.text;
    return valor;
  }

  // Factory method to clone an existing JxField
  factory JxField.from(JxField other) {
    return JxField(
      other.name,
      other.jsonName,
      other._value,
      other.type,
      displayName: other.displayName,
      size: other.size,
      minSize: other.minSize,
      decimals: other.decimals,
      validate: other.validate,
      notNull: other.notNull,
      placeholder: other.placeholder,
      readOnly: other.readOnly,
      visible: other.visible,
      min: other.min,
      max: other.max,
      icon: other.icon,
      align: other.align,
      format: other.format,
      tip: other.tip,
      loockup: other.loockup,
      lookupTable: other.lookupTable,
      calculated: other.calculated,
      calculation: other.calculation,
      controller: TextEditingController.fromValue(TextEditingValue(text: other._value.toString())),
    );
  }

  // Helper method for parsing values based on their field type
  dynamic _parseValue(dynamic value) {
    switch (type) {
      case FieldType.ftInteger:
        return int.tryParse(value.toString());
      case FieldType.ftDouble:
      case FieldType.ftMoney:
        {
          String decimalPart = List.filled(decimals, '0').join();
          if (decimalPart.isNotEmpty) decimalPart = ".$decimalPart";
          final (parsedValue, success) = tryDouble(value);
          if (!success) {
            value = doubleRawValue(value); // Assume que esta função existe
          } else {
            value = parsedValue;
          }
          if (type == FieldType.ftDouble) {
            final NumberFormat formatCurrency = NumberFormat(
              "$doubleFormat$decimalPart",
              countryLocale,
            );
            value = formatCurrency.format(value ?? 0);
          } else {
            final NumberFormat formatCurrency = NumberFormat(
              "$moneyFormat$decimalPart",
              countryLocale,
            );
            value = formatCurrency.format(value ?? 0);
          }
          return value;
        }
      default:
        return value;
    }
  }

  dynamic _parseRawValue(dynamic value) {
    switch (type) {
      case FieldType.ftInteger:
        return int.tryParse(value.toString());
      case FieldType.ftBool:
        return (value == true);
      case FieldType.ftDouble:
      case FieldType.ftMoney:
        {
          String decimalPart = List.filled(decimals, '0').join();
          if (decimalPart.isNotEmpty) decimalPart = ".$decimalPart";
          final (parsedValue, success) = tryDouble(value);
          if (!success) {
            value = doubleRawValue(value); // Assume que esta função existe
          } else {
            value = parsedValue;
          }

          return value;
        }
      default:
        return value;
    }
  }

  // Helper method to create multiple fields
  static List<JxField> createFields(List<Map<String, dynamic>> fieldProps) {
    return fieldProps.map((props) {
      return JxField(
        props['name'],
        props['jsonName'],
        props['value'],
        props['type'],
        displayName: props['displayName'],
        size: props['size'] ?? 0,
        minSize: props['minSize'] ?? 0,
        decimals: props['decimals'] ?? 2,
        validate: props['validate'] ?? true,
        notNull: props['notNull'] ?? true,
        placeholder: props['placeholder'] ?? '',
        readOnly: props['readOnly'] ?? false,
        visible: props['visible'] ?? true,
        min: props['min'] ?? double.negativeInfinity,
        max: props['max'] ?? double.infinity,
        icon: props['icon'],
        align: props['align'] ?? TextAlign.start,
        format: props['format'],
        tip: props['tip'] ?? "",
        match: props['match'],
        loockup: props['lookup'],
        lookupTable: props['lookupTable'],
        calculated: props['calculated'],
        calculation: props['calculation'],
      );
    }).toList();
  }

  void updateByStr(String strValue) {
    switch (fieldType) {
      case FieldType.ftInteger:
        value = int.tryParse(strValue);
        break;
      case FieldType.ftDouble:
        value = double.tryParse(strValue);
        break;
      default:
        value = strValue;
    }
  }

  bool get isDigit =>
      [FieldType.ftDouble, FieldType.ftMoney, FieldType.ftInteger, FieldType.ftCep].contains(type);

  bool get isDateTime => [FieldType.ftDate, FieldType.ftDateTime].contains(type);

  bool get isDouble => [FieldType.ftDouble, FieldType.ftMoney].contains(type);
  bool get isMoney => type == FieldType.ftMoney;

  static String fields2DartClass(String className, List<JxField> fields) {
    // Inicia a definição da classe com o nome fornecido
    String classDefinition = 'class $className {\n';

    // Itera sobre cada campo para gerar as variáveis da classe
    for (var field in fields) {
      // Converte o FieldType para o tipo Dart correspondente
      String dartType = convertTypeToDartType(field.type);
      // Adiciona a variável à definição da classe
      classDefinition += '  final $dartType ${field.name};\n';
    }

    // Fecha a definição da classe
    classDefinition += '}';

    return classDefinition;
  }

  static String fields2GoStruct(String structName, List<JxField> fields) {
    var structDefinition = 'type $structName struct {\n';
    for (var field in fields) {
      var goType = convertTypeToGoType(field.type);

      structDefinition +=
          '\t${field.name} $goType `json:"${field.jsonName.toLowerCase()}" db:"${field.dbName.toLowerCase()}"`\n';
    }
    structDefinition += '}\n';
    return structDefinition;
  }

  static String convertTypeToGoType(FieldType fieldType) {
    switch (fieldType) {
      case FieldType.ftInteger:
        return 'int';
      case FieldType.ftDouble:
        return 'float64';
      case FieldType.ftString:
        return 'string';
      case FieldType.ftBool:
        return 'bool';
      case FieldType.ftDate:
        return 'time.Time';
      default:
        return 'interface{}';
    }
  }

  static String convertTypeToDartType(FieldType type) {
    switch (type) {
      case FieldType.ftInteger:
        return 'int';
      case FieldType.ftDouble:
        return 'double';
      case FieldType.ftString:
        return 'String';
      case FieldType.ftBool:
        return 'bool';
      case FieldType.ftDate:
      case FieldType.ftDateTime:
        return 'DateTime';
      case FieldType.ftMoney:
        // Dart não tem um tipo específico para dinheiro. Use double ou crie uma classe customizada.
        return 'double';
      default:
        return 'dynamic';
    }
  }
}
