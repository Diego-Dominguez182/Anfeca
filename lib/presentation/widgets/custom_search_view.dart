import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CustomSearchView extends StatelessWidget {
  const CustomSearchView({
    Key? key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = true,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
  }) : super(
          key: key,
        );

  final Alignment? alignment;
  final double? width;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: searchViewWidget(context),
          )
        : searchViewWidget(context);
  }

  Widget searchViewWidget(BuildContext context) => SizedBox(
        width: width ?? double.maxFinite,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          autofocus: autofocus!,
          style: textStyle,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
          onChanged: (String value) {
            onChanged?.call(value);
          },
        ),
      );

  InputDecoration get decoration => _buildInputDecoration();

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: hintStyle,
      prefixIconConstraints: prefixConstraints ??
          BoxConstraints(
            maxHeight: 47.v,
          ),
      suffixIcon: suffix ??
          Padding(
            padding: EdgeInsets.only(
              right: 15.h,
            ),
            child: IconButton(
              onPressed: () => controller!.clear(),
              icon: Icon(
                Icons.clear,
                color: Colors.grey.shade600,
              ),
            ),
          ),
      suffixIconConstraints: suffixConstraints ??
          BoxConstraints(
            maxHeight: 47.v,
          ),
      isDense: true,
      contentPadding: contentPadding,
      fillColor: fillColor ?? appTheme.blueGray100,
      filled: filled,
      border: _buildInputBorder(),
      enabledBorder: _buildInputBorder(),
      focusedBorder: _buildInputBorder(),
    );
  }

  InputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.h),
      borderSide: BorderSide(
        color: appTheme.black900,
        width: 1,
      ),
    );
  }
}
