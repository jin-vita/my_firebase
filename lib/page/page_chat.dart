import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase/controller/controller_chat.dart';

import '../controller/controller_push.dart';
import '../controller/controller_user.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('${UserController.to.selectedUser.call()?['name']}님과의 채팅'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              color: Colors.amber.shade50,
              // child: ScrollConfiguration(
              //   behavior: ScrollConfiguration.of(context).copyWith(
              //     dragDevices: {
              //       PointerDeviceKind.touch,
              //       PointerDeviceKind.mouse,
              //     },
              //   ),
              //   child: StreamBuilder(
              //     stream: ChatController.to.chatCollection.snapshots(),
              //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (snapshot.hasData) {
              //         return ListView.separated(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 20,
              //             vertical: 10,
              //           ),
              //           itemCount: snapshot.data!.docs.length,
              //           itemBuilder: (context, index) {
              //             final DocumentSnapshot document =
              //                 snapshot.data!.docs[index];
              //             return GestureDetector(
              //               onTap: () {},
              //               child: Card(
              //                 margin: const EdgeInsets.symmetric(
              //                     horizontal: 16, vertical: 8),
              //                 child: ListTile(
              //                   title: Text(document['name']),
              //                   subtitle: Text(document['email']),
              //                 ),
              //               ),
              //             );
              //           },
              //           separatorBuilder: (context, index) => const SizedBox(
              //             width: 20,
              //           ),
              //         );
              //       }
              //       return const CircularProgressIndicator();
              //     },
              //   ),
              // ),
            )),
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: textController,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final Query myQuery = UserController.to.userCollection
                        .where('email', isEqualTo: UserController.to.auth.currentUser!.email);
                    final QuerySnapshot mySnapshot = await myQuery.get();

                    final query = ChatController.to.chatCollection.where('ids', arrayContains: mySnapshot.docs.first.id)
                        .where('ids', arrayContains: UserController.to.selectedUser.call()?.id);
                    final QuerySnapshot snapshot = await query.get();
                    snapshot.docs.first.id



                    PushController.to.sendFcmMessage(textController.text);
                    textController.text = '';
                  },
                  child: const Text('전송'),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
