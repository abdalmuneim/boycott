import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static final FirebaseCollections _init = FirebaseCollections();
  static FirebaseCollections instance = _init;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get addProductFR =>
      _firestore.collection("New Products");
}
