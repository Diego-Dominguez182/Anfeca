import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/location_propertie_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/upload_property_photos.dart';

import '../../../widgets/app_bar/custom_app_bar.dart';

class PropertyServicesScreen extends StatefulWidget {
  final String? idProperty;
  final LatLng? currentPosition;

  const PropertyServicesScreen({super.key, this.idProperty, this.currentPosition});

  @override
  // ignore: library_private_types_in_public_api
  _PropertyServicesScreenState createState() => _PropertyServicesScreenState();
}

class PropertyService {
  final String name;
  final IconData icon;
  bool isSelected;

  PropertyService(
      {required this.name, required this.icon, required this.isSelected});
}

class _PropertyServicesScreenState extends State<PropertyServicesScreen> {
  List<PropertyService> services = [
    PropertyService(name: 'Cocina', icon: Icons.kitchen, isSelected: false),
    PropertyService(name: 'Lavadora', icon: Icons.wash, isSelected: false),
    PropertyService(name: 'WiFi', icon: Icons.wifi, isSelected: false),
    PropertyService(
        name: 'Estacionamiento', icon: Icons.local_parking, isSelected: false),
    PropertyService(name: 'TV', icon: Icons.tv, isSelected: false),
    PropertyService(
        name: 'Aire Acondicionado', icon: Icons.ac_unit, isSelected: false),
  ];

  @override
  void initState() {
    super.initState();
    getPropertyServices();
  }

  Future<void> getPropertyServices() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Property')
          .doc(widget.idProperty)
          .get();
      List<String>? selectedServices =
          List<String>.from(snapshot.data()!['services']);
      setState(() {
        for (var service in services) {
          service.isSelected = selectedServices.contains(service.name);
        }
      });
    } catch (e) {
      print("Error getting user info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¿Qué tipos de servicio ofrece tu propiedad?'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildPropertyServices(context),
          ),
          _buildAppBar(context),
        ],
      ),
    );
  }

  Widget _buildPropertyServices(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona los servicios:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: services.map((service) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  service.isSelected = !service.isSelected;
                });
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey),
                ),
                color: service.isSelected ? Colors.blue : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        service.icon,
                        size: 40,
                        color: service.isSelected ? Colors.white : Colors.black,
                      ),
                      SizedBox(height: 8),
                      Text(
                        service.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              service.isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
                    LocationPropertyScreen(idProperty: widget.idProperty, currentPosition: widget.currentPosition)));
      },
      onTapRigthText: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UploadPropertyScreen(idProperty: widget.idProperty, currentPosition: widget.currentPosition)));
        actualizarPropiedad(widget.idProperty!);
      },
    );
  }

  void actualizarPropiedad(String idProperty) {
    List<String> selectedServices = [];
    for (var service in services) {
      if (service.isSelected) {
        selectedServices.add(service.name);
      }
    }
    FirebaseFirestore.instance.collection('Property').doc(idProperty).update({
      'services': selectedServices,
    });
  }
}
