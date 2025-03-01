import 'package:flutter/material.dart';
import 'package:termostato_1/screens/thermostatus_screen.dart';
import 'package:termostato_1/widgets/themes.dart';
import 'package:termostato_1/services/user_service.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contraseniaController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _errorMessage;

  Future<void> _register() async {
    setState(() {
      _errorMessage = null; // Limpiar mensaje previo
    });

    try {
      // Lógica de registro
      final user = await UserService().registerUser(
        _emailController.text.trim(),
        _contraseniaController.text.trim(),
        _nameController.text.trim(),
      );

      if (user != null) {
        // Si el registro es exitoso, navega a otra pantalla
        print('Usuario registrado: ${user.nombre}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThermostatusScreen()),
        );
      } else {
        // Si es null, se muestra
        _showSnackBar('Error al registrar usuario.');
      }
    } catch (e) {
      _showSnackBar(e.toString().replaceAll('StateError: ', ''));
    }

  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
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
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: inputLabelStyle,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: _contraseniaController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: inputLabelStyle,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    labelStyle: inputLabelStyle,
                  ),
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text("Registrar"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, // Navegación a registro
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