import 'package:flutter/material.dart';
import 'package:termostato_2/models/user_model.dart';
import 'package:termostato_2/screens/thermostatus_screen.dart';
import 'package:termostato_2/services/validation_service.dart';
//import 'package:termostato_2/widgets/themes.dart';
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
          ValidationService().isValidPassword(_passwordController.text)) {
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
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF133C55), Color(0xFF386FA4)],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Climatic',
                    style: TextStyle(
                      color: Color(0xFF91E5F6),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Text(
                  'Termostato',
                  style: TextStyle(color: Color(0xFF84D2F6)),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThermostatusScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 255, 104, 99),
                ),
                title: Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Color.fromARGB(255, 255, 104, 99)),
                ),
                onTap: _logOut,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF133C55),
        title: Text('Mi cuenta', style: TextStyle(color: Color(0xFF91E5F6))),
        iconTheme: IconThemeData(
          color: Color(0xFF91E5F6), // Cambia el color del ícono aquí.
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF133C55), Color(0xFF386FA4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF59A5D8),
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
                    _nombreUsuarioTitulo.isNotEmpty
                        ? "¡Hola, $_nombreUsuarioTitulo!"
                        : "Bienvenido a Climatic",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF91E5F6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(color: Color(0xFF84D2F6)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Color(0xFF84D2F6)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
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
                    obscureText: _obscureText,
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
                    onPressed: _updateUser,
                    child: Text(
                      "Guardar",
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
                      // Mantenemos la lógica original
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThermostatusScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (_errorMessage != null) const SizedBox(height: 10),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
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
