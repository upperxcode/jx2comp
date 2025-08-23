import 'package:flutter/material.dart';

import '../models/jx_field.dart';

/// Esta função retorna o tipo de teclado baseado no tipo do campo

TextInputType type2Keyboard(FieldType type) {
  switch (type) {
    case FieldType.ftInteger:
      return TextInputType.number;
    case FieldType.ftDouble:
    case FieldType.ftMoney:
      return const TextInputType.numberWithOptions(decimal: true);
    case FieldType.ftEmail:
      return TextInputType.emailAddress;
    case FieldType.ftDate:
    case FieldType.ftDateTime:
      return TextInputType.datetime;
    default:
      return TextInputType.text;
  }
}
