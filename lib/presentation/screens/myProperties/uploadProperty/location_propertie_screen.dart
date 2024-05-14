import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/property_services_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/settings_house_screen.dart';

import '../../../widgets/app_bar/custom_app_bar.dart';

class LocationPropertyScreen extends StatefulWidget {
  final String? idProperty;
  final LatLng? currentPosition;
  

  const LocationPropertyScreen({Key? key, this.idProperty, this.currentPosition}) : super(key: key);

  @override
  _LocationPropertyScreen createState() =>
      _LocationPropertyScreen();
}

class _LocationPropertyScreen extends State<LocationPropertyScreen> {
  Completer<GoogleMapController> googleMapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  CameraPosition _currentCameraPosition = const CameraPosition(
    target: LatLng(18.1288823, -94.44264989999999),
    zoom: 14.0,
  );
  String? addres;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    LatLng? _currentPosition = widget.currentPosition;
    super.initState();
    setState(() {
      _currentCameraPosition =CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition.longitude ),
        zoom: 16);

    });
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
            zoom: 16.5,
          );
          _markers.clear();

        });
        _moveToSearchedLocation();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('No se encontraron resultados para la dirección ingresada'),
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
                    SettingHouseScreen(idProperty: widget.idProperty, currentPosition: widget.currentPosition)));
      },
      onTapRigthText: () {
        actualizarPropiedad(widget.idProperty!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PropertyServicesScreen(idProperty: widget.idProperty, currentPosition: widget.currentPosition)));
      },
    );
  }

  Widget _buildMaps(BuildContext context) {
    return SizedBox(
      height: 600,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _currentCameraPosition,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        markers: _markers,
        onCameraMove: (CameraPosition position) {
          _markers.add(
            Marker(
              markerId: const MarkerId('center_location'),
              position: position.target,
              infoWindow: const InfoWindow(title: 'Center Location'),
            ),
          );

          setState(() {
            _currentCameraPosition = position;
          });
        },
        onMapCreated: (GoogleMapController controller) {
          googleMapController.complete(controller);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¿Dónde está ubicado?"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar dirección",
                prefixIcon: const Icon(Icons.search),
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

  void actualizarPropiedad(String idProperty) async {
  double latitude = _currentCameraPosition.target.latitude;
  double longitude = _currentCameraPosition.target.longitude;

  List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

  if (placemarks.isNotEmpty) {
    Placemark placemark = placemarks.first;
    String address = "${placemark.thoroughfare}, ${placemark.locality}";
    print("Dirección encontrada: $address");
    FirebaseFirestore.instance.collection('Property').doc(idProperty).update({
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    });
  } else {
    print("No se pudo encontrar la dirección para las coordenadas: ($latitude, $longitude)");
  }
}
}