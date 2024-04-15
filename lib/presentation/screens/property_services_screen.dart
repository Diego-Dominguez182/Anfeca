import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../widgets/app_bar/custom_app_bar.dart';

class PropertyServicesScreen extends StatefulWidget {
  @override
  _PropertyServicesScreenState createState() => _PropertyServicesScreenState();
}

class _PropertyServicesScreenState extends State<PropertyServicesScreen> {
  List<PropertyService> services = [
    PropertyService(name: 'Cocina', icon: Icons.kitchen, isSelected: false),
    PropertyService(name: 'Lavadora', icon: Icons.wash, isSelected: false),
    PropertyService(name: 'WiFi', icon: Icons.wifi, isSelected: false),
    PropertyService(name: 'Estacionamiento', icon: Icons.local_parking, isSelected: false),
    PropertyService(name: 'TV', icon: Icons.tv, isSelected: false),
    PropertyService(name: 'Aire Acondicionado', icon: Icons.ac_unit, isSelected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¿Qué tipos de servicio ofrece tu propiedad?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona los servicios:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
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
                              color: service.isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 5),
            _buildAppBar(context)
          ],
        ),
      ),
    );
  }
}

Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: Colors.white,
      leadingWidth: 48,
      leftText: "Atrás",
      rightText: "Siguiente",
      showBoxShadow: false,
      onTapLeftText: () {
        Navigator.pushNamed(context, AppRoutes.locationPropertieScreen);
      },
      onTapRigthText: () {
        Navigator.pushNamed(context, AppRoutes.uploadPropertyScreen);
      },
    );
  }
  
class PropertyService {
  final String name;
  final IconData icon;
  bool isSelected;

  PropertyService({required this.name, required this.icon, required this.isSelected});
}
