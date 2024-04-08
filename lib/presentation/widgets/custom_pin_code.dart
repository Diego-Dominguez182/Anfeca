import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../core/app_export.dart';

class CustomPinCodeTextField extends StatelessWidget {
  CustomPinCodeTextField({
    Key? key,
    required this.context,
    required this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
  }) : super(key: key);

  final Alignment? alignment;
  final BuildContext context;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Function(String) onChanged;
  final FormFieldValidator<String>? validator;


  @override
Widget build(BuildContext context) {
  return alignment != null
      ? Align(
          alignment: alignment ?? Alignment.center,
          child: pinCodeTextFieldWidget,
        )
      : pinCodeTextFieldWidget;
}

Widget get pinCodeTextFieldWidget => PinCodeTextField(
  appContext: context,
  controller: controller,
  length: 5,
  keyboardType: TextInputType.number,
  textStyle: textStyle,
  hintStyle: hintStyle,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  enableActiveFill: true,
  pinTheme: PinTheme(
    fieldHeight: 40.h,
    fieldWidth: 40.h,
    shape: PinCodeFieldShape.box,
    inactiveColor: theme.colorScheme.primaryContainer.withOpacity(1),
    activeColor: theme.colorScheme.primaryContainer.withOpacity(1),
    inactiveFillColor: appTheme.gray50,
    activeFillColor: Colors.transparent,
    selectedColor: Colors.blue[800],
    selectedFillColor: appTheme.gray50,
  ),
  onChanged: (value) => onChanged(value),
  validator: validator,
);

}
