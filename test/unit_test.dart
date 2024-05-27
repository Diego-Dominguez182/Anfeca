import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SecuriSpace/presentation/screens/Authentication/login_screen.dart';
import 'package:SecuriSpace/presentation/screens/Authentication/owner_registration_screen.dart';

void main() {
  setUpAll(() async {
        TestWidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();

    // Configura Firebase para que use los emuladores
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  });
    test('Login Test', () async {
      // Ejecuta el inicio de sesión directamente
      // Asegúrate de tener una cuenta de prueba válida en tu base de datos de prueba
      final email = 'diegodgz.199@gmail.com';
      final password = 'prueba';

      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Verifica que el inicio de sesión haya sido exitoso
        expect(userCredential.user, isNotNull);
      } catch (e) {
        // Maneja cualquier error que pueda ocurrir durante el inicio de sesión
        fail('Error al iniciar sesión: $e');
      }
    });

    test('Owner Registration Test', () async {
      // Ejecuta el registro de propietarios directamente
      // Asegúrate de proporcionar datos válidos para el registro de propietarios
      final firstName = 'John';
      final lastName = 'Doe';
      final email = 'john.doe@example.com';
      final password = 'testPassword';

      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Verifica que el usuario se haya registrado correctamente
        expect(userCredential.user, isNotNull);

        // Actualiza los datos del usuario en la base de datos
        await FirebaseFirestore.instance.collection('User').doc(userCredential.user!.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'verified': false,
          'userType': 'Owner',
        });

        // Verifica que los datos del usuario se hayan guardado correctamente en la base de datos
        final userSnapshot = await FirebaseFirestore.instance.collection('User').doc(userCredential.user!.uid).get();
        expect(userSnapshot.exists, true);
        expect(userSnapshot.data()?['firstName'], firstName);
        expect(userSnapshot.data()?['lastName'], lastName);
        expect(userSnapshot.data()?['email'], email);
        expect(userSnapshot.data()?['verified'], false);
        expect(userSnapshot.data()?['userType'], 'Owner');
      } catch (e) {
        // Maneja cualquier error que pueda ocurrir durante el registro
        fail('Error al registrar propietario: $e');
      }
    });
  }