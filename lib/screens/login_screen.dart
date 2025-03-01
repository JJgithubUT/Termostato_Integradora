import 'package:flutter/material.dart';
import 'package:termostato_1/screens/register_user_screen.dart';
import 'package:termostato_1/screens/thermostatus_screen.dart';
import 'package:termostato_1/services/user_service.dart';
//import 'package:termostato_1/screens/thermostatus_screen.dart';
import '../widgets/themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  
  @override // Aquí se comienza a autologuear al usuario si ya ha iniciado sesión previamente
  void initState() {
    super.initState();
    
    UserService().getLocalUser().then((user) {
      if (user != null) {
        print('Usuario local encontrado: ${user.nombre}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThermostatusScreen()),
        );
      }
    });

  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = null; // Limpiar mensaje previo
    });

    try {
      final user = await UserService().logUser(
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
                  obscureText: true,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterUserScreen()),
                    );
                  }, // Navegación a registro
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
