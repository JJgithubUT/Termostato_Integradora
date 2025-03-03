import 'package:termostato_1/models/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
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

  Future<UserModel?> getRemoteUser() async {
    final localUser = await getLocalUser();
    if (localUser == null) {
      print('No hay usuario local guardado.');
      return null;
    }

    final collection = _mongoService.db.collection('usuarios');

    try {
      final user =
          await collection.findOne(mongo.where.eq('_id', localUser.id));
      if (user == null) {
        print('Usuario remoto no encontrado.');
        return null;
      }
      return UserModel.fromJson(user);
    } catch (e) {
      print('Error al obtener usuario remoto: $e');
      return null;
    }
  }

  Future<UserModel?> logUser(String email, String contrasenia) async {
    final collection = _mongoService.db.collection('usuarios');
    final users = await collection.find().toList();
    print('Usuarios en la base de datos: $users');

    print('Buscando usuario con email: $email');

    final user = await collection.findOne(mongo.where
      .eq('email', email)
      .eq('contrasenia', contrasenia)
      .eq('estado', true));

    print('Usuario encontrado? $user');

    if (user == null) {
      print('Usuario no encontrado o inactivo');
      return null;
    }

    print('Usuario encontrado: ${user['email']}');
    print('Contraseña guardada: ${user['contrasenia']}'); // Añadir este print

    if (user['contrasenia'] != contrasenia) {
      print('Contraseña incorrecta');
      return null;
    }

    print('Contraseña correcta');

    await saveLocalUser(UserModel.fromJson(user));

    print('Usuario guardado localmente');

    return UserModel.fromJson(user);
  }

  Future<UserModel?> registerUser(
      String nombre, String email, String contrasenia) async {
    final collection = _mongoService.db.collection('usuarios');
    final existingUser =
        await collection.findOne(mongo.where.eq('email', email));

    if (existingUser != null) {
      print('Email ya en uso por un usuario activo');
      return null;
    }

    if (nombre == ''|| email == '' || contrasenia == '') {
      print('Campos vacios en registerUser()');
      return null;
    }

    final newUser = UserModel(
      id: mongo.ObjectId(),
      nombre: nombre,
      email: email,
      contrasenia: contrasenia,
      estado: true,
    );

    await collection.insert(newUser.toMap());
    await saveLocalUser(newUser);
    return newUser;
  }

  Future<UserModel?> updateUser(
    mongo.ObjectId id,
    String nombre,
    String email,
    String contrasenia,
  ) async {
    final collection = _mongoService.db.collection('usuarios');
    final user = await collection.findOne(mongo.where.eq('_id', id));

    if (user == null) {
      print('Usuario no encontrado');
      return null;
    }

    if (nombre == '' || email == '' || contrasenia == '') {
      print('Campos vacíos en updateUser()');
      return null;
    }

    // Verificar si el nuevo email ya existe en otro usuario
    if (user['email'] != email) {
      final existingUser =
          await collection.findOne(mongo.where.eq('email', email));
      if (existingUser != null) {
        print('Email ya en uso por otro usuario');
        return null;
      }
    }

    await collection.updateOne(
      mongo.where.eq('_id', id),
      mongo.modify
          .set('nombre', nombre)
          .set('email', email)
          .set('contrasenia', contrasenia)
          .set('estado', true),
    );

    await saveLocalUser(UserModel(
      id: id,
      nombre: nombre,
      email: email,
      contrasenia: contrasenia,
      estado: true,
    ));

    print('Usuario actualizado con éxito: ${user}');

    return UserModel(
      id: id,
      nombre: nombre,
      email: email,
      contrasenia: contrasenia,
      estado: true,
    );
  }

  Future<void> cleanLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.clear();
      print('Datos locales eliminados correctamente.');
    } catch (e) {
      print('Error al limpiar los datos locales: $e');
    }
  }

}
