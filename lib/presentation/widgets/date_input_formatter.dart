import 'package:flutter/services.dart';

class MMYYInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var selectionIndex = newValue.selection.end;

    if (text.length > 5) {
      return oldValue;
    }

    var buffer = StringBuffer();

    if (text.length >= 3) {
      buffer.write(text.substring(0, 2) + '/');
      if (newValue.selection.end >= 2) selectionIndex++;
    } else {
      buffer.write(text);
    }

    if (text.length >= 3) {
      buffer.write(text.substring(2, text.length));
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
