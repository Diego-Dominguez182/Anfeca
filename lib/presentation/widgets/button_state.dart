// button_state.dart
import 'package:flutter/material.dart';

class ButtonState extends ChangeNotifier {
  String _resetPasswordPressed = "Register";

  String get resetPasswordPressed => _resetPasswordPressed;

  void setResetPasswordPressed(String value) {
    _resetPasswordPressed = value;
    notifyListeners();
  }
}
