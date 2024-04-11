import 'package:flutter/material.dart';

class IconButtonWithText extends StatelessWidget {
  final String text;
  final String imageName; // Nombre de la imagen
  final VoidCallback onPressed;

  const IconButtonWithText({
    required this.text,
    required this.imageName,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/$imageName'; 
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(8.0),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.blue.shade700
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Image.asset(
              imagePath,
              width: 24.0, 
              height: 24.0, 
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.white, 
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
