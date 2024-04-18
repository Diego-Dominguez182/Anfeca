import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

final currentUser = FirebaseAuth.instance.currentUser;
final userId = currentUser?.uid;

class PropertyDescriptionScreen extends StatefulWidget {
  const PropertyDescriptionScreen({Key? key, String? idProperty})
      : super(key: key);

  @override
  _PropertyDescriptionScreen createState() => _PropertyDescriptionScreen();
}

class _PropertyDescriptionScreen extends State<PropertyDescriptionScreen> {
  String? existingPropertyId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          children: [
            SizedBox(height: 20),
            _buildMessage(context),
            SizedBox(height: 20),
            _buildRoomButton(context),
            SizedBox(height: screenHeight * .38),
            _buildAppBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: Colors.white,
      leadingWidth: 48,
      leftText: "Atrás",
      rightText: "Siguiente",
      showBoxShadow: false,
      onTapLeftText: () {
        Navigator.pushNamed(context, AppRoutes.myPropertiesScreen);
      },
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Añade una descripción corta",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRoomButton(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: GestureDetector(
            child: Container(
          height: 150,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        )));
  }


}
