  // ignore_for_file: library_private_types_in_public_api, deprecated_member_use

  import 'dart:async';

  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

  import 'package:geocoding/geocoding.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:resty_app/core/utils/image_constant.dart';
  import 'package:resty_app/presentation/screens/Home/menu_screen.dart';
import 'package:resty_app/presentation/screens/rentAProperty/property_main.dart';
  import 'package:resty_app/presentation/theme/app_decoration.dart';
  import 'package:resty_app/presentation/widgets/custom_image_view.dart';
  import 'package:resty_app/presentation/widgets/custom_search_view.dart';
  import 'package:resty_app/presentation/widgets/icon_button_with_text.dart';
import 'package:resty_app/routes/app_routes.dart';

  class MainScreenMap extends StatefulWidget {
    final LatLng? currentPosition; 
    const MainScreenMap({super.key,  this.currentPosition, });

    @override
    _MainScreenMapState createState() => _MainScreenMapState();
  }

  class _MainScreenMapState extends State<MainScreenMap> {
    TextEditingController searchController = TextEditingController();
    Completer<GoogleMapController> googleMapController = Completer();
    
    LatLng? _currentPosition;
    late List<Property> loadedProperties; 

  final Set<Marker> _markers = {};
  
@override
void initState() {
  super.initState();
  _loadPropertiesFromFirebase(); 
  _currentPosition = widget.currentPosition;
}

Future<void> _loadPropertiesFromFirebase() async {
  try {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Property').get();
    loadedProperties = [];
    for (var doc in querySnapshot.docs) {
      try {
        Property property = Property.fromDocumentSnapshot(doc);
        if (property.isValid()) {
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId(property.idProperty),
                position: LatLng(property.latitude, property.longitude),
                onTap: () {
                  Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => 
                      PropertyMainScreen(
                        idProperty: property.idProperty,
                        previousPage: "Mapa",
                        currentPosition: _currentPosition,
                        description: property.description,
                        price: property.price,
                        propertyPhotos: property.photos,
                        address: property.address,
                        services: property.services,
                        numOfBathrooms: property.numOfBathrooms,
                        numOfBeds: property.numOfBeds,
                        numOfTenants: property.numOfTenants
                         )));
                },
              ),
            );
            loadedProperties.add(property);
          });
        } else {
          print('La propiedad con ID ${property.idProperty} no es válida y será omitida.');
        }
      } catch (e) {
        print('Error al cargar la propiedad: $e');
      }
    }
  } catch (e) {
    print('Error obteniendo propiedades: $e');
  }
}


    Future<void> moveToLocation(String address) async {

  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty ) {
      Location location = locations.first;
      _moveToLocation(LatLng(location.latitude, location.longitude));
    } else {
      print("No se encontraron coordenadas para la dirección ingresada");
    }
  } catch (e) {
    print("Error al obtener las coordenadas de la dirección: $e");
  }
}

void _moveToLocation(LatLng target) async {

  try {
    final GoogleMapController? controller = await googleMapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: 16.0,
        ),
      ));
    }
  } catch (e) {
    print("Error al mover la cámara a la posición: $e");
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
              _buildMaps(context),
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
              padding: const EdgeInsets.only(bottom: 10),
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
    googleMapController.future.then((controller) {
      moveToLocation(searchController.text);
        });
  },

                    ),
                  ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen(currentPosition: widget.currentPosition)),
              );
            },
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
                  Navigator.pushNamed(context, AppRoutes.mainScreen);
                },
              ),
            ),
            SizedBox(width: buttonWidth),
            Expanded(
              child: IconButtonWithText(
                imageName: ImageConstant.mapIcon,
                text: "Mapa",
                onPressed: () {
                },
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

  Widget _buildMaps(BuildContext context) {
    LatLng initialCameraPosition = _currentPosition ?? const LatLng(0.0, 0.0);

    return SizedBox(
      height: 580,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: initialCameraPosition,
          zoom: 14.0,
        ),
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          if (!googleMapController.isCompleted) {
            googleMapController.complete(controller);
          }
        },
        onCameraMove: (CameraPosition position) {
          setState(() {
            _currentPosition = position.target;
          });
        },
      ),
    );
  }

    void onTapFilter(BuildContext context) {
      print("pene");
    }
  }
  
  class Property {
  final String idProperty;
  final String address;
  final double price;
  final List<String> photos;
  final List<dynamic>? withRoomies;
  final int numOfRooms;
  final bool canBeShared;
  final bool isRented;
  final String description;
  final double latitude; 
  final double longitude;
  final List<String> services;
  final int numOfBathrooms;
  final int numOfBeds;
  final int numOfTenants;
  final List<String> isRentedBy;

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
    required this.latitude,
    required this.longitude,
    required this.services,
    required this.numOfBathrooms,
    required this.numOfBeds,
    required this.numOfTenants,
    required this.isRentedBy,
  });

factory Property.fromDocumentSnapshot(DocumentSnapshot snapshot) {
  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

  if (data == null || data.isEmpty) {
    throw Exception("Documento vacío o incompleto");
  }

  String idProperty = snapshot.id;
  String? address = data['address'];
  double? price = (data['price'] as num?)?.toDouble();
  List<String>? propertyPhotos = (data['propertyPhotos'] as List<dynamic>?)?.map((photo) => photo.toString()).toList();
  List<dynamic>? withRoomies = data['withRoomies'];
  int? numOfRooms = data['numOfRooms'];
  bool canBeShared = data['canBeShared'] ?? false;
  bool isRented = data['isRented'] ?? false;
  String? description = data['description'];
  double? latitude = (data['latitude'] as num?)?.toDouble();
  double? longitude = (data['longitude'] as num?)?.toDouble();
  List<String> services = data['services'] != null ? List<String>.from(data['services']) : [];
  int numOfBathrooms = data['numOfBathrooms'];
  int numOfBeds = data['numOfBeds'];
  int numOfTenants = data['numOfTenants'];
  List<String> isRentedBy = data['isRentedBy'] != null ? List<String>.from(data['isRentedBy']) : [];


  if (address == null || price == null || propertyPhotos == null  || numOfRooms == null || description == null || latitude == null || longitude == null) {
    throw Exception("Documento incompleto, no contiene todos los valores requeridos");
  }

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
    latitude: latitude,
    longitude: longitude,
    services: services,
    numOfBathrooms: numOfBathrooms,
    numOfBeds: numOfBeds,
    numOfTenants: numOfTenants,
    isRentedBy: isRentedBy,
  );
}




 bool isValid() {
      return address.isNotEmpty && price > 0 && photos.isNotEmpty && numOfRooms > 0 ;    }

  }


