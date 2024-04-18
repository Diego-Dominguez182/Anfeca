import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resty_app/presentation/widgets/button_state.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'core/app_export.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ButtonState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: theme,
          title: 'Roomates',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.loginScreen ,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
