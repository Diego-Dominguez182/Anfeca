import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SecuriSpace/core/app_export.dart';
import 'package:SecuriSpace/presentation/screens/Home/preference_form.dart';
import 'package:SecuriSpace/presentation/widgets/custom_outlined_button.dart';
import 'package:SecuriSpace/presentation/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen> {
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
              imagePath: ImageConstant.securiSpaceIcon,
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
        return CustomOutlinedButton(
          text: "Reestablecer contraseña",
          margin: EdgeInsets.symmetric(horizontal: 34.h),
          onPressed: () {
            onTapResetPassword(context);
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
        Navigator.pushNamed(context, AppRoutes.mainScreen);
      } else if ((snapshot_user.  data() != null &&
              snapshot_user.data()!["userType"] == "Tenant" &&
              snapshot_user.data()!["schoolFile"] == null) ||
          (snapshot_user_check.data() != null &&
              snapshot_user_check.data()!["userType"] == "Tenant" &&
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
      } else if ((snapshot_user.data()?["schoolFile"] != null &&
              snapshot_user.data()?["verified"] == false) ||
          (snapshot_user_check.data()?["schoolFile"] != null &&
              snapshot_user_check.data()?["verified"] == false)) {
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
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else if (snapshot_user.data()?['firstTime'] == true){
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => PreferenceForm(firstTime: true)));
     }else {
        Navigator.pushNamed(context, AppRoutes.mainScreen);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Cuenta no registrada"),
            content: Text("Revisa tus credenciales"),
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
      const SnackBar(
        content: Text('Revisa tus credenciales'),
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
