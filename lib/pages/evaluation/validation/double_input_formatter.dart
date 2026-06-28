import 'package:flutter/services.dart';

class DoubleInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // permite vazio
    if (text.isEmpty) return newValue;

    // permite só números, vírgula e ponto
    if (!RegExp(r'^[0-9.,]*$').hasMatch(text)) {
      return oldValue;
    }

    // só 1 separador no total
    final hasMoreThanOneSeparator = RegExp(r'[.,]').allMatches(text).length > 1;

    if (hasMoreThanOneSeparator) {
      return oldValue;
    }

    return newValue;
  }
}
