import 'package:flutter/material.dart';
import '../models/jx_field.dart';

/// Esta função retorna o ícone baseado no tipo do campo
/// essa função só é chamada se o campo não possui um ícone implícito
type2Icon(FieldType type, [Color? color]) {
  const double size = 24;
  color = color ?? Colors.blueAccent;
  late IconData icon;
  switch (type) {
    case FieldType.ftString:
      icon = Icons.label_rounded;
      break;
    case FieldType.ftEmail:
      icon = Icons.email_rounded;
      break;
    case FieldType.ftPassword:
    case FieldType.ftPasswordConfirm:
      icon = Icons.key_rounded;
      break;
    case FieldType.ftDouble:
    case FieldType.ftMoney:
      icon = Icons.monetization_on_rounded;
      break;
    case FieldType.ftInteger:
      icon = Icons.looks_one_rounded;
      break;
    case FieldType.ftBool:
      icon = Icons.check_box_rounded;
      break;
    default:
      icon = Icons.sim_card_alert;
  }
  return Icon(
    icon,
    size: size,
    color: color,
  );
}
