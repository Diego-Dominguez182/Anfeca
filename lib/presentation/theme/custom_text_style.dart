import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CustomTextStyles {
  static get bodySmallOnPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(0.8),
      );
  static get bodySmall99000000 => theme.textTheme.bodySmall!.copyWith(
        color: Color(0X99000000),
      );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
      );
  static get bodySmallWhiteA700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.whiteA700.withOpacity(0.8),
      );
  static get labelLarge99000000 => theme.textTheme.labelLarge!.copyWith(
        color: Color(0X99000000),
      );
  static get labelLargeff000000 => theme.textTheme.labelLarge!.copyWith(
        color: Color(0XFF000000),
      );
  static get titleLargeBlack900 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
        fontWeight: FontWeight.w600,
      );
}

const restyTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  ),
  displayMedium: TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  ),
  displaySmall: TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  ),

  headlineLarge: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  ),
  headlineMedium: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  ),
  headlineSmall: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  ),

  
  titleLarge: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  ),
  titleSmall: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  ),

  bodyLarge: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.normal,
  ),
  bodyMedium: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  ),
  bodySmall: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
  ),


  labelLarge: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  ),
  labelMedium: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  ),
  labelSmall: TextStyle(
    fontSize: 8.0,
    fontWeight: FontWeight.bold,
  ),

  
);