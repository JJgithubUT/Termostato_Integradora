import 'package:flutter/material.dart';
/* import 'package:termostato_2/widgets/themes.dart'; */
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
      try {
        await CloudFirestoreService().signUp(
          context: context,
          email: _emailController.text,
          password: _passwordController.text,
          nombre: _nameController.text,
        );
        cleanFields();
      } catch (e) {
        // ignore: avoid_print
        print("Error en el registro: $e");
      }
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF133C55), // Azul oscuro
              Color(0xFF386FA4), // Azul intermedio
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF59A5D8), // Fondo azul claro
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Regístrate",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF91E5F6), // Azul brillante
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    maxLength: 50,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Color(0xFF84D2F6),
                      ), // Azul pastel
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                  const SizedBox(height: 10),
                  TextField(
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      labelStyle: TextStyle(color: Color(0xFF84D2F6)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: _obscureText,
                    maxLength: 50,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      labelStyle: TextStyle(color: Color(0xFF84D2F6)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF386FA4),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF386FA4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                    ),
                    onPressed: _register,
                    child: const Text(
                      "Registrar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF133C55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                    ),
                    onPressed: () {
                      cleanFields();
                      Navigator.of(context).pop();
                    }, // Navegación al login
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
