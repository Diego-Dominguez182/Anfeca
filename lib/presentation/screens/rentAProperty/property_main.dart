import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:resty_app/routes/app_routes.dart';

class PropertyMainScreen extends StatefulWidget {
  final String? idProperty;

  const PropertyMainScreen({Key? key, this.idProperty}) : super(key: key);

  @override
  _PropertyMainScreen createState() => _PropertyMainScreen();
}

class _PropertyMainScreen extends State<PropertyMainScreen> {

  String? address;
  String? description;
  @override
  void initState() {
    getPropertyData(widget.idProperty);
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
            _buildImageRoom(context),
            SizedBox(height: screenHeight * .70),
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
      rightText: "Rentar",
      showBoxShadow: false,
      onTapLeftText: () {
        Navigator.pushNamed(context, AppRoutes.mainScreen);
      },
    );
  }

 void getPropertyData(String? idProperty) async {
    FirebaseFirestore.instance.collection('Property').doc(idProperty).get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        address = data['address'];
      description = data['description'];
      bool isRented = data['isRented'];
      double latitude = data['latitude'];
      double longitude = data['longitude'];
      int numOfBathrooms = data['numOfBathrooms'];
      int numOfBeds = data['numOfBeds'];
      int numOfRooms = data['numOfRooms'];
      int numOfTenants = data['numOfTenants'];
      int price = data['price'];
      List propertyPhotos = data['propertyPhotos'];
      String propertyType = data['propertyType'];
      List services = data['services'];
      String title = data['title'];
      String userId = data['userId'];
      String withRoomie = data['withRoomie'];
        setState(() {
        });
      } else {
        print('No existe un documento con el ID proporcionado');
      }
    }).catchError((error) {
      print('Error al obtener datos: $error');
    });
  }
Widget _buildMessage(BuildContext context) {
   
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: address != null
        ? Text(
            "$address",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        : Center(
            child: CircularProgressIndicator(), 
          ),
  );
}



  Widget _buildImageRoom(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: address != null
        ? Text(
            "$description",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        : Center(
            child: CircularProgressIndicator(), 
          ),
  );
  }
}



