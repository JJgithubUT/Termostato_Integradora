import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:termostato_2/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CloudFirestoreService _instance =
      CloudFirestoreService._internal();

  final FirebaseFirestore _cloudFireStore = FirebaseFirestore.instance;

  factory CloudFirestoreService() {
    return _instance;
  }

  CloudFirestoreService._internal();

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

  ///// Registrate /////

  Future<void> signup({
    required BuildContext context,
    required String email,
    required String password,
    required String nombre,
  }) async {
    try {
      // Crear usuario en Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Enviar correo de verificación
        await user.sendEmailVerification(); ///????????????????????????

        // Crear objeto de usuario
        UserModel newUser = UserModel(
          id: user.uid,
          nombre: nombre,
          contrasenia: password,
          email: email,
        );

        // Guardar el usuario en Firestore
        await _cloudFireStore.collection('usuarios').add(newUser.toMap());

        await _showSnapMessage(
          // ignore: use_build_context_synchronously
          context: context,
          message: "Usuario registrado con éxito",
          duration: Duration(seconds: 10),
          color: Colors.green,
        );

        // Mostrar en consola si esta registrado el usuario
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            print('CloudFirestoreService - signup() || User is currently signed out!');
          } else {
            print('CloudFirestoreService - signup() || User is signed in!');
            print('${ user }');
          }
        });

        // Cerrar la pantalla de registro después del éxito en el registro
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String msg = '';
      if (e.code == 'weak-password') {
        msg = 'La contraseña proporcionada es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        msg = 'Ya existe una cuenta con ese correo.';
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        msg = 'Error: ${e.message}';
        //print('Error: ${e.message}');
      }
      await _showSnapMessage(
        // ignore: use_build_context_synchronously
        context: context, // ← Pasar el contexto aquí también
        message: msg,
        duration: Duration(seconds: 10),
      );
    }
  }
}
