import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'; 
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/property_price_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/upload_property_photos.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

final currentUser = FirebaseAuth.instance.currentUser;
final userId = currentUser?.uid;

class PropertyDescriptionScreen extends StatefulWidget {
  final String? idProperty;
  final LatLng? currentPosition;
  const PropertyDescriptionScreen({Key? key, this.idProperty, this.currentPosition}) : super(key: key);

  @override
  _PropertyDescriptionScreen createState() => _PropertyDescriptionScreen();
}


class _PropertyDescriptionScreen extends State<PropertyDescriptionScreen> {
  String? existingPropertyId;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? title;
  String? description;

  @override
  void initState() {
    super.initState();
    getPropertyInfo();
  }

  Future<void> getPropertyInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Property')
          .doc(widget.idProperty)
          .get();
      setState(() {
        title = snapshot.data()?["title"];
        description = snapshot.data()?["description"];
      });
    } catch (e) {
      print("Error getting user info: $e");
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
            _buildRoomButton(context),
            SizedBox(height: screenHeight * .33),
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
            builder: (context) => UploadPropertyScreen(idProperty: widget.idProperty, 
            currentPosition: widget.currentPosition)));
      },
      onTapRigthText: () {
        _saveProperty();
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => PropertyPriceScreen(idProperty: widget.idProperty,
            currentPosition: widget.currentPosition)));

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Título:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: title,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),
              maxLength: 50,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Descripción:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: description,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              maxLength: 200,
            ),
          ),
        ],
      ),
    );
  }

void _saveProperty() {
  String title = _titleController.text;
  String description = _descriptionController.text;

  if (title.isNotEmpty && description.isNotEmpty) {
    FirebaseFirestore.instance.collection('Property').doc(widget.idProperty).update({
      'title': title,
      'description': description,
    });
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Por favor, completa todos los campos."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
}
