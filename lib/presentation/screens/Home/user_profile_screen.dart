import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resty_app/presentation/widgets/app_bar/custom_app_bar.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String? firstName;
  String? lastName;
  String? email;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    String uid = user!.uid;

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('User').doc(uid).get();
    setState(() {
      firstName = snapshot.data()!['firstName'];
      lastName = snapshot.data()!['lastName'];
      email = snapshot.data()!['email'];
    });
  }

  Future<void> _changePassword() async {
    try {
      User? user = _auth.currentUser;
      String email = user!.email!;
      String currentPassword = _currentPasswordController.text.trim();
      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (newPassword != confirmPassword) {
        _showErrorDialog("Las contraseñas no coinciden.");
        return;
      }

      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      _showSuccessDialog("Contraseña cambiada exitosamente.");
    } catch (e) {
      print("Error changing password: $e");
      _showErrorDialog("Hubo un error al cambiar la contraseña. Por favor, inténtelo de nuevo.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Éxito"),
          content: Text(message),
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

  Widget _userInfoContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Información del Usuario",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text("Nombre: $firstName $lastName"),
          SizedBox(height: 10),
          Text("Email: $email"),
        ],
      ),
    );
  }

  Widget _changePasswordContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Cambiar Contraseña",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _passwordField(
            controller: _currentPasswordController,
            labelText: "Contraseña Actual",
          ),
          SizedBox(height: 10),
          _passwordField(
            controller: _newPasswordController,
            labelText: "Nueva Contraseña",
          ),
          SizedBox(height: 10),
          _passwordField(
            controller: _confirmPasswordController,
            labelText: "Confirmar Contraseña",
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _changePassword,
            child: Text("Cambiar Contraseña"),
          ),
        ],
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de Usuario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _userInfoContainer(),
            _changePasswordContainer(),
          ],
        ),
      ),
    );
  }
}
