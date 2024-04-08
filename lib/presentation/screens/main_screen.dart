import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty_app/core/app_export.dart';
import 'package:resty_app/presentation/widgets/custom_outlined_button.dart';
import 'package:resty_app/presentation/widgets/custom_text_form_field.dart';
import 'package:resty_app/presentation/widgets/button_state.dart';

// ignore_for_file: must_be_immutable
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _showUploadButton = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 35.h, vertical: 24.v),
        child: Column(
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgRoommateroots1,
              height: 250.v,
              width: 282.h,
            ),
            SizedBox(height: 31.v),
            _buildEmail(context),
            SizedBox(height: 9.v),
            _buildPassword(context),
            SizedBox(height: 18.v),
            _buildLoginButton(context),
            SizedBox(height: 9.v),
            _buildRegisterButton(context),
            SizedBox(height: 9.v),
            _buildResetPassword(context),
            SizedBox(height: 9.v),
            if (_showUploadButton) ...[
              _buildUploadFile(context),
            ],
          ],
        ),
      ),
    ));
  }

  Widget _buildEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 34.h),
      child: CustomTextFormField(
        controller: emailFieldController,
        hintText: "Correo electrónico",
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
    return CustomOutlinedButton(
      text: "Registrarse",
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      onPressed: () {
        onTapRegisterButton(context);
      },
    );
  }

  Widget _buildResetPassword(BuildContext context) {
    return Consumer<ButtonState>(
      builder: (context, buttonState, _) {
        return CustomOutlinedButton(
          text: "Reestablecer contraseña",
          margin: EdgeInsets.symmetric(horizontal: 34.h),
          onPressed: () {
            buttonState.setResetPasswordPressed("Reset");
            onTapResetPassword(context);
          },
        );
      },
    );
  }

  void onTapLoginButton(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailFieldController.text,
        password: passwordFieldController.text,
      );

      DocumentSnapshot<Map<String, dynamic>> snapshot_user =
          await FirebaseFirestore.instance
              .collection('User')
              .doc(userCredential.user!.uid)
              .get();
      DocumentSnapshot<Map<String, dynamic>> snapshot_user_check =
          await FirebaseFirestore.instance
              .collection('User_check')
              .doc(userCredential.user!.uid)
              .get();

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
      } else if (snapshot_user.data()!["userType"] == "Owner") {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(userCredential.user!.uid)
            .update({
          'verified': true,
        });
        Navigator.pushNamed(context, AppRoutes.principalScreen);
      } else if ((snapshot_user.data()!["userType"] == "Tenant" &&
              snapshot_user.data()!["schoolFile"] == null) ||
          (snapshot_user_check.data()!["userType"] == "Tenant" &&
              snapshot_user_check.data()!["schoolFile"] == null)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error de inicio de sesión"),
              content: Text("No has subido tu archivo."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showUploadButton = false;
                    print(_showUploadButton);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
        setState(() {
          _showUploadButton = true;
        });
      } else if ((snapshot_user.exists &&
              snapshot_user.data()!["verified"] == false) ||
          (snapshot_user_check.exists &&
              snapshot_user_check.data()!["verified"] == false)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error de inicio de sesión"),
              content:
                  Text("Seguimos revisando tus documentos, intenta más tarde"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showUploadButton = false;
                    print(_showUploadButton);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        Navigator.pushNamed(context, AppRoutes.principalScreen);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revisa tus credenciales'),
        ),
      );
    }
  }

  Widget _buildLoginButton(BuildContext context) {
    return CustomOutlinedButton(
      text: "Iniciar sesión",
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      onPressed: () {
        onTapLoginButton(context);
      },
    );
  }

  Widget _buildUploadFile(BuildContext context) {
    return CustomOutlinedButton(
        text: "Sube tu archivo",
        margin: EdgeInsets.symmetric(horizontal: 34.h),
        onPressed: () {
          onTapUploadFile(context);
        });
  }

  void onTapUploadFile(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.messageFileScreen);
  }

  void onTapResetPassword(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.resetPasswordScreen);
  }

  void onTapRegisterButton(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.mainRegistrationScreen);
  }
}
