(dynamic, bool) tryDouble(dynamic v) {
  final value = double.tryParse("$v");
  //log("valor: $value");
  if (value != null) {
    return (value, true);
  }
  return (v, false);
}
