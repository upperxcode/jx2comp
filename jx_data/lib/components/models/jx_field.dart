import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:jx_data/components/utils/constant.dart';
import 'package:jx_data/components/widgets/dropdown/jx_lookup.dart';

import 'package:jx_utils/jx_utils.dart';
import 'package:jx_utils/logs/log.dart';

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
  ftTelefone,
  ftCpf,
  ftCnpj,
  ftCpfCnpj,
  ftKM,
  ftPeso,
  ftAltura,
  ftCartao,
  ftValidadeCartao,
  ftPlacaVeiculo,
  ftTemperatura,
  ftIof,
  ftNCM,
  ftNUP,
  ftCEST,
  ftCNS,
  ftUf,
  ftText,
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
  final Lookup? lookupTable;
  final bool loockup;
  final JxField? matchField; // Garantir que este campo seja inicializado.
  final String? format;
  final String tip;
  final bool calculated;
  final List<String> calculation;
  final String? joinTableField;

  //
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
    joinTableField = "",
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
    String? joinTableField,
    int size = 0,
  }) {
    return JxField(
      name,
      name,
      null,
      type,
      displayName: displayName == "" ? transformName(name) : displayName,
      dbName: name,
      loockup: lookupTable != null,
      lookupTable: lookupTable,
      visible: visible,
      readOnly: readOnly || (joinTableField != null), // Se for join, é sempre readOnly
      joinTableField: joinTableField,
      calculated: calculation.isEmpty ? false : true,
      calculation: calculation,
      size: type == FieldType.ftUf ? 2 : size,
      validate: name == 'id' ? false : true,
      notNull: name == 'id' ? false : true,
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
    this.matchField, // Adiciona o campo matchField ao construtor para inicialização.
    this.calculated = false,
    this.calculation = const [],
    this.joinTableField,
    TextEditingController? controller,
  }) : _controller = controller ?? TextEditingController() {
    if (loockup && lookupTable == null) {
      throw ArgumentError('Para campos do tipo ftLookup, o lookupTable deve ser definido.');
    }
    // Ao construir o objeto, já definimos o valor bruto e o formatado.
    // Usamos um `v` temporário para evitar conflito com o setter.
    dynamic v = value;
    if (v != null) {
      _value = _getRawValue(v);
      _controller.text = _getFormattedValue() ?? '';
    } else {
      _value = v;
      _controller.text = '';
    }
  }
  TextEditingController get controller => _controller;
  set value(dynamic v) {
    if (v != _value) {
      // 1. Armazena o valor bruto (raw)
      _value = _getRawValue(v);
      _modified = true;
      // 2. Atualiza o controller com o valor formatado para exibição na UI
      _controller.text = _getFormattedValue() ?? '';
      JxLog.trace("set value => _controller ${_controller.text}");
    }
  }

  dynamic rawValue() {
    return _parseRawValue(_value);
  }

  dynamic get value => _value; // Getter sempre retorna o valor bruto
  bool get modified => _modified;
  set modified(bool v) {
    _modified = v;
  }

  FieldType get fieldType => type;
  int toInt() {
    final valor = int.tryParse(_controller.text) ?? 0;
    return valor;
  }

  /// Retorna o valor formatado como string para exibição.
  String? getFormattedValue() {
    return _getFormattedValue();
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
      joinTableField: other.joinTableField,
      controller: TextEditingController.fromValue(TextEditingValue(text: other._value.toString())),
    );
  }

  /// Retorna o valor formatado como string para exibição.
  String? _getFormattedValue() {
    final v = _value;
    if (v == null) return null;
    String result = "";

    try {
      switch (type) {
        case FieldType.ftMoney:
        case FieldType.ftDouble:
          result = UtilBrasilFields.obterReal(double.tryParse(v.toString()) ?? 0.0);
        case FieldType.ftTelefone:
          return UtilBrasilFields.obterTelefone(v.toString());
        case FieldType.ftCep:
          String cep = v.toString();
          // Garante que o CEP tenha no máximo 8 dígitos e preenche com zeros à esquerda se necessário.
          result = UtilBrasilFields.obterCep(cep.padLeft(8, '0').substring(0, 8));
        case FieldType.ftCpf:
          result = UtilBrasilFields.obterCpf(v.toString());
        case FieldType.ftCnpj:
          result = UtilBrasilFields.obterCnpj(v.toString());
        case FieldType.ftCpfCnpj:
          result = v.toString().length < 12
              ? UtilBrasilFields.obterCpf(v.toString())
              : UtilBrasilFields.obterCnpj(v.toString());
        case FieldType.ftDate:
          result = v is DateTime ? UtilData.obterDataDDMMAAAA(v) : v.toString();
        case FieldType.ftDateTime:
          result = v is DateTime ? UtilData.obterDataDDMMAAAA(v) : v.toString();
        default:
          result = v.toString();
      }
    } catch (e) {
      JxLog.error("Error a tentar formatar valor: $v tipo: $type. $e");
    }
    JxLog.trace("formatando valor: $v result $result");
    return result;
  }

  /// Remove a formatação de uma string e retorna o valor bruto.
  dynamic _getRawValue(dynamic v) {
    if (v is String && v.isNotEmpty) {
      // Aplica a remoção de caracteres apenas para os campos que usam máscaras.
      // Outros campos de texto, como endereço, não serão modificados.
      const typesToClean = [
        FieldType.ftTelefone,
        FieldType.ftCep,
        FieldType.ftCpf,
        FieldType.ftCnpj,
        FieldType.ftCpfCnpj,
      ];

      if (typesToClean.contains(type)) {
        return UtilBrasilFields.removeCaracteres(v);
      }
    }
    return v;
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
        return (value ? 1 : 0);
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
        matchField: props['matchField'],
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
      case FieldType.ftKM:
      case FieldType.ftPeso:
      case FieldType.ftTemperatura:
        value = int.tryParse(strValue);
        break;
      case FieldType.ftDouble:
      case FieldType.ftIof:
      case FieldType.ftMoney:
        value = double.tryParse(strValue);
        break;
      case FieldType.ftUf:
        value = strValue.toUpperCase();
        break;
      case FieldType.ftEmail:
        value = strValue.toLowerCase();
        break;
      default:
        value = strValue;
    }
    _normalizeText();
  }

  void _normalizeText() {
    switch (fieldType) {
      case FieldType.ftUf:
        value = value.toString().toUpperCase();
        break;
      case FieldType.ftEmail:
        value = value.toString().toLowerCase();
        break;
      default:
        value = value;
    }
  }

  String normalizeText(String v) {
    switch (fieldType) {
      case FieldType.ftUf:
        value = v.toString().toUpperCase();
        return value;
      case FieldType.ftEmail:
        value = v.toString().toLowerCase();
        return value;
      default:
        return v.toString();
    }
  }

  bool get isDigit => [
    FieldType.ftDouble,
    FieldType.ftMoney,
    FieldType.ftInteger,
    FieldType.ftCep,
    FieldType.ftTemperatura,
    FieldType.ftKM,
    FieldType.ftPeso,
    FieldType.ftTelefone,
    FieldType.ftValidadeCartao,
    FieldType.ftCpf,
    FieldType.ftCnpj,
    FieldType.ftCpfCnpj,
  ].contains(type);
  bool get isDateTime => [FieldType.ftDate, FieldType.ftDateTime].contains(type);
  bool get isDouble => [FieldType.ftDouble, FieldType.ftMoney, FieldType.ftIof].contains(type);
  bool get isMoney => type == FieldType.ftMoney;
  bool get isFormated {
    return isTextOnly ||
        [
          FieldType.ftCep,
          FieldType.ftTemperatura,
          FieldType.ftKM,
          FieldType.ftPeso,
          FieldType.ftTelefone,
          FieldType.ftValidadeCartao,
          FieldType.ftCpf,
          FieldType.ftCnpj,
          FieldType.ftCpfCnpj,
        ].contains(type);
    ;
  }

  bool get isTextOnly => [
    FieldType.ftString,
    FieldType.ftPlacaVeiculo,
    FieldType.ftUf,
    FieldType.ftText,
    FieldType.ftNCM,
    FieldType.ftNUP,
    FieldType.ftCEST,
    FieldType.ftCNS,
    FieldType.ftEmail,
    FieldType.ftPassword,
    FieldType.ftPasswordConfirm,
  ].contains(type);
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
      case FieldType.ftKM:
      case FieldType.ftPeso:
      case FieldType.ftTemperatura:
        return 'int';
      case FieldType.ftDouble:
      case FieldType.ftIof:
      case FieldType.ftMoney:
        return 'float64';
      case FieldType.ftString:
      case FieldType.ftPassword:
      case FieldType.ftPasswordConfirm:
      case FieldType.ftEmail:
      case FieldType.ftTelefone:
      case FieldType.ftCpf:
      case FieldType.ftCnpj:
      case FieldType.ftCpfCnpj:
      case FieldType.ftValidadeCartao:
      case FieldType.ftPlacaVeiculo:
      case FieldType.ftNCM:
      case FieldType.ftNUP:
      case FieldType.ftCEST:
      case FieldType.ftCNS:
      case FieldType.ftUf:
      case FieldType.ftText:
        return 'string';
      case FieldType.ftBool:
        return 'bool';
      case FieldType.ftDate:
      case FieldType.ftDateTime:
        return 'time.Time';
      default:
        return 'interface{}';
    }
  }

  static String convertTypeToDartType(FieldType type) {
    switch (type) {
      case FieldType.ftInteger:
      case FieldType.ftKM:
      case FieldType.ftPeso:
      case FieldType.ftTemperatura:
        return 'int';
      case FieldType.ftDouble:
      case FieldType.ftIof:
      case FieldType.ftMoney:
        return 'double';
      case FieldType.ftString:
      case FieldType.ftPassword:
      case FieldType.ftPasswordConfirm:
      case FieldType.ftEmail:
      case FieldType.ftTelefone:
      case FieldType.ftCpf:
      case FieldType.ftCnpj:
      case FieldType.ftCpfCnpj:
      case FieldType.ftValidadeCartao:
      case FieldType.ftPlacaVeiculo:
      case FieldType.ftNCM:
      case FieldType.ftNUP:
      case FieldType.ftCEST:
      case FieldType.ftCNS:
      case FieldType.ftUf:
      case FieldType.ftText:
        return 'String';
      case FieldType.ftBool:
        return 'bool';
      case FieldType.ftDate:
      case FieldType.ftDateTime:
        return 'DateTime';
      default:
        return 'dynamic';
    }
  }
}
