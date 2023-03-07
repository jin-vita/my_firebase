import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String email;
  late String token;

  UserModel({
    required this.email,
    required this.token,
  });

  UserModel.fromJson(dynamic json) {
    email = json['email'];
    token = json['token'];
  }

  UserModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  UserModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

// 파이어 베이스로 저장 할때 쓴다.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['token'] = token;
    return map;
  }

  factory UserModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data();
    return UserModel(email: data['email'], token: data['token']);
  }
}
