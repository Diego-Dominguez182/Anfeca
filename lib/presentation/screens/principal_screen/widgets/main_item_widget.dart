import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';

// ignore: must_be_immutable
class MainItemWidget extends StatelessWidget {
  const MainItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.v,
      child: CustomImageView(
        imagePath: ImageConstant.imgImage1,
        fit: BoxFit.cover, 
      ),
    );
  }
}