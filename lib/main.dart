// main.dart
import 'package:flutter/material.dart';
import 'package:termostato_1/screens/login_screen.dart';
import 'package:termostato_1/services/mongo_service.dart';
//import 'package:termostato_1/thermostatus.dart';
import 'package:termostato_1/widgets/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService().connect();
  print('Conexión a MongoDB establecida.');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const LoginScreen(),
    );
  }
}