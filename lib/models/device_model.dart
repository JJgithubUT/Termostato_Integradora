import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final String id;
  final String correo;
  final bool estado;
  final String nombre;
  final double tempActual;
  final double tempObjetivo;

  DeviceModel({
    required this.id,
    required this.correo,
    required this.estado,
    required this.nombre,
    required this.tempActual,
    required this.tempObjetivo,
  });

  // Convertir un Dispositivo a un Mapa
  Map<String, dynamic> toMap() {
    return {
      'correo_usu': correo,
      'estado_dis': estado,
      'nombre_dis': nombre,
      'temp_actual_dis': tempActual,
      'temp_objetivo_dis': tempObjetivo,
    };
  }

  factory DeviceModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return DeviceModel(
      id: doc.id,
      correo: doc['correo_usu'],
      estado: doc['estado_dis'],
      nombre: doc['nombre_dis'],
      tempActual: doc['temp_actual_dis'],
      tempObjetivo: doc['temp_objetivo_dis']
    );
  }

}