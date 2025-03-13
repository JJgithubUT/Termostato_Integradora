import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:termostato_2/models/user_model.dart';

class CloudFirestoreService {
  static final CloudFirestoreService _instance = CloudFirestoreService._internal();

  factory CloudFirestoreService() {
    return _instance;
  }

  CloudFirestoreService._internal();
}