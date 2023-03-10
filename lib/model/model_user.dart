import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String token;

  UserModel({
    required this.name,
    required this.email,
    required this.token,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      name: data?['name'],
      email: data?['email'],
      token: data?['token'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "email": email,
      "token": token,
    };
  }
}
