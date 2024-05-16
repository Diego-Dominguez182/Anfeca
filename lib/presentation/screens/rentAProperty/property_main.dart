import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:resty_app/presentation/screens/Home/main_screen_map.dart';
import 'package:resty_app/presentation/screens/myProperties/my_properties_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/upload_property_screen.dart';
import 'package:resty_app/presentation/screens/rentAProperty/confirm_rent_screen.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:resty_app/routes/app_routes.dart';

class PropertyMainScreen extends StatefulWidget {
  final String? idProperty;
  final String? previousPage;
  final LatLng? currentPosition;
  final List<String>? propertyPhotos;
  final String? description;
  final double? price;
  final String? address;
  final List<String>? services;
  final int? numOfBathrooms;
  final int? numOfBeds;
  final int? numOfTenants;
  final int? numOfRooms;
  final List<String>? withRoomies;
  final String? title;
  final String? isOnMyProperties;
  final double latitude;
  final double longitude;

  const PropertyMainScreen({Key? key, 
  this.idProperty, 
  this.previousPage, 
  this.currentPosition,
  this.propertyPhotos,
  this.description,
  this.price,
  this.address,
  this.services,
  this.numOfBathrooms,
  this.numOfBeds,
  this.numOfTenants,
  this.withRoomies,
  this.title,
  this.numOfRooms,
  this.isOnMyProperties,
  required this.latitude,
  required this.longitude,
  }) : super(key: key);

  @override
  _PropertyMainScreen createState() => _PropertyMainScreen();
}

class _PropertyMainScreen extends State<PropertyMainScreen> {
  Completer<GoogleMapController> googleMapController = Completer();

  late String address;
  late String description;
  late List<String> propertyPhotos;
  late double price;
  late List<String> services;
  late int numOfBathrooms;
  late int numOfBeds;
  late int numOfRooms;
  late int numOfTenants;
  late List<String>? withRoomies;
  late String title;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    propertyPhotos = widget.propertyPhotos ?? [];
    description = widget.description ?? '';
    price = widget.price ?? 0.0;
    address = widget.address ?? '';
    services = widget.services ?? [];
    numOfBathrooms = widget.numOfBathrooms ?? 0;
    numOfBeds = widget.numOfBeds ?? 0;
    numOfTenants = widget.numOfTenants ?? 0;
    numOfRooms = widget.numOfRooms ?? 0;
    withRoomies = widget.withRoomies;
    title = widget.title ?? '';
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

        return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: screenHeight * 0.15),
              children: [
                _buildImageSlider(context),
                SizedBox(height: 10),
                _buildTitle(context),
                SizedBox(height: 10),
                _buildAddress(context),
                SizedBox(height: 10),
                _buildServices(context),
                SizedBox(height: 10),
                _buildDescription(context),
                SizedBox(height: 30),
                _buildPrice(context),
                _buildMaps(context)
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildAppBar(context),
            ),
          ],
        ),
      ),
    );
  }

void setMarker(){
              _markers.add(
              Marker(
                markerId: MarkerId("1"),
                position: LatLng(widget.latitude, widget.longitude),
              )
              );
}
Widget _buildTitle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildAddress(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      address,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildPrice(BuildContext context) {
  String formattedPrice =
      NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(price);
  return Padding(
    padding: const EdgeInsets.only(left: 250),
    child: Text(
      formattedPrice,
      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
    ),
  );
}
Widget _buildDescription(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Cuartos: ${numOfRooms}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Camas: ${numOfBeds}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Inquilinos : ${numOfTenants}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Baños: ${numOfBathrooms}',
          style: TextStyle(fontSize: 16),
        )
      ],
    ),
  );
}

Widget _buildServices(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Servicios:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (widget.services != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.services!.map((service) {
              return Text(
                "- $service",
                style: TextStyle(fontSize: 16),
              );
            }).toList(),
          ),
      ],
    ),
  );
}



Widget _buildImageSlider(BuildContext context) {
  return propertyPhotos.isNotEmpty
      ? CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 8),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            enableInfiniteScroll: true,
            viewportFraction: 1,
          ),
          items: propertyPhotos.map((photo) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(photo),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        )
      : Container();
}
Widget _buildAppBar(BuildContext context) {
  String isOnMyProperty = "";
  if (widget.isOnMyProperties == "Yes") {
    isOnMyProperty = "Editar";
  } else if (widget.isOnMyProperties == "Yess") {
    isOnMyProperty = "Cancelar";
  } else {
    isOnMyProperty = "Rentar";
  }
  return CustomAppBar(
    backgroundColor: Colors.white,
    leadingWidth: 48,
    leftText: "Atrás",
    rightText: isOnMyProperty,
    showBoxShadow: false,
    onTapLeftText: () {
      if (widget.isOnMyProperties == "Yes") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyPropertiesScreen(currentPosition: widget.currentPosition)));
      } else if (widget.previousPage == 'Mapa') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreenMap(currentPosition: widget.currentPosition)),
        );
      } else {
        Navigator.pop(context);
      }
    },
    onTapRigthText: () {
      if (isOnMyProperty == "Rentar") {
        _checkUserAndRentProperty();
      } else if (isOnMyProperty == "Cancelar") {
        _buildCancelButton(context);
      } else {
        _buildEditPropertyButton();
      }
    },
  );
}

Widget _buildMessage(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    // ignore: unnecessary_null_comparison
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
    // ignore: unnecessary_null_comparison
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

 void _checkUserAndRentProperty() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final userSnapshot = await FirebaseFirestore.instance.collection('User').doc(currentUser.uid).get();
    if (userSnapshot.exists) {
      final userType = userSnapshot['userType'];
      if (userType == 'Owner') {
        _showOwnerCannotRentDialog();
      } else {
        final rentedPropertiesSnapshot = await FirebaseFirestore.instance.collection('Property').where('isRentedBy', arrayContains: currentUser.uid).get();
        if (rentedPropertiesSnapshot.docs.isNotEmpty) {
          _showAlreadyRentingDialog();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NuevaPantalla(
                idProperty: widget.idProperty,
                price: widget.price,
              ),
            ),
          );
        }
      }
    }
  }
}

void _showAlreadyRentingDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Ya está alquilando una propiedad"),
        content: Text("No puede alquilar otra propiedad mientras aún esté alquilando una."),
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


  void _showOwnerCannotRentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No puede rentar un propietario"),
          content: Text("Los propietarios no pueden rentar sus propiedades."),
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



void _buildEditPropertyButton() async {
  Position? currentPosition = await _getCurrentLocation();

  if (currentPosition != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadRoomScreen(
          myPropertyId: widget.idProperty,
          currentPosition: LatLng(currentPosition.latitude, currentPosition.longitude),
        ),
      ),
    );
  } else {
  }
}

Future<Position?> _getCurrentLocation() async {
  try {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    print("Error al obtener la ubicación del usuario: $e");
    return null;
  }
}


void _buildDeleteConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmar eliminación"),
        content: Text("¿Está seguro de que desea eliminar esta propiedad?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              _deleteProperty(); 
            },
            child: Text("Eliminar"),
          ),
        ],
      );
    },
  );
}
  void _deleteProperty() {
    FirebaseFirestore.instance.collection('Property').doc(widget.idProperty).delete().then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      print("Error al eliminar la propiedad: $error");
    });
  }
  
  void _buildCancelButton(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmar cancelación de renta"),
        content: Text("¿Está seguro de que desea cancelar esta renta?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              _cancelProperty(); 
            },
            child: Text("Confirmar"),
          ),
        ],
      );
    },
  );
}void _cancelProperty() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      final propertyRef = FirebaseFirestore.instance.collection('Property').doc(widget.idProperty);

      final propertySnapshot = await propertyRef.get();
      final propertyData = propertySnapshot.data() as Map<String, dynamic>?;

      if (propertyData != null) {
        final newNumOfBathrooms = propertyData['numOfBathrooms'] + 1;
        final newNumOfBeds = propertyData['numOfBeds'] + 1;
        final newNumOfTenants = propertyData['numOfTenants'] + 1;
        final newNumOfRooms = propertyData['numOfRooms'] + 1;

        List<String> rentedByList;
        if (propertyData['isRentedBy'] is String) {
          rentedByList = [propertyData['isRentedBy']];
        } else {
          rentedByList = List.from(propertyData['isRentedBy'] ?? []);
        }
        if (rentedByList.contains(uid)){
        rentedByList.remove(uid);
        await propertyRef.update({
          'numOfBathrooms': newNumOfBathrooms,
          'numOfBeds': newNumOfBeds,
          'numOfTenants': newNumOfTenants,
          'numOfRooms': newNumOfRooms,
          'isRentedBy': rentedByList,
          'isRented': false,
          'canBeShared': false,
          'withRoomies': []
        });
        }
        
        Navigator.pushNamed(context, AppRoutes.myRentsScreen);
      }
    }
  } catch (error) {
    print("Error al cancelar la renta: $error");
  }
}

  Widget _buildMaps(BuildContext context) {
    LatLng initialCameraPosition = LatLng(widget.latitude, widget.longitude);
    return SizedBox(

      height: 120,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: initialCameraPosition,
          zoom: 14.0,
        ),
        markers: _markers,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          if (!googleMapController.isCompleted) {
            googleMapController.complete(controller);
          }
        },

      ),
    );
  }
}

