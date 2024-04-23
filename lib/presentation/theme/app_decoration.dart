import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';

class AppDecoration {
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );

      
  static BoxDecoration get outlineBlack => BoxDecoration(
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
      );
  static BoxDecoration get outlineBlack900 => BoxDecoration(
        color: appTheme.blueGray100,
        border: Border.all(
          color: appTheme.black900,
          width: 1.h,
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
      );
  static BoxDecoration get outlineBlack9001 => BoxDecoration(
        color: appTheme.blueGray100,
        border: Border.all(
          color: appTheme.black900,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineWhiteA => BoxDecoration(
        color: appTheme.lightBlue900,
        border: Border(
          bottom: BorderSide(
            color: appTheme.whiteA700,
            width: 1.h,
          ),
        ),
      );
}

class BorderRadiusStyle {
  static BorderRadius get customBorderBL20 => BorderRadius.vertical(
        bottom: Radius.circular(20.h),
      );

  static BorderRadius get roundedBorder23 => BorderRadius.circular(
        23.h,
      );
}

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

