import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/screens/Home/main_screen.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:resty_app/presentation/widgets/date_input_formatter.dart';

class NuevaPantalla extends StatefulWidget {
  final String? idProperty;
  final String? previousPage;
  final List<String>? propertyPhotos;
  final String? description;
  final double? price;
  final String? address;
  final List<String>? services;
  final int? numOfBathrooms;
  final int? numOfBeds;
  final int? numOfTenants;
  final List<String>? withRoomies;
  final String? title;

  const NuevaPantalla({
    Key? key,
    this.idProperty,
    this.previousPage,
    this.propertyPhotos,
    this.description,
    this.price,
    this.address,
    this.services,
    this.numOfBathrooms,
    this.numOfBeds,
    this.numOfTenants,
    this.withRoomies,
    this.title,
  }) : super(key: key);

  @override
  _NuevaPantallaState createState() => _NuevaPantallaState();
}

class _NuevaPantallaState extends State<NuevaPantalla> {
  TextEditingController _numeroTarjetaController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _ccvController = TextEditingController();
  TextEditingController _fechaVencimientoController = TextEditingController();
  bool _compartir = false;
  double _precioFinal = 0.0;
  late String userName = '';
  late String snapshot = '';

  @override
  void initState() {
    super.initState();
    _precioFinal = (widget.price! * 1.5) ;
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('User').doc(uid).get();
      setState(() {
        userName = snapshot.data()!["firstName"];
      });
    } catch (e) {
      print("Error getting user info: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: screenHeight * 0.15),
              children: [
                SizedBox(height: 20),
                _buildNombreTextField(context),
                SizedBox(height: 20),
                _buildNumeroTarjetaTextField(context),
                SizedBox(height: 20),
                _expirationDateController(context),
                SizedBox(height: 10),
                _buildCCVTextField(context),
                SizedBox(height: 10),
                _buildCompartirSwitch(context)
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildAppBar(context),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildNumeroTarjetaTextField(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Número de Tarjeta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: _numeroTarjetaController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),           
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildNombreTextField(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nombre',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: _nombreController,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCCVTextField(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CCV',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: _ccvController,
            keyboardType: TextInputType.number,
             inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),           
               ],
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _expirationDateController(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha de Vencimiento (MM/AA)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: _fechaVencimientoController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
              MMYYInputFormatter(),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}


 Widget _buildCompartirSwitch(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Precio: \$${_precioFinal.toStringAsFixed(2)}'),
        Switch(
          value: _compartir,
          onChanged: (value) {
            setState(() {
              _compartir = value;
              _updatePrecioFinal();
            });
          },
        ),
      ],
    ),
  );
}



  void _updatePrecioFinal() {
    setState(() {
      if (_compartir) {
        _precioFinal = widget.price ?? 0.0;
      } else {
        _precioFinal = (widget.price ?? 0.0) * 1.5;
      }
    });
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: Colors.white,
      leadingWidth: 48,
      leftText: "Atrás",
      rightText: "Rentar",
      showBoxShadow: false,
      onTapLeftText: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      },
      onTapRigthText: () {
        _savePrice();
      },
    );
  }

  
void _savePrice() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;

    DocumentReference propertyRef = FirebaseFirestore.instance.collection('Property').doc(widget.idProperty);
    
DocumentSnapshot<Map<String, dynamic>> propertySnapshot = await propertyRef.get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> propertyData = propertySnapshot.data()!;

    int currentNumOfBeds = propertyData['numOfBeds'];
    int currentNumOfTenants = propertyData['numOfTenants'];
    int currentNumOfRooms = propertyData['numOfRooms'];

    int newNumOfBeds = currentNumOfBeds - 1;
    int newNumOfTenants = currentNumOfTenants - 1;
    int newNumOfRooms = currentNumOfRooms - 1;

    DateTime now = DateTime.now();
    DateTime dateOfPayment = DateTime(now.year, now.month + 1, now.day, 0, 0, 0);

    if (_compartir) {
      await propertyRef.update({
        'withRoomies': FieldValue.arrayUnion([userName]),
        'isRented': true,
        'canBeShared': true,
        'isRentedBy': FieldValue.arrayUnion([uid]),
        'numOfBeds': newNumOfBeds,
        'numOfTenants': newNumOfTenants,
        'numOfRooms': newNumOfRooms,
        'dateOfPayment': dateOfPayment,
      });
    } else {
      await propertyRef.update({
        'withRoomies': [],
        'isRented': true,
        'canBeShared': false,
        'isRentedBy': FieldValue.arrayUnion([uid]),
        'numOfBeds': newNumOfBeds,
        'numOfTenants': newNumOfTenants,
        'numOfRooms': newNumOfRooms,
        'dateOfPayment': dateOfPayment,
      });
    }


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Éxito"),
          content: const Text("La propiedad ha sido alquilada con éxito."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.mainScreen);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print("Error saving price: $e");
  }
}
}