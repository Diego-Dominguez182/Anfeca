import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _newPassword = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [_buildNewPassword(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildNewPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Nueva Contraseña'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingresa una nueva contraseña';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _newPassword = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updatePassword(context);
                }
              },
              child: Text('Actualizar Contraseña'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePassword(BuildContext context) async {
    try {
      await _auth.currentUser?.updatePassword(_newPassword);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Contraseña actualizada exitosamente'),
      ));
    } catch (e) {
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
  }
}
