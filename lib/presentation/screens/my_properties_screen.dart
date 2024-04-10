import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_leading_iconbutton.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_title.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({Key? key}) : super(key: key);

  @override
  _MyPropertiesScreenState createState() =>
      _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  late String userType = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        appBar: _buildAppBar(context),
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
        text: "Mi cuenta",
        margin: EdgeInsets.only(left: 19.h),
      ),
      styleType: Style.bgOutline,
    );
  }

  onTapTelevision(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.menuScreen);
  }
}
