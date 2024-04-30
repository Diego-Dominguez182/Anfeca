import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:resty_app/presentation/screens/Home/main_screen.dart';
import 'package:resty_app/presentation/screens/rentAProperty/property_main.dart';
class MainItemWidget extends StatelessWidget {
  final String idProperty;
  final String address;
  final double price;
  final List<String> propertyPhotos;
  String withRoomie;

  MainItemWidget({
    Key? key,
    required this.idProperty,
    required this.address,
    required this.price,
    required this.propertyPhotos,
    required this.withRoomie, required Property property,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (withRoomie.isEmpty) {
      withRoomie = "No tiene roomie";
    } else {
      withRoomie = 'Será compartido con: ' + withRoomie;
    }

    String formattedPrice =
        NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(price);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PropertyMainScreen(idProperty: this.idProperty),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        height: 250, // Ajusta la altura del contenedor
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: propertyPhotos.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: propertyPhotos[index],
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 200, // Ajusta el tamaño de la imagen
                      width: double.infinity,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                address,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                withRoomie,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                formattedPrice,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
