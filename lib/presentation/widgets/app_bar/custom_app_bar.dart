import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.height,
    this.styleType,
    this.leadingWidth,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
  }) : super(
          key: key,
        );

  final double? height;

  final Style? styleType;

  final double? leadingWidth;

  final Widget? leading;

  final Widget? title;

  final bool? centerTitle;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height ?? 81.v,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? 81.v,
      );
  _getStyle() {
    switch (styleType) {
      case Style.bgOutline_1:
        return Container(
          height: 81.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.lightBlue900,
            border: Border(
              bottom: BorderSide(
                color: appTheme.black900,
                width: 1.h,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withOpacity(0.25),
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),
        );
      case Style.bgOutline:
        return Container(
          height: 81.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.lightBlue900,
            border: Border(
              bottom: BorderSide(
                color: appTheme.whiteA700,
                width: 1.h,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: appTheme.black900.withOpacity(0.25),
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),
        );
      default:
        return null;
    }
  }
}

enum Style {
  bgOutline_1,
  bgOutline,
}
