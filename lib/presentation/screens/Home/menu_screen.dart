import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/screens/myProperties/my_properties_screen.dart';

import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class MenuScreen extends StatefulWidget {
  final LatLng? currentPosition;
  const MenuScreen({Key? key, this.currentPosition}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late String userType = '';
  late String userName = '';

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('User').doc(uid).get();
      setState(() {
        userType = snapshot.data()!["userType"];
        userName = snapshot.data()!["firstName"];
      });
    } catch (e) {
      print("Error getting user info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              _buildMyProfile(context),
              if (userType == "Tenant") ...[_buildMyPreferences(context)],
              if (userType == "Owner") ...[
                _buildMyProperties(context),
              ],
              _buildLogoutButton(context),
            ],
          ),
        ),
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
          onTapBack(context);
        },
      ),
      title: AppbarTitle(
        text: "Mis propiedades",
        margin: EdgeInsets.only(left: 19.h),
      ),
      styleType: Style.bgOutline,
    );
  }

  void onTapBack(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainScreen);
  }

  Widget _buildMyProfile(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(11, 14, 11, 13),
      decoration: AppDecoration.outlineWhiteA,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgPerfil1,
            height: 50,
            width: 50,
            alignment: Alignment.center,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: restyTextTheme.labelLarge,
              ),
              Text(
                "Mi perfil",
                style: CustomTextStyles.bodySmallWhiteA700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyPreferences(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(12, 14, 12, 13),
      decoration: AppDecoration.outlineWhiteA,
      child: Text(
        "Mis preferencias",
        style: CustomTextStyles.bodySmallWhiteA700,
      ),
    );
  }

  Widget _buildMyProperties(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _goToMyProperties(context);
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.fromLTRB(11, 14, 11, 13),
        decoration: AppDecoration.outlineWhiteA,
        child: Text(
          "Mis propiedades",
          style: CustomTextStyles.bodySmallWhiteA700,
        ),
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
        padding: EdgeInsets.fromLTRB(11, 14, 11, 13),
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
          context, AppRoutes.loginScreen, (route) => false);
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  void _goToMyProperties(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyPropertiesScreen(currentPosition: widget.currentPosition)));
  }

  void _goToUploadRoom(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPropertiesScreen(currentPosition: widget.currentPosition)));
  }
}
