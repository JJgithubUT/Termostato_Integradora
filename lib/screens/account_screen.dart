import 'package:flutter/material.dart';
import 'package:termostato_2/models/user_model.dart';
import 'package:termostato_2/screens/thermostatus_screen.dart';
import 'package:termostato_2/services/validation_service.dart';
import 'package:termostato_2/widgets/themes.dart';
import 'package:termostato_2/services/cloud_firestore_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ignore: prefer_final_fields
  String _nombreUsuarioTitulo = '';
  bool _obscureText = true;
  UserModel? _user;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getRemoteUser();
  }

  Future<void> _getRemoteUser() async {
    _user = await CloudFirestoreService().getRemoteUser();

    if (_user != null) {
      _idController.text = _user?.id ?? '';
      _nameController.text = _user?.nombre ?? '';
      _emailController.text = _user?.email ?? '';
      _passwordController.text = _user?.contrasenia ?? '';
      setState(() {
        _nombreUsuarioTitulo = _nameController.text;
      });
    }
  }

  Future<void> _updateUser() async {
    try {
      // Lógica de la actualización
      if (_nameController.text != '' &&
          _emailController.text != '' &&
          _passwordController.text != '' &&
          ValidationService().isValidName(_nameController.text) &&
          ValidationService().isValidEmail(_emailController.text) &&
          ValidationService().isValidPassword(_passwordController.text)
          ) {
        // Si los datos a enviar no son nulos, continuar
        final userToUpdate = UserModel(
          id: _user!.id,
          nombre: _nameController.text,
          email: _emailController.text,
          contrasenia: _passwordController.text,
        );

        await CloudFirestoreService().updateUser(userToUpdate, context);
      } else {
        _showSnackBar('Campos no validos.');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('StateError: ', '');
      });
      _showSnackBar('Error al actualizar el usuario.');
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

  Future<void> _logOut() async {
    CloudFirestoreService().logOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 75, 59, 113),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 75, 59, 113),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    /* CircleAvatar( // Aquí tendría que ir el logo de la app
                      radius: 50,
                      backgroundImage: AssetImage('https://static.vecteezy.com/system/resources/previews/018/754/507/original/thermometer-icon-in-gradient-colors-temperature-signs-illustration-png.png'),
                    ), */
                    Text(
                      'Termostato',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
              /* ListTile(
                title: const Text(
                  'Termostato',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ), */
              ListTile(
                title: const Text(
                  'Termostato',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Navegar a la siguiente pantalla
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThermostatusScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _logOut();
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 50, 110),
        /* leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ), */
        title: const Text('Mi cuenta', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_nombreUsuarioTitulo, style: loginTitleStyle),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: inputLabelStyle,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 158, 158, 158),
                    labelText: 'Email',
                    labelStyle: inputLabelStyle,
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
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
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 9, 50, 110),
                  ),
                  onPressed: () {
                    _updateUser();
                  },
                  child: const Text('Guardar'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 36, 36),
                  ),
                  onPressed: () {
                    /* Navigator.pop(context);
                    Navigator.pop(context); */
                  },
                  child: const Text('Cancelar'),
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
