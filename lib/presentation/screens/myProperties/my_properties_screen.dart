import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/upload_property_photos.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/upload_property_screen.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_leading_iconbutton.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_title.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';
import '../../widgets/icon_button_with_text.dart';

class MyPropertiesScreen extends StatefulWidget {
  final LatLng? currentPosition;
  const MyPropertiesScreen({Key? key, this.currentPosition}) : super(key: key);

  @override
  _MyPropertiesScreenState createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {


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
                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadRoomScreen(currentPosition: widget.currentPosition)));
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 48,
      leading: AppbarLeadingIconbutton(
        margin: EdgeInsets.only(
          left: 4,
          top: 12,
          bottom: 22,
        ),
        onTap: () {
          onTapBack(context);
        },
      ),
      title: AppbarTitle(
        text: "Mis propiedades",
        margin: EdgeInsets.only(left: 19),
      ),
      styleType: Style.bgOutline,
    );
  }

  void onTapBack(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.menuScreen);
  }
}
