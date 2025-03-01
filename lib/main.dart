// main.dart
import 'package:flutter/material.dart';
import 'package:termostato_1/screens/login_screen.dart';
//import 'package:termostato_1/screens/thermostatus_screen.dart';
import 'package:termostato_1/services/mongo_service.dart';
import 'package:termostato_1/services/user_service.dart';
import 'package:termostato_1/widgets/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService().connect();
  print('Conexión a MongoDB establecida.');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _userService.preLogUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Termostato',
      theme: appTheme,
      home: const LoginScreen(),
    );
  }

}