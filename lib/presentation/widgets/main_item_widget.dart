import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resty_app/presentation/screens/rentAProperty/property_main.dart';

class MainItemWidget extends StatefulWidget {
  final String idProperty;
  final String address;
  final double price;
  final List<String> propertyPhotos;
  final List<String> withRoomies;
  final int numOfRooms;
  final String description;
  final List<String> services;
  final int numOfBathrooms;
  final int numOfBeds;
  final int numOfTenants;
  final String title;
  final String isOnMyProperties;
  final List<String>? isRentedBy;
  final double latitude; 
  final double longitude;
  MainItemWidget({
    Key? key,
    required this.idProperty,
    required this.address,
    required this.price,
    required this.propertyPhotos,
    required this.withRoomies,
    required this.numOfRooms,
    required this.description,
    required this.services,
    required this.numOfBathrooms,
    required this.numOfBeds,
    required this.numOfTenants,
    required this.title,
    required this.isOnMyProperties,
    this.isRentedBy,
    required this.latitude,
    required this.longitude
  }) : super(key: key);

  @override
  _MainItemWidgetState createState() => _MainItemWidgetState();
}

class _MainItemWidgetState extends State<MainItemWidget> {
  double _matchPercentage = 0.0; 
  late List<String> currentUserPreferences;
  late List<String> rentingUserPreferences;


  @override
  void initState() {
    super.initState();
    getPropertyInfo();
  }

Future<void> getPropertyInfo() async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('User')
        .doc(user?.uid)
        .get();
    if (snapshot.exists) {
      List<String> preferences = [];
if (snapshot.data() != null && snapshot.data()!['preferences'] != null) {
    Map<String, dynamic> preferencesMap = snapshot.data()!['preferences'];
    preferences = preferencesMap.values.map((value) => value.toString()).toList();
}
      setState(() {
        currentUserPreferences = preferences;
      });
    }
  } catch (e) {
    print("Error getting user info: $e");
  }
    try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('User')
        .doc(widget.isRentedBy?.first)
        .get();
    if (snapshot.exists) {
      List<String> preferences = [];
if (snapshot.data() != null && snapshot.data()!['preferences'] != null) {
    Map<String, dynamic> preferencesMap = snapshot.data()!['preferences'];
    preferences = preferencesMap.values.map((value) => value.toString()).toList();
}
      setState(() {
        rentingUserPreferences = preferences;
        calculatePreferenceMatch();
      });
    }
  } catch (e) {
    print("Error getting user info: $e");
  }
}

 Future<void> calculatePreferenceMatch() async {
  int numOfMatches = 0;
  for (int i = 0; i < currentUserPreferences.length; i++) {
    String currentUserPreference = currentUserPreferences[i];
    String rentingUserPreference = rentingUserPreferences[i];
    if (currentUserPreference == rentingUserPreference) {
      numOfMatches++;
    }
  }
  setState(() {
    _matchPercentage = (numOfMatches / currentUserPreferences.length) * 100;
  });
}



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PropertyMainScreen(
                    idProperty: widget.idProperty,
                    propertyPhotos: widget.propertyPhotos,
                    description: widget.description,
                    price: widget.price,
                    address: widget.address,
                    services: widget.services,
                    numOfBathrooms: widget.numOfBathrooms,
                    numOfBeds: widget.numOfBeds,
                    numOfTenants: widget.numOfTenants,
                    numOfRooms: widget.numOfRooms,
                    withRoomies: widget.withRoomies,
                    title: widget.title,
                    isOnMyProperties: widget.isOnMyProperties,
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSlider(),
                  SizedBox(height: 5),
                  _buildText(widget.address, 13, FontWeight.bold),
                  _buildText(_buildRoomieMessageText(), 10, FontWeight.bold),
                  SizedBox(height: 2),
                  _buildText(_buildPriceText(), 12, FontWeight.bold),
                ],
              ),
            ),
          );
  }

  Widget _buildText(String text, double fontSize, FontWeight fontWeight) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.black,
          fontFamily: 'volkorn',
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Expanded(
      child: PageView.builder(
        itemCount: widget.propertyPhotos.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: widget.propertyPhotos[index],
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }

  String _buildRoomieMessageText() {
    if (widget.numOfRooms > 0) {
      if (widget.withRoomies.isEmpty) {
        return "No tiene roomie";
      } else {
        List<String> roomies = widget.withRoomies;
       if (roomies.length == 1) {
          return 'Será compartido con: ${roomies[0]} - Coinciden un : ${_matchPercentage.toStringAsFixed(2)}%';
        } else if (roomies.length == 2) {
          return 'Será compartido con: ${roomies[0]} y ${roomies[1]} - Coinciden un : ${_matchPercentage.toStringAsFixed(2)}%';
        } else {
          return 'Será compartido con: ${roomies[0]}, ${roomies[1]} Coinciden un : ${_matchPercentage.toStringAsFixed(2)}%';
        }
      }
    } else {
      return "No tiene roomie";
    }
  }

  String _buildPriceText() {
    String formattedPrice =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(widget.price);
    return formattedPrice;
  }

}
