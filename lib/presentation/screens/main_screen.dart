import 'package:flutter/widgets.dart';
import 'package:resty_app/presentation/screens/menu_screen.dart';
import 'package:resty_app/presentation/widgets/custom_search_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resty_app/presentation/widgets/icon_button_with_text.dart';
import 'dart:async';
import '../widgets/main_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:geolocator/geolocator.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchController = TextEditingController();
  Completer<GoogleMapController> googleMapController = Completer();
  late Future<int> cantidadCuartosFuture;
  bool mapIsOn = false;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    cantidadCuartosFuture = getCantidadCuartos();
    getUserCurrentLocation(); 
  }

  Future<int> getCantidadCuartos() async {
    return Future.delayed(const Duration(seconds: 1), () => 10);
  }

  Future<void> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) async {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPosition = position;
      });
    }).catchError((error) async {
      await Geolocator.requestPermission();
      print("ERROR: $error");
    });
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
                if(mapIsOn) ...[
                  _buildMaps(context)],
                if(!mapIsOn) ... [
                  _buildMessage(context)],
                const SizedBox(height: 10),
                if(!mapIsOn) ... [
                  _buildRooms(context)],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaps(BuildContext context){
    LatLng initialCameraPosition = LatLng(
      currentPosition?.latitude ?? 0.0,
      currentPosition?.longitude ?? 0.0,
    );

    return SizedBox(
      height: 600,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: initialCameraPosition,
          zoom: 14.0,
        ),
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
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
                  mapIsOn = false;
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
                setState(() {
                  mapIsOn = true;
                });
              },
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
    return FutureBuilder<int>(
      future: cantidadCuartosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return _buildMain(context, snapshot.data ?? 0);
          }
        }
      },
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
              child: CustomSearchView(
                controller: searchController,
                autofocus: false,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
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

  Widget _buildMain(BuildContext context, int cantidadCuartos) {
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
        itemCount: cantidadCuartos,
        itemBuilder: (context, index) {
          return const MainItemWidget();
        },
      ),
    );
  }

  void onTapFilter(BuildContext context) {
    print("pene");
  }
}
