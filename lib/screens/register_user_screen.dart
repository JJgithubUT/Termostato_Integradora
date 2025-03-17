import 'package:flutter/material.dart';
import 'package:termostato_2/widgets/themes.dart';
import 'package:termostato_2/services/cloud_firestore_service.dart';
import 'package:termostato_2/services/validation_service.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _alertEmailController = TextEditingController();
  final TextEditingController _alertPasswordController =
      TextEditingController();
  final TextEditingController _alertNameController = TextEditingController();
  final ValidationService _validationService = ValidationService();

  Future<void> _register() async {
    setState(() {});
    //Navigator.pop(context);
    if (!_validationService.isValidEmail(_emailController.text)) {
      _alertEmailController.text = 'Correo no validable';
    }
    if (!_validationService.isValidPassword(_passwordController.text)) {
      _alertPasswordController.text = 'Contraseña no validable';
    }
    if (!_validationService.isValidName(_nameController.text)) {
      _alertNameController.text = 'Nombre menor a 10 caracteres';
    }

    if (_validationService.isValidEmail(_emailController.text) &&
        _validationService.isValidPassword(_passwordController.text) &&
        _validationService.isValidName(_nameController.text)) {
      await CloudFirestoreService().signUp(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        nombre: _nameController.text,
      );
      cleanFields();
    }
  }

  void cleanFields() {
    _emailController.text = '';
    _passwordController.text = '';
    _nameController.text = '';
    _alertEmailController.text = '';
    _alertPasswordController.text = '';
    _alertNameController.text = '';
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
                TextField(
                  obscureText: _obscureText,
                  maxLength: 50,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: inputLabelStyle,
                    suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                    ),
                  ),
                ),
                Text(
                  _alertPasswordController.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text("Registrar"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    cleanFields();
                    Navigator.of(context).pop();
                  }, // Navegación al login
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
