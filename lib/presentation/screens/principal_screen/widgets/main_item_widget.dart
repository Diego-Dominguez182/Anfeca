import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';

class MainItemWidget extends StatelessWidget {
  const MainItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1.0, color: Colors.blue),
      ),
      height: 75.v,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea los hijos a la izquierda
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomImageView(
                imagePath: ImageConstant.imgImage1,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 8.0), // Agrega un relleno a la izquierda del texto
            child: Text(
              'Tu primer texto aquí',
              textAlign: TextAlign.left, // Alinea el texto a la izquierda
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 8.0), // Agrega un relleno a la izquierda del texto
            child: Text(
              'Tu segundo texto aquí',
              textAlign: TextAlign.left, // Alinea el texto a la izquierda
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
