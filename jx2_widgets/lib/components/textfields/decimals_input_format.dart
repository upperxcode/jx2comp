import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  DecimalInputFormatter({this.decimalRange = 2});

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '0${('0' * decimalRange).padLeft(decimalRange + 1, '.')}');
    }

    String newText = newValue.text.replaceAll('.', '');

    if (newText.length > decimalRange) {
      newText =
          '${newText.substring(0, newText.length - decimalRange)}.${newText.substring(newText.length - decimalRange)}';
    } else {
      newText = '0.${newText.padLeft(decimalRange, '0')}';
    }

    // When deleting, if only the leading "0" and the dot remain, replace with the correct format.
    if (oldValue.text.length > newValue.text.length && newText == '0.') {
      newText = '0${('0' * decimalRange).padLeft(decimalRange + 1, '.')}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
