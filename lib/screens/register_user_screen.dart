import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:termostato_2/widgets/themes.dart';
import 'package:termostato_2/services/cloud_firestore_service.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contraseniaController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _alertEmailController = TextEditingController();
  final TextEditingController _alertContraseniaController =
      TextEditingController();
  final TextEditingController _alertNameController = TextEditingController();

  bool _isValidEmail(String email) {
    // Definir la expresión regular para validar correos electrónicos
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);

    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    // No debe contener espacios
    if (password.contains(RegExp(r'\s'))) {
      return false;
    }
    // Definir los criterios
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );
    bool hasMinLength = password.length >= 8;

    return hasUppercase &&
        hasLowercase &&
        hasDigits &&
        hasSpecialCharacters &&
        hasMinLength;
  }

  bool _isValidName(String name) {
    name.trim();
    bool hasMinLength = name.length >= 10;
    bool hasMaxLength = name.length <= 50;

    return hasMaxLength && hasMinLength;
  }

  /* void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                message,
                style: snackBarTextStyle, // Usa el estilo definido en themes.dart
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent, // Usa el color definido en themes.dart
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Usa el borde definido en themes.dart
        ),
        action: SnackBarAction(
          label: 'X',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  } */

  Future<void> _register() async {
    _alertEmailController.text = '';
    _alertContraseniaController.text = '';
    _alertNameController.text = '';
    setState(() {});
    //Navigator.pop(context);
    if (!_isValidEmail(_emailController.text)) {
      _alertEmailController.text = 'Correo no validable';
    }
    if (!_isValidPassword(_contraseniaController.text)) {
      _alertContraseniaController.text = 'Contraseña no validable';
    }
    if (!_isValidName(_nameController.text)) {
      _alertNameController.text = 'Nombre menor a 10 caracteres';
    }

    if (_isValidEmail(_emailController.text) &&
        _isValidPassword(_contraseniaController.text) &&
        _isValidName(_nameController.text)) {
      await CloudFirestoreService().signup(
        context: context,
        email: _emailController.text,
        password: _contraseniaController.text,
        nombre: _nameController.text,
      );
      _nameController.text = '';
      _emailController.text = '';
      _contraseniaController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Registrate", style: loginTitleStyle),
                const SizedBox(height: 20),
                TextField(
                  maxLength: 50,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: inputLabelStyle,
                  ),
                ),
                Text(
                  _alertEmailController.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /* const SizedBox(height: 10), */
                TextField(
                  maxLength: 50,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _contraseniaController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: inputLabelStyle,
                  ),
                  obscureText: false,
                ),
                Text(
                  _alertContraseniaController.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /* const SizedBox(height: 10), */
                TextField(
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    labelStyle: inputLabelStyle,
                  ),
                ),
                Text(
                  _alertNameController.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /* const SizedBox(height: 10), */
                ElevatedButton(
                  onPressed: _register,
                  child: const Text("Registrar"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {}, // Navegación a registro
                  child: const Text("Cancelar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
