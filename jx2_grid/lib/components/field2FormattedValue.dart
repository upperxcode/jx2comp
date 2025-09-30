import 'package:brasil_fields/brasil_fields.dart';
import 'package:jx_data/components/models/jx_field.dart';
import 'package:jx_utils/logs/log.dart';

dynamic field2FormattedValue(JxField field) {
  final v = field.value;

  switch (field.fieldType) {
    case FieldType.ftDouble:
    case FieldType.ftMoney:
      return UtilBrasilFields.obterReal(v);
    case FieldType.ftTelefone:
      return UtilBrasilFields.obterTelefone(v.toString());
    case FieldType.ftCep:
      return UtilBrasilFields.obterCep(v.toString());

    default:
      return v;
  }
}
