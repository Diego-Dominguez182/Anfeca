import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:SecuriSpace/presentation/screens/Authentication/login_screen.dart';

class MockBuildContext extends Mock implements BuildContext {}

// Define MockUserCredential
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('LoginScreen widget test', () {
    late MockBuildContext mockBuildContext;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockBuildContext = MockBuildContext();
      mockFirebaseAuth = MockFirebaseAuth();
    });

    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return LoginScreen();
            },
          ),
        ),
      );

      expect(find.text('Iniciar sesión'), findsOneWidget);
      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
    });

    testWidgets('Login button works as expected', (WidgetTester tester) async {
      // Mocking FirebaseAuth and UserCredential here
      // Configura el mock de FirebaseAuth para devolver un resultado exitoso
      when(mockFirebaseAuth.signInWithEmailAndPassword(
              email: "test@example.com", password: "password"))
          .thenAnswer((_) => Future.value(MockUserCredential()));

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return LoginScreen();
            },
          ),
        ),
      );
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pump();

      // Verifica que la navegación se haya realizado correctamente
      expect(find.text('Bienvenido'), findsOneWidget);
    });

    // More tests here for other cases, such as email validation, etc.
  });
}
