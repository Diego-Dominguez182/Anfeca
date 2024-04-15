import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

class UploadRoomScreen extends StatefulWidget {
  const UploadRoomScreen({Key? key}) : super(key: key);

  @override
  _UploadRoomScreenState createState() => _UploadRoomScreenState();
}

class _UploadRoomScreenState extends State<UploadRoomScreen> {
  String _selectedProperty = ''; // Variable para almacenar la propiedad seleccionada

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          children: [
            SizedBox(height: 20),
            _buildMessage(context),
            SizedBox(height: 20),
            _buildHouseButton(context),
            SizedBox(height: 20),
            _buildRoomButton(context),
            SizedBox(height: screenHeight * .35),
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
        Navigator.pushNamed(context, AppRoutes.myPropertiesScreen);
      },
      onTapRigthText: () {
        if (_selectedProperty == "Casa completa") {
          Navigator.pushNamed(context, AppRoutes.settingHouseScreen);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Alerta"),
                content: Text("Por favor, selecciona una propiedad."),
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

  Widget _buildMessage(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "¿Qué tipo de propiedad es?",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHouseButton(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9, // Adjust width as needed
    child: GestureDetector(
      onTap: () {
        setState(() {
          _selectedProperty = 'Casa completa';
        });
      },
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: _selectedProperty == 'Casa completa'
              ? Border.all(color: Colors.black, width: 2)
              : Border.all(color: Colors.black.withOpacity(0.05), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.house, size: 70, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Casa completa",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Propiedad completa para alquilar",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    ),
  );
}

Widget _buildRoomButton(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9, // Adjust width as needed
    child: GestureDetector(
      onTap: () {
        setState(() {
          _selectedProperty = 'Cuarto individual';
        });
      },
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.green,
          border: _selectedProperty == 'Cuarto individual'
              ? Border.all(color: Colors.black, width: 2)
              : Border.all(color: Colors.black.withOpacity(0.05), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hotel, size: 70, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Cuarto individual",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cuarto individual para alquilar",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    ),
  );
}

}
