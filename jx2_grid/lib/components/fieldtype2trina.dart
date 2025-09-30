import 'package:jx_data/components/models/jx_field.dart';
import 'package:trina_grid/trina_grid.dart';

TrinaColumnType type2Trina(
  FieldType type, {
  String? moneyFormat,
  String? countryLocale,
  int? decimalsDigits,
  String? format,
}) {
  switch (type) {
    case FieldType.ftInteger:
      return TrinaColumnType.number(locale: countryLocale ?? "pt_BR");
    case FieldType.ftDate:
      return TrinaColumnType.date(format: format ?? "dd-MM-yyyy");
    case FieldType.ftDateTime:
      return TrinaColumnType.date(format: format ?? "dd-MM-yyyy HH:mm");
    case FieldType.ftDouble:
    case FieldType.ftMoney:
      return TrinaColumnType.currency(
        format: moneyFormat ?? (format ?? formatDecimals(decimalsDigits ?? 2)),
        locale: countryLocale ?? "pt_BR",
        decimalDigits: decimalsDigits ?? 2,
      );
    case FieldType.ftTelefone:
      return TrinaColumnType.text();
    case FieldType.ftCep:
      return TrinaColumnType.text();

    default:
      return TrinaColumnType.text();
  }
}

String formatDecimals(int dec) {
  String fmt = "#,#0.";
  for (var i = 0; i < dec; i++) {
    fmt += "0";
  }
  return fmt;
}
