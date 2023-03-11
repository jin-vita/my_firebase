import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_user.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat');

  Future createChatRoom() async {
    List ids = [
      UserController.to.user.id,
      UserController.to.selectedUser.id,
    ];
    ids.sort((a, b) => a.compareTo(b));
    String chatId = ids.join('_');
    final chatDocument = ChatController.to.chatCollection.doc(chatId);
    DocumentSnapshot chatSnapshot = await chatDocument.get();
    chatSnapshot.exists
        ? await chatDocument.update({
            'updated_at': FieldValue.serverTimestamp(),
          })
        : await chatDocument.set({
            'created_at': FieldValue.serverTimestamp(),
            'updated_at': FieldValue.serverTimestamp(),
          });
    Get.toNamed('/chat', arguments: [
      chatId,
      UserController.to.selectedUser['name'],
      UserController.to.selectedUser.id,
    ]);
  }

  Future createMessage(
      {required String chatRoomId, required String text}) async {
    await chatCollection.doc(chatRoomId).collection('message').add({
      'sender': UserController.to.user['name'],
      'created_at': FieldValue.serverTimestamp(),
      'text': text,
    });
  }

// Future<QuerySnapshot> getCachedQuery(String collection) async {
//   final cacheManager = await CacheManager.getInstance();
//   final file = await cacheManager.getFileFromCache(collection);
//
//   if (file != null && file.existsSync()) {
//     final data = file.readAsStringSync();
//     return QuerySnapshot.fromSnapshot(json.decode(data));
//   } else {
//     final query = FirebaseFirestore.instance.collection(collection);
//     final snapshot = await query.get();
//     await cacheManager.putFileInCache(
//         collection, json.encode(snapshot.data()));
//     return snapshot;
//   }
// }
//
//   Future<List<ChatMessage>> getChatMessages(String chatId) async {
//     final snapshot = await getCachedQuery('chats/$chatId/messages');
//     final messages =
//         snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
//
//     return messages;
//   }
}
