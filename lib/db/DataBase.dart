import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  static final boardDB = FirebaseFirestore.instance.collection("Board");
}
