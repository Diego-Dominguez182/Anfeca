import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

class SettingHouseScreen extends StatefulWidget {
  const SettingHouseScreen({Key? key}) : super(key: key);

  @override
  _SettingHouseScreenState createState() => _SettingHouseScreenState();
}

class _SettingHouseScreenState extends State<SettingHouseScreen> {
  int _roomsCount = 0;
  int _bedsCount = 0;
  int _bathroomsCount = 0;
  int _tenantsCount = 0;

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
            _buildCounterOption(
                "Habitaciones", _roomsCount, 'rooms', context),
            _buildDivider(),
            _buildCounterOption("Camas", _bedsCount, 'beds', context),
            _buildDivider(),
            _buildCounterOption(
                "Baños", _bathroomsCount, 'bathrooms', context),
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
        Navigator.pushNamed(context, AppRoutes.uploadRoomScreen);
      },
      onTapRigthText: () {
        Navigator.pushNamed(context, AppRoutes.locationPropertieScreen);
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
}
