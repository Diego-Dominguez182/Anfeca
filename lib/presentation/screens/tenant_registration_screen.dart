import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resty_app/presentation/widgets/custom_outlined_button.dart';
import 'package:resty_app/presentation/widgets/custom_text_form_field.dart';

class TenantRegistrationScreen extends StatefulWidget {
  TenantRegistrationScreen({Key? key}) : super(key: key);

  @override
  _TenantRegistrationScreenState createState() =>
      _TenantRegistrationScreenState();
}

class _TenantRegistrationScreenState extends State<TenantRegistrationScreen> {
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
          child: Column(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgRoommateroots1,
                height: 250.v,
                width: 282.h,
              ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 34.h),
      child: CustomTextFormField(
        controller: firstNameFieldController,
        hintText: "Nombre(s)",
        autofocus: false,
      ),
    );
  }

  Widget _buildLastName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 34.h),
      child: CustomTextFormField(
        controller: lastNameFieldController,
        hintText: "Apellidos",
        autofocus: false,
      ),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 34.h),
      child: CustomTextFormField(
        controller: emailFieldController,
        hintText: "Correo electrónico institucional",
        autofocus: false,
      ),
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

  Widget _buildRegisterButton(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return CustomOutlinedButton(
          text: "Registrarse",
          margin: EdgeInsets.symmetric(horizontal: 34.h),
          onPressed: () {
            _registerWithEmailAndPassword(context);
          },
        );
      },
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return CustomOutlinedButton(
      text: "Regresar",
      margin: EdgeInsets.only(left: 34.h, right: 33.h),
      onPressed: () {
        onTapRegresar(context);
      },
    );
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
      } else {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(userCredential.user!.uid)
            .update({
          'verified': true,
        });
        Navigator.pushNamed(context, AppRoutes.messageFileScreen);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revisa tus credenciales'),
        ),
      );
    }
  }

  void onTapRegresar(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainRegistrationScreen);
  }

  void _registerWithEmailAndPassword(BuildContext context) async {
    try {
      final String email = emailFieldController.text.trim();
      final String domain = email.split('@').last;

      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('Configuraciones')
              .doc('dominios')
              .get();

      final List<dynamic> allowedDomains = snapshot.data()!['permitidos'];
      final List<dynamic> disallowedDomains = snapshot.data()!['no_permitidos'];

      if (allowedDomains.contains(domain)) {
        _registerUserInCollection(context, email, isVerified: false);
      } else if (disallowedDomains.contains(domain)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Este dominio de correo electrónico no está permitido.'),
          ),
        );
      } else {
        _registerUserInCollection(context, email,
            isVerified: false, collection: 'User_check');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }

  void _registerUserInCollection(BuildContext context, String email,
      {required bool isVerified, String collection = 'User'}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: passwordFieldController.text,
      );

      await userCredential.user!.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstNameFieldController.text,
        'lastName': lastNameFieldController.text,
        'email': email,
        'verified': false,
        'userType': 'Tenant',
        'schoolFile': null,
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
