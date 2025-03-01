import 'package:flutter/material.dart';
import 'package:termostato_1/models/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:termostato_1/screens/login_screen.dart';
import 'package:termostato_1/screens/thermostatus_screen.dart';
import 'package:termostato_1/services/mongo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final MongoService _mongoService = MongoService();

  Future<void> saveLocalUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('idUsuario', user.id.toHexString());
    prefs.setString('nombreUsuario', user.nombre);
    prefs.setString('emailUsuario', user.email);
    prefs.setString('contraseniaUsuario', user.contrasenia);
  }

  Future<UserModel?> getLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('idUsuario');
    final nombre = prefs.getString('nombreUsuario');
    final email = prefs.getString('emailUsuario');
    final contrasenia = prefs.getString('contraseniaUsuario');

    if (id == null || nombre == null || email == null) {
      return null;
    }

    print('Usuario local: $id, $nombre, $email, $contrasenia');

    return UserModel(
      id: mongo.ObjectId.fromHexString(id),
      nombre: nombre,
      email: email,
      contrasenia: contrasenia ?? '',
      estado: true,
    );
  }

  Future<UserModel?> logUser(String email, String contrasenia) async {
    final collection = _mongoService.db.collection('usuarios');
    print('Colección obtenida: $collection');
    final user = await collection.findOne(mongo.where.eq('email', email));
    print('En MongoService: $user');

    if (user == null || user['estado'] == false) {
      print('Usuario no encontrado o inactivo');
      return null; // No damos detalles para evitar ataques de enumeración de usuarios
    }

    if (user['contrasenia'] != contrasenia) {
      print('Contraseña incorrecta');
      return null; // Se recomienda usar hashing en lugar de comparar en texto plano
    }

    if (user['contrasenia'] == contrasenia) {
      print('Contraseña correcta, guardando datos verificados a nivel local');
      await saveLocalUser(UserModel.fromJson(user));
      return UserModel.fromJson(user);
    }
    return UserModel.fromJson(user);
  }

  Future<void> preLogUser(BuildContext context) async {
    UserModel? localDbUser = await getLocalUser();
    if (localDbUser != null) {
      print('Usuario local encontrado: ${localDbUser.nombre}, ${localDbUser.email}, ${localDbUser.contrasenia}');
      UserModel user = logUser(localDbUser.email, localDbUser.contrasenia) as UserModel;
      print('Usuario autenticado: ${user.nombre}');
      // Cambiar a la screen del usuario si fue encontrado en la base de datos local y autenticado en la base de datos remota
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThermostatusScreen()),
        );
      }
    } else {
      // Usuario no encontrado en la base de datos local
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}