import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/screens/myProperties/my_properties_screen.dart';
import 'package:resty_app/presentation/screens/myProperties/uploadProperty/location_propertie_screen.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

class SettingHouseScreen extends StatefulWidget {
  final String? idProperty;
  final LatLng? currentPosition;

  const SettingHouseScreen({Key? key, this.idProperty, this.currentPosition}) : super(key: key);

  @override
  _SettingHouseScreenState createState() => _SettingHouseScreenState();
}

class _SettingHouseScreenState extends State<SettingHouseScreen> {
  int _roomsCount = 0;
  int _bedsCount = 0;
  int _bathroomsCount = 0;
  int _tenantsCount = 0;

  @override
@override
void initState() {
  super.initState();
  if (widget.idProperty != null) {
    getUserInfo();
  }
}


  Future<void> getUserInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Property')
          .doc(widget.idProperty)
          .get();
      setState(() {
        _roomsCount = snapshot.data()?["numOfRooms"];
        _bedsCount = snapshot.data()?["numOfBeds"];
        _bathroomsCount = snapshot.data()?["numOfBathrooms"];
        _tenantsCount = snapshot.data()?["numOfTenants"];
      });
    } catch (e) {
      print("Error getting user info: $e");
    }
  }

  void _incrementCounter(String field) {
    setState(() {
      switch (field) {
        case 'rooms':
          _roomsCount++;
          break;
        case 'beds':
          _bedsCount++;
          break;
        case 'bathrooms':
          _bathroomsCount++;
          break;
        case 'tenants':
          _tenantsCount++;
          break;
      }
    });
  }

  void _decrementCounter(String field) {
    setState(() {
      switch (field) {
        case 'rooms':
          _roomsCount = _roomsCount > 0 ? _roomsCount - 1 : 0;
          break;
        case 'beds':
          _bedsCount = _bedsCount > 0 ? _bedsCount - 1 : 0;
          break;
        case 'bathrooms':
          _bathroomsCount = _bathroomsCount > 0 ? _bathroomsCount - 1 : 0;
          break;
        case 'tenants':
          _tenantsCount = _tenantsCount > 0 ? _tenantsCount - 1 : 0;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Un poco sobre tu propiedad",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            _buildCounterOption("Habitaciones", _roomsCount, 'rooms', context),
            _buildDivider(),
            _buildCounterOption("Camas", _bedsCount, 'beds', context),
            _buildDivider(),
            _buildCounterOption("Baños", _bathroomsCount, 'bathrooms', context),
            _buildDivider(),
            _buildCounterOption(
                "Inquilinos", _tenantsCount, 'tenants', context),
            SizedBox(height: screenHeight * .38),
            _buildAppBar(context),
          ],
        ),
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
          context, MaterialPageRoute(
            builder: (context) => MyPropertiesScreen(currentPosition: widget.currentPosition)));
      },
      onTapRigthText: () {
        if (_roomsCount != 0 && _tenantsCount != 0 && _bathroomsCount != 0) {
          if (widget.idProperty != null) {
            actualizarPropiedad(widget.idProperty!, _bathroomsCount, _bedsCount,
                _roomsCount, _tenantsCount);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationPropertyScreen(
                        idProperty: widget.idProperty, 
                        currentPosition: widget.currentPosition,)));
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Alerta"),
                content: Text(
                    "Debe haber por lo menos 1 habitación, 1 baño y 1 inquilino."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Aceptar"),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget _buildCounterOption(
      String title, int count, String field, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => _decrementCounter(field),
              ),
              Text(
                count.toString(),
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _incrementCounter(field),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }

  void actualizarPropiedad(String idProperty, int _bathroomsCount,
      int _bedsCount, int _roomsCount, int _tenantsCount) {
    FirebaseFirestore.instance.collection('Property').doc(idProperty).update({
      'numOfBathrooms': _bathroomsCount,
      'numOfBeds': _bedsCount,
      'numOfRooms': _roomsCount,
      'numOfTenants': _tenantsCount
    });
  }
}
