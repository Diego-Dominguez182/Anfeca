import 'package:flutter/material.dart';
import 'package:SecuriSpace/core/app_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.height,
    this.styleType,
    this.leadingWidth,
    this.leading,
    this.title,
    this.leftText,
    this.rightText,
    this.centerTitle,
    this.actions,
    this.backgroundColor,
    this.showBoxShadow = true,
    this.onTapLeftText,
    this.onTapRigthText,
  }) : super(key: key);

  final double? height;
  final Color? backgroundColor;
  final Style? styleType;
  final double? leadingWidth;
  final Widget? leading;
  final Widget? title;
  final String? leftText;
  final String? rightText;
  final bool? centerTitle;
  final List<Widget>? actions;
  final bool showBoxShadow;
  final VoidCallback? onTapLeftText; 
  final VoidCallback? onTapRigthText; 

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

  Widget? _getStyle() {
    switch (styleType) {
      case Style.bgOutline_1:
        return _buildContainer(
          color: backgroundColor,
          borderSideColor: appTheme.black900,
        );
      case Style.bgOutline:
        return _buildContainer(
          color: backgroundColor,
          borderSideColor: appTheme.whiteA700,
        );
      default:
        return _buildContainer(
          color: backgroundColor,
          borderSideColor: null,
        );
    }
  }

Widget _buildContainer({Color? color, Color? borderSideColor}) {
  return GestureDetector(
    onTap: onTapLeftText, 
    child: Container(
      height: 81.v,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: color ?? appTheme.lightBlue900,
        border: Border(
          bottom: BorderSide(
            color: borderSideColor ?? Colors.transparent,
            width: 1.h,
          ),
        ),
        boxShadow: showBoxShadow
            ? [
                BoxShadow(
                  color: appTheme.black900.withOpacity(0.25),
                  spreadRadius: 2.h,
                  blurRadius: 2.h,
                  offset: Offset(
                    0,
                    4,
                  ),
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                leftText ?? '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Visibility(
            visible: rightText != null,
            child: GestureDetector(
              onTap: onTapRigthText,
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: appTheme.lightBlue900,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    rightText ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}

enum Style {
  bgOutline_1,
  bgOutline,
}
