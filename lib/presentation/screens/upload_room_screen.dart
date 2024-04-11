import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

class UploadRoomScreen extends StatelessWidget {
  const UploadRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * .85),
              _buildAppBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: Colors.white,
      leadingWidth: 48.h, 
      leftText: "Atrás",
      rightText: "Siguiente",
      showBoxShadow: false,
      onTapLeftText: () {
        Navigator.pushNamed(context, AppRoutes.myPropertiesScreen);
      },
      onTapRigthText: (){
        Navigator.pushNamed(context, AppRoutes.loginScreen);
      },
    );
  }
}


  void onTapTelevision(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.myPropertiesScreen);
  }
