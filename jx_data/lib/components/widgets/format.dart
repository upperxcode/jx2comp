import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:jx_data/components/models/jx_field.dart';

List<TextInputFormatter> format(JxField field) {
  return [
    if (field.isDigit) FilteringTextInputFormatter.digitsOnly,
    if (field.isMoney && field.decimals > 0)
      CentavosInputFormatter(moeda: true, casasDecimais: field.decimals)
    else if (field.isDouble)
      CentavosInputFormatter(moeda: false, casasDecimais: field.decimals),
    if (field.type == FieldType.ftCep) CepInputFormatter(),
  ];
}
