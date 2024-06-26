  // ignore_for_file: library_private_types_in_public_api, deprecated_member_use

  import 'dart:async';

import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

  import 'package:geolocator/geolocator.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:SecuriSpace/core/utils/image_constant.dart';
import 'package:SecuriSpace/presentation/screens/Home/main_screen_map.dart';
  import 'package:SecuriSpace/presentation/screens/Home/menu_screen.dart';
  import 'package:SecuriSpace/presentation/theme/app_decoration.dart';
  import 'package:SecuriSpace/presentation/theme/custom_text_style.dart';
  import 'package:SecuriSpace/presentation/widgets/custom_image_view.dart';
  import 'package:SecuriSpace/presentation/widgets/custom_search_view.dart';
  import 'package:SecuriSpace/presentation/widgets/icon_button_with_text.dart';
  import 'package:SecuriSpace/presentation/widgets/main_item_widget.dart';

  class MainScreen extends StatefulWidget {
    final LatLng? currentPosition;
    const MainScreen({super.key, this.currentPosition});

    @override
    _MainScreenState createState() => _MainScreenState();
  }

  class _MainScreenState extends State<MainScreen> {
    TextEditingController searchController = TextEditingController();
    Completer<GoogleMapController> googleMapController = Completer();
    late Future<List<Property>>? propertiesFuture;
    LatLng? _currentPosition;
    String? propertyType;
    double? price = 10000;
    bool? withRoomie;
    String? city;
  
@override
  void initState() {
  super.initState();
  getUserCurrentLocation();
  propertiesFuture = getPropertiesFromFirebase(null, 100000, null);
}


 Future<void> getUserCurrentLocation() async {
      await Geolocator.requestPermission().then((value) async {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
      }).catchError((error) async {
        await Geolocator.requestPermission();
        print("ERROR: $error");
      });
    }

   Future<List<Property>> getPropertiesFromFirebase(String? propertyType, double? price, String? city) async {
  try {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Property').get();
    List<Property> loadedProperties = [];
    for (var doc in querySnapshot.docs) {
      try {
        Property property = Property.fromDocumentSnapshot(doc);
        if (property.isValid(true) && 
        (propertyType == null || property.propertyType == propertyType)
        && (price != 0 && property.price <= price!) && (city == null || property.address.contains(city))) {
          loadedProperties.add(property);
        }
      } catch (e) {
        print('Documento incompleto: ${doc.id}');
      }
    }
    return loadedProperties;
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
              const SizedBox(height: 8),
              _buildSettingsBar(context),
              const SizedBox(height: 8),
              _buildMessage(context),
              const SizedBox(height: 10),
              _buildRooms(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}


    Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 11),
      decoration: AppDecoration.outlineBlack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              // ignore: duplicate_ignore
              // ignore: deprecated_member_use
                child: Row(
                  children: [
                    Expanded(
                      child: CustomSearchView(
                        controller: searchController,
                        onChanged: (value) {
                        },
                        autofocus: false,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search), 
                      onPressed: () { 
                        getPropertiesFromFirebase(null, 100000, searchController.text).then((properties) {
                  setState(() {
                    propertiesFuture = Future.value(properties);
                  });
                        });
                       },
                    ),
                  ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (_currentPosition == null) {
                getUserCurrentLocation();
              } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  MenuScreen(currentPosition: _currentPosition)),
              );
            }},
            child: Container(
              height: 57,
              width: 47,
              margin: const EdgeInsets.only(
                left: 5,
                bottom: 5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 1),
              decoration: AppDecoration.outlineBlack900.copyWith(
                borderRadius: BorderRadius.circular(23),
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgPerfil1,
                height: 42,
                width: 42,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildSettingsBar(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double buttonWidth = (screenWidth / 7) - 24.0;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: IconButtonWithText(
                imageName: ImageConstant.listIcon,
                text: "Lista",
                onPressed: () {
                  setState(() {
                  });
                },
              ),
            ),
            SizedBox(width: buttonWidth),
            Expanded(
              child: IconButtonWithText(
                imageName: ImageConstant.mapIcon,
                text: "Mapa",
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => MainScreenMap(currentPosition: _currentPosition)));
                } 
              ),
            ),
            SizedBox(width: buttonWidth),
            Expanded(
              child: IconButtonWithText(
                imageName: ImageConstant.filterIcon,
                text: "Filtros",
                onPressed: () {
                  onTapFilter(context);
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildMessage(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          "Cerca de ti",
          style: CustomTextStyles.bodySmallBlack900,
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
            isOnMyProperties: "No",
            isRentedBy: properties[index].isRentedBy,
            longitude: properties[index].longitude,
            latitude: properties[index].latitude
          );
        },
      ),
    );
  }

void onTapFilter(BuildContext context) {
  TextEditingController priceController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text('Tipo de propiedad'),
              onTap: () {
                _showSubmenuType(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Precio'),
              onTap: () {
                _showPriceDialog(context, priceController); 
              },
            ),
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text('Dirección'),
              onTap: () {
                _showCityDialog(context, cityController); 
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_forward),
              title: Text("Aplicar"),
              onTap: () {
                getPropertiesFromFirebase(propertyType, price, city).then((properties) {
                  setState(() {
                    propertiesFuture = Future.value(properties);
                  });
                });
                Navigator.pop(context);
              },
            ),
           ListTile(
              leading: Icon(Icons.clear_all),
              title: Text("Limpiar filtros"),
              onTap: () {
                price = 100000;
                propertyType = null;
                city = null;
                getPropertiesFromFirebase(propertyType, price, null).then((properties) {
                  setState(() {
                    propertiesFuture = Future.value(properties);
                  });
                });
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    },
  );
}

void _showPriceDialog(BuildContext context, TextEditingController priceController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Introduce el precio'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              price = double.tryParse(priceController.text);
            },
            child: Text('Confirmar'),
          ),
        ],
      );
    },
  );
}

void _showCityDialog(BuildContext context, TextEditingController cityController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Introduce la direccion'),
        content: TextField(
          controller: cityController,
          keyboardType: TextInputType.name,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              city = cityController.text;
            },
            child: Text('Confirmar'),
          ),
        ],
      );
    },
  );
}

void _showSubmenuType(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Casa completa'),
              onTap: () {
                propertyType = "Casa completa";
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Cuarto individual'),
              onTap: () {
                propertyType = "Cuarto individual";
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

  }
  class Property {
  final String idProperty; 
  final String address;
  final double price;
  final List<String> photos;
  final List<String> withRoomies;
  final int numOfRooms;
  final bool canBeShared;
  final bool isRented;
  final String description;
  final List<String> services;
  final int numOfBathrooms;
  final int numOfBeds;
  final int numOfTenants;
  final String title;
  final List<String> isRentedBy;
  final double latitude;
  final double longitude;
  final String propertyType;

  Property({
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
    required this.latitude,
    required this.longitude,
    required this.propertyType
  });

  factory Property.fromDocumentSnapshot(DocumentSnapshot snapshot) {
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

  if (data == null || data.isEmpty ) { 
    throw Exception("Documento vacío o incompleto");
  }

  String idProperty = snapshot.id;
  String address = data['address'] ?? '';
  double price = (data['price'] ?? 0).toDouble();
  List<String> propertyPhotos = data['propertyPhotos'] != null ? List<String>.from(data['propertyPhotos']) : [];
  List<String> withRoomies = data['withRoomies'] != null ? List<String>.from(data['withRoomies']) : [];
  int numOfRooms = data['numOfRooms'];
  bool canBeShared = data['canBeShared'];
  bool isRented = data['isRented'];
  String description = data['description'];
  List<String> services = data['services'] != null ? List<String>.from(data['services']) : [];
  int numOfBathrooms = data['numOfBathrooms'];
  int numOfBeds = data['numOfBeds'];
  int numOfTenants = data['numOfTenants'];
  String title = data['title'];
  List<String> isRentedBy = data['isRentedBy'] != null ? List<String>.from(data['isRentedBy']) : [];
  double? latitude = (data['latitude'] as num).toDouble();
  double? longitude = (data['longitude'] as num).toDouble();
  String propertyType = data['propertyType'];


  return Property(
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
    longitude: longitude,
    latitude: latitude,
    propertyType: propertyType
  );
}


  bool isValid(bool i) {
    if (i){
      return address.isNotEmpty && price > 0 && photos.isNotEmpty && numOfRooms > 0  && numOfBeds > 0
      && ((isRented == true && canBeShared == true) || (isRented == false && canBeShared == false));
    }
    else {
        return address.isNotEmpty && price > 0 && photos.isNotEmpty && numOfRooms > 0;
    }
    }
  }

