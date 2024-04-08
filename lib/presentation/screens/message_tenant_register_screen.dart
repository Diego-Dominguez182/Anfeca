import 'package:flutter/material.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/custom_outlined_button.dart';

class MessageTenantRegisterScreen extends StatelessWidget {
const MessageTenantRegisterScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 28.v),
          width: double.maxFinite,
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgRoommateroots1,
                  height: 250.v,
                  width: 282.h,
                ),
                SizedBox(height: 14.v),
                _buildMessage(context),
                SizedBox(height: 34.v),
                _buildAcceptButton(context),
              ]
            )
          )
        )
    );
  }

Widget _buildMessage(BuildContext context){
  return Container(
    width: 233.h,
    margin: EdgeInsets.symmetric(horizontal: 28.h),
    child: Text(
      "Estamos revisando los documentos que subiste, obtendras respuesta lo más pronto posible",
      overflow: TextOverflow.ellipsis,
      maxLines: 5,
      textAlign: TextAlign.center,
      style: restyTextTheme.displaySmall,
    ),
  );
}

Widget _buildAcceptButton(BuildContext context){
  return CustomOutlinedButton(
    text: "Aceptar",
    margin: EdgeInsets.symmetric(horizontal: 34.h),
    onPressed: () {
      onTapAccept(context);
    }
  );
}
  onTapAccept(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainScreen);
  }
}