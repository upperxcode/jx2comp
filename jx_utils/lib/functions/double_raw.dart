import 'constant.dart';

doubleRawValue(String v) {
  for (int i = 0; i < v.length; i++) {
    final a = v[i];
    if (a == ',' || a == '.') {
      if (a == '.') {
        v = v.replaceAll('.', '');
        v = v.replaceAll(',', '.');
      } else {
        if (countryLocale == "pt_BR") {
          v = v.replaceAll(',', '.');
        } else {
          v = v.replaceAll(',', '');
        }
      }
      break;
    }
  }
  return double.tryParse(v.replaceAll(RegExp(r'[^\d\.]'), '')) ?? 0;
}
