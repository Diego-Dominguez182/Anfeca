import 'package:SecuriSpace/presentation/widgets/custom_button_icon.dart';
import 'package:flutter/material.dart';
import 'package:SecuriSpace/core/app_export.dart';

// ignore: must_be_immutable
class AppbarLeadingIconbutton extends StatelessWidget {
  AppbarLeadingIconbutton({
    Key? key,
    this.imagePath,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomIconButton(
          height: 50.adaptSize,
          width: 50.adaptSize,
          child: Align(
            alignment: Alignment.center,
              child: Align (
                alignment: Alignment(-.4,0),
                child: CustomImageView(
                  imagePath: ImageConstant.imgTelevision,
          ),
        ),
      ),
    )));
  }
}
