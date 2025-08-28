String fieldToDate(DateTime field) {
  return "${field.year.toString().padLeft(4, '0')}-${field.month.toString().padLeft(2, '0')}-${field.day.toString().padLeft(2, '0')}";
}

String transformName(String s) {
  if (s.isEmpty) return s;
  return s
      .split('_')
      .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
      .join(' ');
}
