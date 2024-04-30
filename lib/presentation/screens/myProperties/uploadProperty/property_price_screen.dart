
// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resty_app/presentation/screens/myProperties/my_properties_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/property_description_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/upload_property_photos.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/upload_property_screen.dart';
import 'package:resty_app/routes/app_routes.dart';

import '../../../widgets/app_bar/custom_app_bar.dart';

class PropertyPriceScreen extends StatefulWidget {
  final String? idProperty;
  final LatLng? currentPosition;

  const PropertyPriceScreen({super.key, this.idProperty, this.currentPosition});

  @override
  // ignore: library_private_types_in_public_api
  _PropertyPriceScreenState createState() => _PropertyPriceScreenState();
}

class _PropertyPriceScreenState extends State<PropertyPriceScreen> {
  int _currentPrice = 0;
  TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Precio de la Propiedad'),
      ),
        body: ListView(
          children: [
            _buildSelectPrice(context),
            SizedBox(height: screenHeight * .51),
            _buildAppBar(context),
            
          ],
        ),
      );
  }

  Widget _buildSelectPrice(BuildContext context){
    return   Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona el precio:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Slider(
              value: _currentPrice.toDouble(),
              min: 0,
              max: 30000, 
              divisions: 5000,
              label: _currentPrice.toString(),
              onChanged: (double value) {
                if (value > 0 && value < 20000) {
                  setState(() {
                  _currentPrice = value.toInt();
                  _priceController.text = value.toInt().toString();
                });
                }
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
  int? parsedValue = int.tryParse(value);
  if (parsedValue != null && parsedValue >= 0 && parsedValue <= 30000) {
    setState(() {
      _currentPrice = parsedValue;
    });
  }
},

            ),
            const SizedBox(height: 20.0),
          ],
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
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PropertyDescriptionScreen(idProperty: widget.idProperty,
                    currentPosition: widget.currentPosition)));
      },
      onTapRigthText: () {
        _savePrice();
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => MyPropertiesScreen(currentPosition: widget.currentPosition))
        );
      },
    );
  }
  
  void _savePrice() {
    int price = int.tryParse(_priceController.text) ?? 0;
    if (price > 0 && price < 30000) {
      FirebaseFirestore.instance.collection('Property').doc(widget.idProperty).update({
        'price': price,
        'withRoomie': "",
        'isRented': false,
        'canBeShared': false
      });
    } else if (price > 30000) {
            showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Precio excedido"),
            content: const Text("Monto máximo es 30,000 pesos."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
      else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Por favor, ingresa un precio válido."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
    }
  }

