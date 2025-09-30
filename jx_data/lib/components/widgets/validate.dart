import 'package:jx_data/components/models/jx_field.dart';
import 'package:brasil_fields/brasil_fields.dart';

import '../utils/validate/constants.dart';
import '../utils/validate/email_validate.dart';
import '../utils/validate/password.dart';

bool minBmax(JxField field, double value) {
  return (value >= field.min && value <= field.max);
}

String? validate(String? value, JxField field, [JxField? match]) {
  if (value == null) return null;
  final length = value.length;

  var type = field.type;
  if (value.length < field.minSize) {
    return 'Texto precisa ser maior que ${field.min}';
  }
  if (field.notNull && value.isEmpty) {
    return 'Texto não pode ser nulo';
  }
  switch (type) {
    case FieldType.ftEmail:
      return !validateEmail(value) ? 'Enter valid email' : null;
    case FieldType.ftPassword:
      return !isValidPassword(value)
          ? 'Invalid password example: ${Validate.passwordExample} '
          : null;
    case FieldType.ftDouble:
      return !minBmax(field, double.parse(value.replaceAll(',', '.')))
          ? 'Valor fora do range'
          : null;
    case FieldType.ftPasswordConfirm:
      if (match == null) return "match field dont defined.";
      return !isMatchPassoword(value, match.controller.text) ? "Password doesn't match." : null;
    case FieldType.ftCpf:
      return CPFValidator.isValid(value) ? null : 'CPF inválido.';
    case FieldType.ftCnpj:
      return CNPJValidator.isValid(value) ? null : 'CNPJ inválido.';
    case FieldType.ftCpfCnpj:
      final res = length > 14 ? CNPJValidator.isValid(value) : CPFValidator.isValid(value);
      return res
          ? null
          : length > 14
          ? 'CNPJ inválido.'
          : 'CPF inválido.';
    default:
      return null;
  }
}
