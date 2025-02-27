import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:termostato_1/models/user_model.dart';


class MongoService {
  // Servicio para conectar con MongoDB Atlas
  // Usando Singleton
  static final MongoService _instance = MongoService._internal();

  late mongo.Db _db;

  MongoService._internal();

  factory MongoService() {
    return _instance;
  }

  Future<void> connect() async {
    try {
      _db = await mongo.Db.create(
          'mongodb+srv://juanjcbreton:a08qUo04kyvinweT@cluster0.owwpb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
      await _db.open();
      _db.databaseName = 'basetermostato';
      print('Conexión a MongoDB establecida.');
    } on SocketException catch (e) {
      print('Error de conexión: $e');
      rethrow;
    }
  }

  mongo.Db get db {
    if (!_db.isConnected) {
      throw StateError('DB no inicializada, llamar a connect()');
    }
    return _db;
  }

  Future<UserModel?> logUser(String email, String contrasenia) async {
    final collection = _db.collection('usuarios');
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
      print('Contraseña correcta');
      return UserModel.fromJson(user);
    }
    return UserModel.fromJson(user);
  }

  void close() {
    _db.close();
  }
}
