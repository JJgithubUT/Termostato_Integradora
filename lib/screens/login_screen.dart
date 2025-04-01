import 'package:flutter/material.dart';
import 'package:termostato_2/screens/register_user_screen.dart';
import 'package:termostato_2/services/cloud_firestore_service.dart';
import 'package:termostato_2/services/validation_service.dart';
/* import '../widgets/themes.dart'; */

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
    // ignore: avoid_print
    print('Estamos ahora en Login Screen');
    var localUser = await CloudFirestoreService().getLocalUser();

    if (localUser == null) {
      // ignore: avoid_print
      print('Usuario local nulo');
      return;
    }

    // ignore: avoid_print
    print(localUser['emailUsuario']);

    String? email = localUser['emailUsuario'];
    String? password = localUser['contraseniaUsuario'];

    if (email != null && password != null) {
      // Si hay datos de usuario guardados, intentar iniciar sesión automáticamente
      // ignore: use_build_context_synchronously
      await CloudFirestoreService().logIn(context: context, email: email, password: password);
      _emailController.text = email;
      _passwordController.text = password;
    } else {
      // Si no se puede obtener email o contraseña, no se hace nada
      await CloudFirestoreService().showSnapMessage(
        // ignore: use_build_context_synchronously
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
                color: Color(0xFF59A5D8), // Azul claro
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
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
                    "Climatic",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF91E5F6), // Azul brillante
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF91E5F6),
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
                    onPressed: _logIn,
                    child: const Text(
                      "Ingresar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),


                  /* TextButton(
                    onPressed: () {
                      cleanFields();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterUserScreen(),
                        ),
                      );
                    }, // Navegación a registro
                    child: const Text(
                      "Registrate",
                      style: TextStyle(color: Color(0xFF59A5D8)),
                    ),
                  ), */


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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterUserScreen(),
                        ),
                      );
                    }, // Navegación al login
                    child: const Text(
                      "Registrate",
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
