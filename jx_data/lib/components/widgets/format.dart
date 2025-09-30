import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:jx_data/components/models/jx_field.dart';

List<TextInputFormatter> format(JxField field) {
  final formatters = <TextInputFormatter>[];

  // Formatters baseados em propriedades
  if (field.isDigit) {
    formatters.add(FilteringTextInputFormatter.digitsOnly);
  }

  if (field.fieldType == FieldType.ftEmail) {
    formatters.add(LowerCaseTextFormatter());
  }

  if (field.fieldType == FieldType.ftUf) {
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'));
    formatters.add(UpperCaseTextFormatter());
  }

  if (field.isMoney && field.decimals > 0) {
    formatters.add(CentavosInputFormatter(moeda: true, casasDecimais: field.decimals));
  } else if (field.isDouble) {
    formatters.add(CentavosInputFormatter(moeda: false, casasDecimais: field.decimals));
  }

  // Formatter baseado no tipo
  final typeFormatter = _getTypeFormatter(field.type);
  if (typeFormatter != null) {
    formatters.add(typeFormatter);
  }

  return formatters;
}

TextInputFormatter? onlyFormat(JxField field) {
  return _getTypeFormatter(field.type);
}

TextInputFormatter? _getTypeFormatter(FieldType type) {
  return switch (type) {
    FieldType.ftCep => CepInputFormatter(),
    FieldType.ftAltura => AlturaInputFormatter(),
    FieldType.ftTelefone => TelefoneInputFormatter(),
    FieldType.ftCpf => CpfInputFormatter(),
    FieldType.ftCnpj => CnpjAlfanumericoInputFormatter(),
    FieldType.ftCpfCnpj => CpfOuCnpjAlfanumericoFormatter(),
    FieldType.ftKM => KmInputFormatter(),
    FieldType.ftPeso => PesoInputFormatter(),
    FieldType.ftCartao => CartaoBancarioInputFormatter(),
    FieldType.ftValidadeCartao => ValidadeCartaoInputFormatter(),
    FieldType.ftPlacaVeiculo => PlacaVeiculoInputFormatter(),
    FieldType.ftTemperatura => TemperaturaInputFormatter(),
    FieldType.ftIof => IOFInputFormatter(),
    FieldType.ftNCM => NCMInputFormatter(),
    FieldType.ftNUP => NUPInputFormatter(),
    FieldType.ftCEST => CESTInputFormatter(),
    FieldType.ftCNS => CNSInputFormatter(),

    _ => null,
  };
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}
