import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';

class MainItemWidget extends StatelessWidget {
  const MainItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[50],
      height: 75.v,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomImageView(
              imagePath: ImageConstant.imgImage1,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Tu primer texto aquí',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Tu segundo texto aquí',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
