import 'package:flutter/material.dart';
import 'package:termostato_2/screens/register_user_screen.dart';
import 'package:termostato_2/services/cloud_firestore_service.dart';
import 'package:termostato_2/services/validation_service.dart';
import '../widgets/themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _alertEmailController = TextEditingController();
  final TextEditingController _alertPasswordController =
      TextEditingController();
  final ValidationService _validationService = ValidationService();

  @override
  void initState() {
    super.initState();
    autoLogUser(); // Llama al método que maneja el trabajo asincrónico
  }

  Future<void> autoLogUser() async {
    print('Estamos ahora en Login Screen');
    var localUser = await CloudFirestoreService().getLocalUser();

    if (localUser == null) {
      print('Usuario local nulo');
      return;
    }

    print(localUser['emailUsuario']);

    String? email = localUser['emailUsuario'];
    String? password = localUser['contraseniaUsuario'];

    if (email != null && password != null) {
      // Si hay datos de usuario guardados, intentar iniciar sesión automáticamente
      await CloudFirestoreService().logIn(context: context, email: email, password: password);
      _emailController.text = email;
      _passwordController.text = password;
    } else {
      // Si no se puede obtener email o contraseña, no se hace nada
      await CloudFirestoreService().showSnapMessage(
        context: context,
        message: "No se pudo encontrar un usuario guardado.",
        duration: Duration(seconds: 4),
      );
    }
  }

  

  Future<void> _logIn() async {
    setState(() {});
    if (!_validationService.isValidEmail(_emailController.text)) {
      _alertEmailController.text = 'Correo no validable';
    }
    if (!_validationService.isValidPassword(_passwordController.text)) {
      _alertPasswordController.text = 'Contraseña no validable';
    }

    if (_validationService.isValidEmail(_emailController.text) &&
        _validationService.isValidPassword(_passwordController.text)) {
      try {
        await CloudFirestoreService().logIn(
          context: context,
          email: _emailController.text,
          password: _passwordController.text,
        );
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void cleanFields() {
    _emailController.text = '';
    _passwordController.text = '';
    _alertEmailController.text = '';
    _alertPasswordController.text = '';
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
                const SizedBox(height: 10),
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
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _logIn,
                  child: const Text("Ingresar"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    cleanFields();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterUserScreen(),
                      ),
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
