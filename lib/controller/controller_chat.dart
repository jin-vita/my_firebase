import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_user.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat');

  Future createChat() async {
    final Query query = chatCollection
        .where('ids', arrayContains: UserController.to.user.id)
        .where('ids', arrayContains: UserController.to.selectedUser.id);
    final QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      chatCollection.add({
        'name': '채팅',
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      });
    }
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
// Future<List<ChatMessage>> getChatMessages(String chatId) async {
//   final snapshot = await getCachedQuery('chats/$chatId/messages');
//   final messages = snapshot.docs
//       .map((doc) => ChatMessage.fromFirestore(doc))
//       .toList();
//
//   return messages;
// }
}
