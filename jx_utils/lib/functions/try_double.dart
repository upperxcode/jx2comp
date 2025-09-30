(dynamic, bool) tryDouble(dynamic v) {
  final value = double.tryParse("$v");
  //JxLog.info("valor: $value");
  if (value != null) {
    return (value, true);
  }
  return (v, false);
}
