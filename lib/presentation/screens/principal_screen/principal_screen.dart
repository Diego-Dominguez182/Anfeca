import 'package:resty_app/presentation/screens/tenant_profile_main_screen.dart';
import 'package:resty_app/presentation/widgets/custom_search_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'widgets/main_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';

// ignore: must_be_immutable
class PrincipalScreen extends StatelessWidget {
  PrincipalScreen({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();
  Completer<GoogleMapController> googleMapController = Completer();

  Future<int> getCantidadCuartos() async {
    return Future.delayed(const Duration(seconds: 1), () => 10);
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
                _buildTwelve(context),
                const SizedBox(height: 8),
                _buildMap(context),
                const SizedBox(height: 7),
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
      future: getCantidadCuartos(),
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

  Widget _buildTwelve(BuildContext context) {
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
                MaterialPageRoute(
                    builder: (context) => TenantProfileMainScreen()),
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

  Widget _buildMap(BuildContext context) {
    return SizedBox(
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
}
