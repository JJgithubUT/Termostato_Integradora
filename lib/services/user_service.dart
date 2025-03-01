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

  Future<UserModel?> registerUser(String nombre, String email, String contrasenia) async {
    final collection = _mongoService.db.collection('usuarios');
    final user = await collection.findOne(mongo.where.eq('email', email));

    if (user != null) {
      print('Usuario ya registrado');
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

}