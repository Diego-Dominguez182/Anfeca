import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resty_app/presentation/screens/Home/main_screen.dart';
import 'package:resty_app/presentation/widgets/custom_image_view.dart'; // Importar para utilizar NumberFormat

class MainItemWidget extends StatelessWidget {
  final String address;
  final double price; 
  final List<String> propertyPhotos;

  const MainItemWidget({
    Key? key,
    required this.address,
    required this.price,
    required this.propertyPhotos, required Property property,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedPrice = NumberFormat.currency(locale: 'es_ES', symbol: '\$').format(price);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border(
          bottom: BorderSide(color: Colors.blue),
          left: BorderSide(color: Colors.blue),
          right: BorderSide(color: Colors.blue),
        ),
      ),
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomImageView(
                imagePath: propertyPhotos.isNotEmpty ? propertyPhotos[0] : '',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
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
          SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              formattedPrice, // Mostrar el precio formateado
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
    );
  }
}
