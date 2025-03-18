// Librerías para encriptar
import 'package:termostato_2/models/device_model.dart';
import 'package:termostato_2/services/cifrado_service.dart';
//import 'package:bcrypt/bcrypt.dart';
// Librerías normales
import 'package:flutter/material.dart';
// Cloud service
import 'package:cloud_firestore/cloud_firestore.dart';
// Clase usuario
import 'package:termostato_2/models/user_model.dart';
// Autentiación de firebase
import 'package:firebase_auth/firebase_auth.dart';
// Almacenamiento local
import 'package:shared_preferences/shared_preferences.dart';
// Screen de termostato
import 'package:termostato_2/screens/thermostatus_screen.dart';

class CloudFirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CloudFirestoreService _instance =
      CloudFirestoreService._internal();

  final FirebaseFirestore _cloudFireStore = FirebaseFirestore.instance;

  factory CloudFirestoreService() {
    return _instance;
  }

  CloudFirestoreService._internal();

  /// -----------------
  ///// Funciones complementarias /////
  /// -----------------

  Future<void> saveLocalUser({
    required String email,
    required String password,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('emailUsuario', email);
    prefs.setString('contraseniaUsuario', password);
  }

  Future<Map<String, String>?> getLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('emailUsuario');
    final contrasenia = prefs.getString('contraseniaUsuario');

    if (contrasenia == null || email == null) {
      return null;
    }

    // ignore: avoid_print
    print('Usuario local: $email, $contrasenia');

    // Devolver mapa del usuario local cencontrado
    return {'emailUsuario': email, 'contraseniaUsuario': contrasenia};
  }

  Future<UserModel?> getRemoteUser() async {
    var localUser = await getLocalUser();
    if (localUser == null) {
      // ignore: avoid_print
      print('No hay usuario local guardado.');
      return null;
    }

    try {
      final querySnapshot =
          await _cloudFireStore
              .collection('usuarios')
              .where('email_usu', isEqualTo: localUser['emailUsuario'])
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        // ignore: avoid_print
        print('Usuario remoto no encontrado.');
        return null;
      }

      final userData = querySnapshot.docs.first.data();

      final remoteUser = UserModel(
        id: userData['id'] as String,
        nombre: userData['nombre_usu'] as String,
        email: userData['email_usu'] as String,
        contrasenia: userData['contrasenia_usu'] as String,
      );

      return remoteUser;
    } catch (e) {
      // ignore: avoid_print
      print('Error al obtener usuario remoto: $e');
      return null;
    }
  }

  Future<void> _showSnapMessage({
    required BuildContext context,
    required String message,
    required Duration duration,
    Color color = Colors.redAccent,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: duration,
      ),
    );
  }

  /// -----------------
  ///// Servicios /////
  /// -----------------

  ///// Dispositivos /////

  Future<void> insertDevice(DeviceModel device) async {
    await _cloudFireStore.collection('dispositivos').add(device.toMap());
  }

  Stream<DeviceModel?> getDeviceStream() {
    // Obtener el usuario autenticado
    User? user = _auth.currentUser;
    if (user == null) {
      // Si no hay usuario autenticado, retornamos un stream vacío
      return Stream.value(null);
    }

    // Escuchar los cambios en los dispositivos del usuario
    return _cloudFireStore
        .collection('dispositivos')
        .where('correo_usu', isEqualTo: user.email)
        .limit(1)
        .snapshots() // Aquí usamos snapshots para escuchar cambios en tiempo real
        .map((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            // Si hay dispositivos, retornamos el primer dispositivo
            return DeviceModel.fromDocumentSnapshot(querySnapshot.docs.first);
          } else {
            // Si no hay dispositivos, retornamos null
            return null;
          }
        });
  }

  ///// Usuarios /////

  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String nombre,
  }) async {
    try {
      // Encriptación de contraseña
      String hashedPassword = AESHelper.encryptPassword(password);

      // ------------------------------------
      // Envío de datos a la base de datos
      // ------------------------------------

      // Crear usuario en Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: hashedPassword,
          );

      User? user = userCredential.user;

      if (user != null) {
        // Enviar correo de verificación (solo si no está verificado)
        if (!user.emailVerified) {
          // ignore: avoid_print
          print('Enviando correo de verificación a: ${user.email}');
          await user.sendEmailVerification();
          // ignore: avoid_print
          print('Correo de verificación enviado.');
        }

        // Crear objeto de usuario
        UserModel newUser = UserModel(
          id: user.uid,
          nombre: nombre,
          contrasenia: hashedPassword,
          email: email,
        );

        // ignore: avoid_print
        print(hashedPassword);

        // Guardar otros datos del usuario en Firestore Database
        await _cloudFireStore.collection('usuarios').add(newUser.toMap());

        // Guardar nuevo dispositivo asignado al usuario registrado
        await insertDevice(
          DeviceModel(
            id: '',
            codigo: '¿Código?',
            correo: email,
            estado: false,
            nombre: '',
            tempActual: 0,
            tempObjetivo: 0,
          ),
        );

        // Mostrar mensaje
        if (context.mounted) {
          await _showSnapMessage(
            context: context,
            message:
                "Usuario registrado con éxito. Verifique su correo electrónico.",
            duration: Duration(seconds: 10),
            color: Colors.green,
          );

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      String msg = '';
      if (e.code == 'weak-password') {
        msg = 'La contraseña proporcionada es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        msg = 'Ya existe una cuenta con ese correo.';
        if (context.mounted) Navigator.pop(context);
      } else {
        msg = 'Error: ${e.message}';
      }
      if (context.mounted) {
        await _showSnapMessage(
          context: context,
          message: msg,
          duration: Duration(seconds: 10),
        );
      }
    }
  }

  Future<void> logIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // Encriptar contraseña para comparar con la remota

      String hashedPassword = AESHelper.encryptPassword(password);

      // Autenticar con Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: hashedPassword,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Verificar si el correo está confirmado
        if (!user.emailVerified) {
          await _showSnapMessage(
            // ignore: use_build_context_synchronously
            context: context,
            message: "Por favor, verifica tu correo antes de iniciar sesión.",
            duration: Duration(seconds: 5),
            color: Colors.orange,
          );
          return;
        }

        // Obtener los datos del usuario desde Firestore
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await _cloudFireStore
                .collection('usuarios')
                .where('email_usu', isEqualTo: email)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Convertir a UserModel
          UserModel loggedUser = UserModel.fromDocumentSnapshot(
            querySnapshot.docs.first,
          );

          // Mostrar mensaje de éxito
          await _showSnapMessage(
            // ignore: use_build_context_synchronously
            context: context,
            message: "Bienvenido, ${loggedUser.nombre}!",
            duration: Duration(seconds: 3),
            color: Colors.green,
          );

          // Guardar localmente el usuario
          saveLocalUser(email: email, password: password);

          // Navegar a la siguiente pantalla
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => ThermostatusScreen()),
          );
        } else {
          await _showSnapMessage(
            // ignore: use_build_context_synchronously
            context: context,
            message: "Error: No se encontraron datos del usuario.",
            duration: Duration(seconds: 5),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String msg = '';
      if (e.code == 'user-not-found') {
        msg = 'No existe una cuenta con este correo.';
      } else if (e.code == 'wrong-password') {
        msg = 'Contraseña incorrecta.';
      } else {
        msg = 'Error: ${e.message}';
      }

      await _showSnapMessage(
        // ignore: use_build_context_synchronously
        context: context,
        message: msg,
        duration: Duration(seconds: 5),
      );
    }
  }

  /* Future<void> autoLogIn() async {
    final remoteUser = getRemoteUser();
    if (remoteUser != null) {
      
    }
  } */
}
