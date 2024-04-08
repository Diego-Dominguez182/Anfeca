import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  }) : super(key: key);

  final Alignment? alignment;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }
Widget get iconButtonWidget => SizedBox(
  height: height ?? 0,
  width: width ?? 8,
  child: IconButton(
    padding: EdgeInsets.zero,
    icon: Container(
      height: height ?? 0,
      width: width ?? 0,
      padding: padding ?? EdgeInsets.zero,
      decoration: decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(23.h),
            border: Border.all(
              color: theme.colorScheme.onError,
              width: 1.h,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary,
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(
                  0,
                  -2.h,
                ),
              ),
            ],
          ),
      child: child,
    ),
    onPressed: onTap,
  ),
);
}

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlinePrimaryContainer => BoxDecoration(
    borderRadius: BorderRadius.circular(23.h),
    border: Border.all(
      color: theme.colorScheme.primaryContainer.withOpacity(1),
      width: 1.h,
    ),
    boxShadow: [
      BoxShadow(
        color: theme.colorScheme.primary,
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(
          4,
          1,
        ),
      ),
    ],
  );

}