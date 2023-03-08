import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_user.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();

  final CollectionReference chatCollection =
  FirebaseFirestore.instance.collection('chat');

  Future createChat() async {
    final Query myQuery = UserController.to.userCollection
        .where('email', isEqualTo: UserController.to.auth.currentUser!.email);
    final QuerySnapshot mySnapshot = await myQuery.get();

    final Query query = chatCollection
        .where('ids', arrayContains: mySnapshot.docs.first.id)
        .where('ids', arrayContains: UserController.to.selectedUser
        .call()
        ?.id);
    final QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      chatCollection.add({
        'ids': '${mySnapshot.docs.first.id},${UserController.to.selectedUser}',
        'name': '${UserController.to.selectedUser.call()?['name']}님 과의 채팅',
        'is_group': false,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      });
    }
  }

  Future getMessages() async {

  }
}
