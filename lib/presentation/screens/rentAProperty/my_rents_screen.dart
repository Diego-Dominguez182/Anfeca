import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:resty_app/presentation/screens/Home/main_screen.dart' show Property; 
import 'package:resty_app/core/app_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_leading_iconbutton.dart';
import 'package:resty_app/presentation/widgets/app_bar/appbar_title.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:resty_app/presentation/widgets/main_item_widget.dart';

class MyRentsScreen extends StatefulWidget {
  final LatLng? currentPosition;
  const MyRentsScreen({Key? key, this.currentPosition}) : super(key: key);

  @override
  _MyRentsScreenState createState() => _MyRentsScreenState();
}

class _MyRentsScreenState extends State<MyRentsScreen> {
  late Future<List<Property>>? propertiesFuture;

  @override
  void initState() {
    super.initState();
    propertiesFuture = getPropertiesFromFirebase();
  }


Future<List<Property>> getPropertiesFromFirebase() async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      List<Property> loadedProperties = [];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Property')
          .where('isRentedBy', isEqualTo: currentUser.uid) 
          .get();
      
      for (var doc in querySnapshot.docs) {
        try {
          Property property = Property.fromDocumentSnapshot(doc);
            loadedProperties.add(property);
        } catch (e) {
          print('Error al procesar documento: $e');
        }
      }

      QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('Property')
          .where('isRentedBy', arrayContains: currentUser.uid) 
          .get();

      for (var doc in querySnapshot2.docs) {
        try {
          Property property = Property.fromDocumentSnapshot(doc);
            loadedProperties.add(property);

        } catch (e) {
          print('Error al procesar documento: $e');
        }
      }

      return loadedProperties;
    } else {
      print('Usuario no autenticado');
      return [];
    }
  } catch (e) {
    print('Error al obtener propiedades: $e');
    return [];
  }
}


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
                _buildRooms(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRooms(BuildContext context) {
    return FutureBuilder<List<Property>>(
      future: propertiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return _buildMain(context, snapshot.data ?? []);
          }
        }
      },
    );
  }

  Widget _buildMain(BuildContext context, List<Property> properties) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 29,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 250,
          crossAxisCount: 1,
          mainAxisSpacing: 37,
          crossAxisSpacing: 37,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return MainItemWidget(
            idProperty: properties[index].idProperty,
            address: properties[index].address,
            price: properties[index].price,
            propertyPhotos: properties[index].photos,
            withRoomies: properties[index].withRoomies,
            numOfRooms: properties[index].numOfRooms,
            description: properties[index].description,
            services: properties[index].services,
            numOfBathrooms: properties[index].numOfBathrooms,
            numOfBeds: properties[index].numOfBeds,
            numOfTenants: properties[index].numOfTenants,
            title: properties[index].title,
            isOnMyProperties: "Yess",
            longitude: properties[index].longitude,
            latitude: properties[index].latitude
          );
        },
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
        text: "Mis rentas",
        margin: EdgeInsets.only(left: 19),
      ),
      styleType: Style.bgOutline,
    );
  }

  void onTapBack(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.menuScreen);
  }
}

  

class PropertyMyRents {
  final String idProperty;
  final String address;
  final double price;
  final List<String> photos;
  final String withRoomies;
  final int numOfRooms;
  final bool canBeShared;
  final bool isRented;
  final String description;
  final List<String> services;
  final int numOfBathrooms;
  final int numOfBeds;
  final int numOfTenants;
  final String title;
  final dynamic isRentedBy; 

  PropertyMyRents({
    required this.idProperty,
    required this.address,
    required this.price,
    required this.photos,
    required this.withRoomies,
    required this.numOfRooms,
    required this.canBeShared,
    required this.isRented,
    required this.description,
    required this.services,
    required this.numOfBathrooms,
    required this.numOfBeds,
    required this.numOfTenants,
    required this.title,
    required this.isRentedBy, 
  });

  factory PropertyMyRents.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null || data.isEmpty) {
      throw Exception("Documento vacío o incompleto");
    }

    String idProperty = snapshot.id;
    String address = data['address'] ?? '';
    double price = (data['price'] ?? 0).toDouble();
    List<String> propertyPhotos = data['photos'] != null ? List<String>.from(data['photos']) : [];
    String withRoomies = data['withRoomies'] ?? '';
    int numOfRooms = data['numOfRooms'] ?? 0;
    bool canBeShared = data['canBeShared'] ?? false;
    bool isRented = data['isRented'] ?? false;
    String description = data['description'] ?? '';
    List<String> services = data['services'] != null ? List<String>.from(data['services']) : [];
    int numOfBathrooms = data['numOfBathrooms'] ?? 0;
    int numOfBeds = data['numOfBeds'] ?? 0;
    int numOfTenants = data['numOfTenants'] ?? 0;
    String title = data['title'] ?? '';
    dynamic isRentedBy = data['isRentedBy']; 

    return PropertyMyRents(
      idProperty: idProperty,
      address: address,
      price: price,
      photos: propertyPhotos,
      withRoomies: withRoomies,
      numOfRooms: numOfRooms,
      canBeShared: canBeShared,
      isRented: isRented,
      description: description,
      services: services,
      numOfBathrooms: numOfBathrooms,
      numOfBeds: numOfBeds,
      numOfTenants: numOfTenants,
      title: title,
      isRentedBy: isRentedBy, 
    );
  }

}

