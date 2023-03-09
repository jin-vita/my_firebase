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

  Future getMessages() async {}
}
