import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/property_services_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/settings_house_screen.dart';

import '../../../widgets/app_bar/custom_app_bar.dart';

class LocationPropertieScreen extends StatefulWidget {
  final String? idProperty;

  const LocationPropertieScreen({Key? key, this.idProperty}) : super(key: key);

  @override
  _LocationPropertieScreenState createState() =>
      _LocationPropertieScreenState();
}

class _LocationPropertieScreenState extends State<LocationPropertieScreen> {
  Completer<GoogleMapController> googleMapController = Completer();
  TextEditingController _searchController = TextEditingController();
  CameraPosition _currentCameraPosition = CameraPosition(
    target: LatLng(18.1288823, -94.44264989999999),
    zoom: 14.0,
  );

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
  }

  Future<void> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) async {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.0,
        );
      });
    }).catchError((error) async {
      await Geolocator.requestPermission();
      print("ERROR: $error");
    });
  }

  Future<void> _onSearch() async {
    try {
      String address = _searchController.text;
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        setState(() {
          _currentCameraPosition = CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 14.0,
          );
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId('searched_location'),
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(title: 'Searched Location'),
            ),
          );
        });
        _moveToSearchedLocation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'No se encontraron resultados para la dirección ingresada'),
          ),
        );
      }
    } catch (e) {
      print("Error");
    }
  }

  void _moveToSearchedLocation() async {
    GoogleMapController controller = await googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_currentCameraPosition),
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
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SettingHouseScreen(idProperty: widget.idProperty)));
      },
      onTapRigthText: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PropertyServicesScreen(idProperty: widget.idProperty)));
        actualizarPropiedad(widget.idProperty!);
      },
    );
  }

  Widget _buildMaps(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _currentCameraPosition,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      markers: _markers,
      onCameraMove: (CameraPosition position) {
        _markers.removeWhere(
            (marker) => marker.markerId.value == 'center_location');

        _markers.add(
          Marker(
            markerId: MarkerId('center_location'),
            position: position.target,
            infoWindow: InfoWindow(title: 'Center Location'),
          ),
        );
        setState(() {
          _currentCameraPosition = position;
        });
      },
      onMapCreated: (GoogleMapController controller) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("¿Dónde está ubicado?"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar dirección",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          Expanded(
            child: _buildMaps(context),
          ),
          _buildAppBar(context)
        ],
      ),
    );
  }

  void actualizarPropiedad(String idProperty) {
    FirebaseFirestore.instance.collection('Property').doc(idProperty).update({
      'latitude': _currentCameraPosition.target.latitude,
      'longitude': _currentCameraPosition.target.longitude,
    });
  }
}
