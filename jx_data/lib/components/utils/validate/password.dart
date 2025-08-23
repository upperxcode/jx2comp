import 'constants.dart';

bool isValidPassword(String value) {
  if (value == Validate.passwordExample) return false;
  final passwordRegExp = RegExp(
      //r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
      r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  return passwordRegExp.hasMatch(value);
}

bool isMatchPassoword(String value1, String value2) {
  if (value1 != value2) {
    return false;
  }
  return true;
}
