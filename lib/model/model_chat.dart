import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String name;
  final String ids;
  final Timestamp updated;

  ChatModel({
    required this.name,
    required this.ids,
    required this.updated,
  });

  factory ChatModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ChatModel(
      name: data?['name'],
      ids: data?['ids'],
      updated: data?['updated'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "ids": ids,
      "updated": updated,
    };
  }
}
