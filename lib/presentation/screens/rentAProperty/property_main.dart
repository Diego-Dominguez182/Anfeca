import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart'; 
import 'package:resty_app/presentation/screens/Home/main_screen_map.dart';
import 'package:resty_app/presentation/screens/Home/menu_screen.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:resty_app/routes/app_routes.dart';

class PropertyMainScreen extends StatefulWidget {
  final String? idProperty;
  final String? previousPage;
  final LatLng? currentPosition;
  final List<String>? propertyPhotos;
  final String? description;
  final double? price;
  final String? address;
    final List<String>? services;

  const PropertyMainScreen({Key? key, 
  this.idProperty, 
  this.previousPage, 
  this.currentPosition,
  this.propertyPhotos,
  this.description,
  this.price,
  this.address,
  this.services
  }) : super(key: key);

  @override
  _PropertyMainScreen createState() => _PropertyMainScreen();
}

class _PropertyMainScreen extends State<PropertyMainScreen> {
  String? address;
  String? description;
  List<String>? propertyPhotos = [];
  double? price;
  List<String>? services;

  @override
  void initState() {
    propertyPhotos = widget.propertyPhotos;
    description = widget.description;
    price = widget.price;
    address = widget.address;
    services = widget.services;
    super.initState();
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
              _buildImageSlider(context),
              SizedBox(height: 20),
              _buildAddress(context),
              SizedBox(height: 10),
              _buildPrice(context),
              SizedBox(height: 10),
              _buildDescription(context),
              _buildServices(context)
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


Widget _buildImageSlider(BuildContext context) {
  return propertyPhotos != null && propertyPhotos!.isNotEmpty
      ? CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 8),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            enableInfiniteScroll: true,
            viewportFraction: 1, 
          ),
          items: propertyPhotos!.map((photo) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(photo),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        )
      : Container(); 
}


  Widget _buildAddress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        address ?? '',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

Widget _buildPrice(BuildContext context) {
  String formattedPrice =
      NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(price);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      formattedPrice,
      style: TextStyle(fontSize: 18),
    ),
  );
}

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        description ?? '',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: CustomAppBar(
      backgroundColor: Colors.white,
      leadingWidth: 48,
      leftText: "Atrás",
      rightText: "Rentar",
      showBoxShadow: false,
      onTapLeftText: () {
        if (widget.previousPage == 'Mapa') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreenMap(currentPosition: widget.currentPosition)),
          );
        } else {
          Navigator.pushNamed(context, AppRoutes.mainScreen);
        }
      },
      onTapRigthText: () {
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => MenuScreen()));
      },
    ),
  );
}


Widget _buildMessage(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: address != null
        ? Text(
            "$address",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        : Center(
            child: CircularProgressIndicator(), 
          ),
  );
}



  Widget _buildImageRoom(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: address != null
        ? Text(
            "$description",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        : Center(
            child: CircularProgressIndicator(), 
          ),
  );
  }

    Widget _buildServices(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: address != null
        ? Text(
            "$services",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        : Center(
            child: CircularProgressIndicator(), 
          ),
  );
  }
}



