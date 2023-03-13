import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_firebase/controller/controller_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();
  late SharedPreferences prefs;

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat');

  @override
  void onInit() {
    initSharedPreferences();
    super.onInit();
  }

  Future initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<DocumentSnapshot> setSelected(String chatRoomId) async {
    String selectedId = chatRoomId
        .replaceAll(UserController.to.user.id, '')
        .replaceAll('_', '');
    DocumentSnapshot selected =
        await UserController.to.userCollection.doc(selectedId).get();
    return selected;
  }

  Future createChatRoom(DocumentSnapshot selected) async {
    UserController.to.selectedUser = selected;
    List ids = [
      UserController.to.user.id,
      selected.id,
    ];
    ids.sort((a, b) => a.compareTo(b));
    String chatRoomId = ids.join('_');
    final chatDocument = ChatController.to.chatCollection.doc(chatRoomId);
    DocumentSnapshot chatSnapshot = await chatDocument.get();
    if (!chatSnapshot.exists) {
      await chatDocument.set({
        'name':
            '${UserController.to.user['name']}${UserController.to.selectedUser['name']}',
        'photo':
            '${UserController.to.user['photo']}${UserController.to.selectedUser['photo']}',
        'ids': ids,
        'message': '아직 대화가 없어요',
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    }
    Get.toNamed('/chat', arguments: [
      chatRoomId,
      selected['name'],
      selected.id,
    ]);
  }

  Future createMessage({
    required String chatRoomId,
    required String text,
  }) async {
    await chatCollection.doc(chatRoomId).collection('message').add({
      'sender': UserController.to.user['name'],
      'created_at': FieldValue.serverTimestamp(),
      'text': text,
    });
    final chatDocument = ChatController.to.chatCollection.doc(chatRoomId);
    await chatDocument.update({
      'message': text,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future saveMessageList(String chatRoomId) async {
    QuerySnapshot messageQuerySnapshot = await ChatController.to.chatCollection
        .doc(chatRoomId)
        .collection('message')
        .orderBy('created_at', descending: true)
        .limit(10)
        .get();

    List<String> messageList = [];
    for (var element in messageQuerySnapshot.docs) {
      Map<String, dynamic> map = {};
      map['sender'] = element['sender'];
      map['created_at'] =
          DateFormat('MM/dd HH:mm').format(element['created_at'].toDate());
      map['text'] = element['text'];
      messageList.add(jsonEncode(map));
    }
    // logger.e(messageList);
    prefs.setStringList(chatRoomId, messageList);
  }
}
