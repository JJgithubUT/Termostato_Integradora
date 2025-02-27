import 'package:mongo_dart/mongo_dart.dart' as mongo;

class UserModel {
  final mongo.ObjectId id;
  String nombre;
  String contrasenia;
  String email;
  bool estado;

  UserModel({
    required this.id,
    required this.nombre,
    required this.contrasenia,
    required this.email,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'nombre': nombre,
      'contrasenia': contrasenia,
      'email': email,
      'estado': estado,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var id = json['_id'];
    if (id is String) {
      try {
        id = mongo.ObjectId.fromHexString(id);
      } catch (e) {
        id = mongo.ObjectId();
      }
    } else if (id is! mongo.ObjectId) {
      id = mongo.ObjectId();
    }
    return UserModel(
      id: id as mongo.ObjectId,
      nombre: json['nombre'] as String,
      contrasenia: json['contrasenia'] as String,
      email: json['email'] as String,
      estado: json['estado'] as bool,
    );
  }

}