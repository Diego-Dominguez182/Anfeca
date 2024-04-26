  // ignore_for_file: library_private_types_in_public_api, deprecated_member_use

  import 'dart:async';

  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

  import 'package:geocoding/geocoding.dart';
  import 'package:geolocator/geolocator.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:resty_app/core/utils/image_constant.dart';
import 'package:resty_app/presentation/screens/Home/main_screen_map.dart';
  import 'package:resty_app/presentation/screens/Home/menu_screen.dart';
  import 'package:resty_app/presentation/theme/app_decoration.dart';
  import 'package:resty_app/presentation/theme/custom_text_style.dart';
  import 'package:resty_app/presentation/widgets/custom_image_view.dart';
  import 'package:resty_app/presentation/widgets/custom_search_view.dart';
  import 'package:resty_app/presentation/widgets/icon_button_with_text.dart';
  import 'package:resty_app/presentation/widgets/main_item_widget.dart';
import 'package:resty_app/routes/app_routes.dart';

  class MainScreen extends StatefulWidget {
    const MainScreen({super.key});

    @override
    _MainScreenState createState() => _MainScreenState();
  }

  class _MainScreenState extends State<MainScreen> {
    TextEditingController searchController = TextEditingController();
    Completer<GoogleMapController> googleMapController = Completer();
    late Future<List<Property>>? propertiesFuture;
        LatLng? _currentPosition;

    @override
    void initState() {
      super.initState();
      propertiesFuture = getPropertiesFromFirebase();
      getUserCurrentLocation();
    }

 Future<void> getUserCurrentLocation() async {
      await Geolocator.requestPermission().then((value) async {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
      }).catchError((error) async {
        await Geolocator.requestPermission();
        print("ERROR: $error");
      });
    }

    Future<List<Property>> getPropertiesFromFirebase() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Property').get();
      List<Property> loadedProperties = [];
      for (var doc in querySnapshot.docs) {
        Property property = Property.fromDocumentSnapshot(doc);
        if (property.isValid()) { 
          loadedProperties.add(property);
        }
      }
      return loadedProperties;
    } catch (e) {
      print('Error getting properties: $e');
      return [];
    }
  }


    @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              const SizedBox(height: 8),
              _buildSettingsBar(context),
              const SizedBox(height: 8),
              _buildMessage(context),
              const SizedBox(height: 10),
              _buildRooms(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}


    Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 11),
      decoration: AppDecoration.outlineBlack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              // ignore: deprecated_member_use
                
                child: Row(
                  children: [
                    Expanded(
                      child: CustomSearchView(
                        controller: searchController,
                        onChanged: (value) {
                        },
                        autofocus: false,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search), onPressed: () {  },


                    ),
                  ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
            child: Container(
              height: 57,
              width: 47,
              margin: const EdgeInsets.only(
                left: 5,
                bottom: 5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 1),
              decoration: AppDecoration.outlineBlack900.copyWith(
                borderRadius: BorderRadius.circular(23),
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgPerfil1,
                height: 42,
                width: 42,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildSettingsBar(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double buttonWidth = (screenWidth / 7) - 24.0;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: IconButtonWithText(
                imageName: ImageConstant.listIcon,
                text: "Lista",
                onPressed: () {
                  setState(() {
                  });
                },
              ),
            ),
            SizedBox(width: buttonWidth),
            Expanded(
              child: IconButtonWithText(
                imageName: ImageConstant.mapIcon,
                text: "Mapa",
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => MainScreenMap(currentPosition: _currentPosition)));
                } 
              ),
            ),
            SizedBox(width: buttonWidth),
            Expanded(
              child: IconButtonWithText(
                imageName: ImageConstant.filterIcon,
                text: "Filtros",
                onPressed: () {
                  onTapFilter(context);
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildMessage(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          "Cerca de ti",
          style: CustomTextStyles.bodySmallBlack900,
        ),
      );
    }

    Widget _buildRooms(BuildContext context) {
      return FutureBuilder<List<Property>>(
        future: propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return _buildMain(context, snapshot.data ?? []);
            }
          }
        },
      );
    }
  Widget _buildMain(BuildContext context, List<Property> properties) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 29,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 190,
          crossAxisCount: 1,
          mainAxisSpacing: 37,
          crossAxisSpacing: 37,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return MainItemWidget(
            address: properties[index].address,
            price: properties[index].price,
            propertyPhotos: properties[index].photos, 
            property: properties[index],
          );
        },
      ),
    );
  }

    void onTapFilter(BuildContext context) {
      print("pene");
    }
  }
  class Property {
    final String address;
    final double price;
    final List<String> photos;

    Property({required this.address, required this.price, required this.photos});

    factory Property.fromDocumentSnapshot(DocumentSnapshot snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String> propertyPhotos =
          data['propertyPhotos'] != null ? List<String>.from(data['propertyPhotos']) : [];

      return Property(
        address: data['address'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
        photos: propertyPhotos,
      );
    }

    bool isValid() {
      return address.isNotEmpty && price > 0 && photos.isNotEmpty;
    }
  }


