import 'package:firebase_core/firebase_core.dart';
import 'package:termostato_2/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:termostato_2/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}
// Hola
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Climatic',
      home: const LoginScreen(),
    );
  }
}
