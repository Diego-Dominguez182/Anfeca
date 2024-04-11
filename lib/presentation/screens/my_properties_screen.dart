import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_leading_iconbutton.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_title.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

import '../widgets/icon_button_with_text.dart';

class MyPropertiesScreen extends StatelessWidget {
  const MyPropertiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                _buildAddNewRoom(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewRoom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Expanded(
            child: IconButtonWithText(
              imageName: ImageConstant.propertie,
              text: "Subir nueva propiedad",
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.uploadRoomScreen);
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 48.h,
      leading: AppbarLeadingIconbutton(
        margin: EdgeInsets.only(
          left: 4.h,
          top: 12.v,
          bottom: 22.v,
        ),
        onTap: () {
          onTapTelevision(context);
        },
      ),
      title: AppbarTitle(
        text: "Mis propiedades",
        margin: EdgeInsets.only(left: 19.h),
      ),
      styleType: Style.bgOutline,
    );
  }

  void onTapTelevision(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.menuScreen);
  }
}
