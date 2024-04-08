import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/custom_outlined_button.dart';
import 'package:resty_app/presentation/widgets/custom_text_form_field.dart';

// ignore: must_be_immutable
class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  TextEditingController correoElectronicoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgRoommateroots1,
                height: 250,
                width: 293,
                margin: EdgeInsets.only(left: 10),
              ),
              SizedBox(height: 7),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 43),
                child: CustomTextFormField(
                  controller: correoElectronicoController,
                  hintText: "Correo electrónico",
                  textInputAction: TextInputAction.done,
                  autofocus: false,
                ),
              ),
              SizedBox(height: 18),
              CustomOutlinedButton(
                text: "Reestablecer contraseña",
                margin: EdgeInsets.symmetric(horizontal: 43),
                onPressed: () {
                  onTapResetPassword(context);
                },
              ),
              SizedBox(height: 7),
              CustomOutlinedButton(
                text: "Regresar",
                margin: EdgeInsets.symmetric(horizontal: 43),
                onPressed: () {
                  onTapBack(context);
                },
              ),
              SizedBox(height: 5)
            ],
          ),
        ),
      ),
    );
  }

  onTapBack(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainScreen);
  }

  onTapResetPassword(BuildContext context) async {
    String email = correoElectronicoController.text.trim();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Link enviado"),
              content: Text(
                  "Se ha enviado un link para reestablecer la contraseña vía correo electrónico"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          });
    } catch (error) {
      print("Error al enviar correo de restablecimiento: $error");
    }
  }
}
