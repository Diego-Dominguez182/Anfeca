import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SecuriSpace/core/app_export.dart';
import 'package:SecuriSpace/presentation/widgets/custom_outlined_button.dart';
import 'package:SecuriSpace/presentation/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class OwnerRegistrationScreen extends StatefulWidget {
  const OwnerRegistrationScreen({Key? key}) : super(key: key);

  @override
  _OwnerRegistrationScreenState createState() =>
      _OwnerRegistrationScreenState();
}

class _OwnerRegistrationScreenState extends State<OwnerRegistrationScreen> {
  bool _isPasswordObscured = true;
  TextEditingController firstNameFieldController = TextEditingController();

  TextEditingController lastNameFieldController = TextEditingController();

  TextEditingController emailFieldController = TextEditingController();

  TextEditingController passwordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 38.h, vertical: 24.v),
                child: Column(children: [
                  CustomImageView(
                      imagePath: ImageConstant.securiSpaceIcon,
                      height: 250.v,
                      width: 282.h),
                  SizedBox(height: 31.v),
                  _buildFirstName(context),
                  SizedBox(height: 9.v),
                  _buildLastName(context),
                  SizedBox(height: 9.v),
                  _buildEmail(context),
                  SizedBox(height: 9.v),
                  _buildPassword(context),
                  SizedBox(height: 18.v),
                  _buildRegisterButton(context),
                  SizedBox(height: 9.v),
                  _buildBackButton(context),
                  SizedBox(height: 9.v),
                  _buildContinueButton(context),
                  SizedBox(height: 9.v)
                ]))));
  }

  Widget _buildFirstName(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 34.h),
        child: CustomTextFormField(
            controller: firstNameFieldController,
            hintText: "Nombre(s)",
            autofocus: false));
  }

  Widget _buildLastName(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 34.h),
        child: CustomTextFormField(
            controller: lastNameFieldController,
            hintText: "Apellidos",
            autofocus: false));
  }

  Widget _buildEmail(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 34.h),
        child: CustomTextFormField(
            controller: emailFieldController,
            hintText: "Correo electrónico o número",
            autofocus: false));
  }

  Widget _buildContinueButton(BuildContext context) {
    return CustomOutlinedButton(
      text: "Continuar",
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      onPressed: () {
        onTapContinue(context);
      },
    );
  }

  Widget _buildPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 34.h),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          CustomTextFormField(
            obscureText: _isPasswordObscured,
            controller: passwordFieldController,
            hintText: "Contraseña",
            textInputAction: TextInputAction.done,
            autofocus: false,
          ),
          IconButton(
            icon: Icon(
              _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordObscured = !_isPasswordObscured;
              });
            },
          ),
        ],
      ),
    );
  }

  void onTapContinue(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailFieldController.text,
        password: passwordFieldController.text,
      );

      if (!userCredential.user!.emailVerified) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error de inicio de sesión"),
              content: Text(
                  "Tu correo electrónico aún no ha sido verificado. Por favor, verifica tu correo electrónico."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
      Map<String, dynamic> datosActualizados = {"verified": true};
      Navigator.pushNamed(context, AppRoutes.loginScreen);
      FirebaseFirestore.instance
          .collection("User")
          .doc(userCredential.user!.uid)
          .update(datosActualizados);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revisa tus credenciales'),
        ),
      );
    }
  }

  Widget _buildRegisterButton(BuildContext context) {
    return CustomOutlinedButton(
      text: "Registrarse",
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      onPressed: () {
        _registerWithEmailAndPassword(context);
      },
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return CustomOutlinedButton(
        text: "Regresar",
        margin: EdgeInsets.only(left: 34.h, right: 33.h),
        onPressed: () {
          onTapBack(context);
        });
  }

  onTapBack(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainRegistrationScreen);
  }

  onTapRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginScreen);
  }

  void _registerWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailFieldController.text.trim(),
        password: passwordFieldController.text,
      );

      await userCredential.user!.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection('User')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstNameFieldController.text,
        'lastName': lastNameFieldController.text,
        'email': emailFieldController.text.trim(),
        'verified': false,
        'userType': 'Owner'
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Verifica tu correo electrónico"),
            content: Text(
                "Se ha enviado un correo electrónico de verificación. Por favor, verifica tu correo electrónico antes de continuar."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }
}
