import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';

import '../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../widgets/app_bar/appbar_title.dart';
import '../widgets/app_bar/custom_app_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() =>
      _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late String userType = 'Owner';

  @override
  void initState() {
    super.initState();
    getUid();
  }

  Future<void> getUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('User').doc(uid).get();
      setState(() {
        userType = snapshot.data()!["userType"];
      });
    } catch (e) {
      print("Error getting user type: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.lightBlue900,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildAppBar(context),
              _buildMyProfile(context),
              if (userType == "Tenant") ...[
                _buildMyPreferences(context)
              ],
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
  Widget _buildMyProfile(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(11, 14, 11, 13),
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
  ));
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

  void _goToMyProperties(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.myPropertiesScreen);
  }

  void _goToUploadRoom(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.myPropertiesScreen);
  }
}