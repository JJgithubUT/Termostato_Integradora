import 'package:flutter/material.dart';
import 'package:termostato_1/models/user_model.dart';
import 'package:termostato_1/screens/login_screen.dart';
import 'package:termostato_1/services/user_service.dart';
import 'package:termostato_1/widgets/themes.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _nombreUsuarioTitulo = '';
  bool _obscureText = true;
  UserModel? _user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Aquí se obtiene el usuario local y se muestra en los campos de texto
    UserService().getLocalUser().then((user) {
      if (user != null) {
        print('Usuario local encontrado: ${user.nombre}');
        setState(() {
          _user = user;
          _nameController.text = user.nombre;
          _emailController.text = user.email;
          _passwordController.text = user.contrasenia;
        });
        _nombreUsuarioTitulo = user.nombre;
      }
    });
  }

  Future<void> _updateUser() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      // Lógica de la actualización
      if (_nameController.text != '' &&
          _emailController.text != '' &&
          _passwordController.text != '') {
        // Si los datos a enviar no son nulos, continuar
        final user = UserModel(
          id: _user!.id,
          nombre: _nameController.text.trim(),
          email: _emailController.text.trim(),
          contrasenia: _passwordController.text.trim(),
          estado: true,
        );

        await UserService().updateUser(
          user.id,
          user.nombre,
          user.email,
          user.contrasenia,
        );
        _showSnackBar('Usuario actualizado correctamente.');
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        _showSnackBar('Campos vacios.');
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
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  UserService().cleanLocalUser();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
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
        title: const Text(
          'Mi cuenta',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          decoration: backgroundDecoration,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _nombreUsuarioTitulo,
                    style: loginTitleStyle,
                  ),
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
                      Navigator.pop(context);
                      Navigator.pop(context);
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
          )),
    );
  }
}
