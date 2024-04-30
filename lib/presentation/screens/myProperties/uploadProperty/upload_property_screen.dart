import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/screens/myProperties/my_properties_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/settings_house_screen.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

final currentUser = FirebaseAuth.instance.currentUser;
final userId = currentUser?.uid;


class UploadRoomScreen extends StatefulWidget {
  final LatLng? currentPosition;
  const UploadRoomScreen({Key? key, this.currentPosition}) : super(key: key);

  @override
  _UploadRoomScreenState createState() => _UploadRoomScreenState();
}

class _UploadRoomScreenState extends State<UploadRoomScreen> {
  String? _selectedProperty = null;
  String? existingPropertyId;

  @override
  void initState() {
    super.initState();
    verificarPropiedadExistente();
  }

  void verificarPropiedadExistente() async {
    if (userId != null) {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('Property')
              .where('userId', isEqualTo: userId)
              .get();



      for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        Map<String, dynamic>? data = doc.data();
        if (!(data!.containsKey('latitude') &&
            data.containsKey('longitude') &&
            data.containsKey('numOfBathrooms') &&
            data.containsKey('numOfBeds') &&
            data.containsKey('numOfRooms') &&
            data.containsKey('numOfTenants') &&
            data.containsKey('propertyPhotos') &&
            data.containsKey('propertyType') &&
            data.containsKey('services') &&
            data.containsKey('description') &&
            data.containsKey('title') &&
            data.containsKey('price') &&
            data.containsKey('withRoomie') &&
            data.containsKey('isRented'))) {
            existingPropertyId = doc.id;
          break;
        }
      }


    }
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
            _buildHouseButton(context),
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
        Navigator.push(
          context, MaterialPageRoute(
            builder:(context) => MyPropertiesScreen(currentPosition: widget.currentPosition) ));
      },
      onTapRigthText: () {
        if (_selectedProperty != null) {
          if (existingPropertyId != null) {
            actualizarPropiedad(
                existingPropertyId!, userId!, _selectedProperty!);
          } else {
            agregarPropiedad(userId!, _selectedProperty!);
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Alerta"),
                content: Text("Por favor, selecciona una propiedad."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Aceptar"),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "¿Qué tipo de propiedad es?",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHouseButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedProperty = 'Casa completa';
          });
        },
        child: Container(
          height: 150,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.blue,
            border: _selectedProperty == 'Casa completa'
                ? Border.all(color: Colors.black, width: 2)
                : Border.all(color: Colors.black.withOpacity(0.05), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.house, size: 70, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Casa completa",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Propiedad completa para alquilar",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedProperty = 'Cuarto individual';
          });
        },
        child: Container(
          height: 150,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.green,
            border: _selectedProperty == 'Cuarto individual'
                ? Border.all(color: Colors.black, width: 2)
                : Border.all(color: Colors.black.withOpacity(0.05), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hotel, size: 70, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Cuarto individual",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cuarto individual para alquilar",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> agregarPropiedad(String userId, String propertyType) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('Property').add({
      'userId': userId,
      'propertyType': propertyType,
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingHouseScreen(idProperty: docRef.id, currentPosition: widget.currentPosition )));
  }

  void actualizarPropiedad(
      String propertyId, String userId, String propertyType) {
    FirebaseFirestore.instance.collection('Property').doc(propertyId).update({
      'userId': userId,
      'propertyType': propertyType,
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            SettingHouseScreen(idProperty: existingPropertyId, currentPosition: widget.currentPosition)));
  }
}
