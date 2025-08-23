String fieldToDate(DateTime field) {
  return "${field.year.toString().padLeft(4, '0')}-${field.month.toString().padLeft(2, '0')}-${field.day.toString().padLeft(2, '0')}";
}
