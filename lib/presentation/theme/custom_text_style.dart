import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class CustomTextStyles {
  static get bodySmallOnPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(0.8),
      );
       // Body text style
  static get bodySmall99000000 => theme.textTheme.bodySmall!.copyWith(
        color: Color(0X99000000),
      );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
      );
  static get bodySmallWhiteA700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.whiteA700.withOpacity(0.8),
      );
  // Label text style
  static get labelLarge99000000 => theme.textTheme.labelLarge!.copyWith(
        color: Color(0X99000000),
      );
  static get labelLargeff000000 => theme.textTheme.labelLarge!.copyWith(
        color: Color(0XFF000000),
      );
  // Title text style
  static get titleLargeBlack900 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900.withOpacity(0.8),
        fontWeight: FontWeight.w600,
      );
}

const restyTextTheme = TextTheme(
  //Display text is reserved for short, important text or numerals.
  //They work best on large screens.
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

  //Headline are best-suited for short, high-emphasis text on smaller screens
  //Headline text provided that appropriate line height and letter spacing is also integrated to maintain readability.
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

  //Title are smaller than headline styles, and should be used for medium-emphasis text that remains relatively short.
  //Consider using title styles to divide secondary passages of text or secondary regions of content.
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

  //Body styles are used for longer passages of text in your app.
  //Use typefaces intended for body styles, which are readable at smaller sizes and can be comfortably read in longer passages.

  //For larger type legibility using styles like title, headline, and display, we recommend a line height ratio of 1.2 times the type size
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

  //Label styles are smaller, utilitarian styles,
  //used for things like the text inside components or for very small text in the content body, such as captions.
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