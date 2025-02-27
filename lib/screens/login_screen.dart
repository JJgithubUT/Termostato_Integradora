import 'package:flutter/material.dart';
import 'package:termostato_1/screens/thermostatus_screen.dart';
//import 'package:termostato_1/screens/thermostatus_screen.dart';
import '../services/mongo_service.dart'; // Asegúrate de importar el servicio
import '../widgets/themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage; // Mostrar el mensaje de error

  Future<void> _login() async {
    setState(() {
      _errorMessage = null; // Limpiar mensaje previo
    });

    try {
      final user = await MongoService().logUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        // Si el login es exitoso, navega a otra pantalla
        print('Usuario autenticado: ${user.nombre}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThermostatusScreen()),
        );
      } else {
        // Si es null, se muestra
        _showSnackBar('Credenciales incorrectas.');
      }
    } catch (e) {
      _showSnackBar(e.toString().replaceAll('StateError: ', ''));
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
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
                Text("Iniciar Sesión", style: loginTitleStyle),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: inputLabelStyle,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: inputLabelStyle,
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text("Ingresar"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {}, // Navegación a registro
                  child: const Text("Registrate"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
