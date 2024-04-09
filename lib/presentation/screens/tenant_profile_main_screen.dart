import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_leading_iconbutton.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_title.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

class TenantProfileMainScreen extends StatelessWidget {
  const TenantProfileMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.lightBlue900,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildMyProfile(context),
              _buildMyPreferences(context),
              _buildMyProperties(context),
              SizedBox(height: 5.v),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 51.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgTelevision,
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
        text: "Mi cuenta",
        margin: EdgeInsets.only(left: 19.h),
      ),
      styleType: Style.bgOutline,
    );
  }

  Widget _buildMyProfile(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(11.h, 14.v, 11.h, 13.v),
      decoration: AppDecoration.outlineWhiteA,
      child: Text(
        "Mi perfil",
        style: CustomTextStyles.bodySmallWhiteA700,
      ),
    );
  }

  Widget _buildMyPreferences(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(12.h, 14.v, 12.h, 13.v),
      decoration: AppDecoration.outlineWhiteA,
      child: Text(
        "Mis preferencias",
        style: CustomTextStyles.bodySmallWhiteA700,
      ),
    );
  }

  Widget _buildMyProperties(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(11.h, 14.v, 11.h, 13.v),
      decoration: AppDecoration.outlineWhiteA,
      child: Text(
        "Mis propiedades",
        style: CustomTextStyles.bodySmallWhiteA700,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _signOut(context);
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.fromLTRB(11.h, 14.v, 11.h, 13.v),
        decoration: AppDecoration.outlineWhiteA,
        child: Text(
          "Cerrar sesión",
          style: CustomTextStyles.bodySmallWhiteA700,
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.mainScreen, (route) => false);
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  onTapTelevision(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.principalScreen);
  }
}
