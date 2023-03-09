import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_user.dart';

import '../controller/controller_chat.dart';
import '../util/util.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<bool> exit(BuildContext context) {
    Util.showYesNoDialog(
      title: '로그아웃 할까요?',
      noText: '아니오',
      onNoPressed: () => Get.back(),
      yesText: '예',
      onYesPressed: () async {
        await UserController.to.signOutGoogle();
        Get.offAllNamed('/auth');
      },
    );
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    UserController.to.initId();
    final textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${UserController.to.auth.currentUser!.displayName}님 환영합니다!'),
      ),
      body: WillPopScope(
        onWillPop: () {
          return exit(context);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade200,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(top: 15),
                child: StreamBuilder(
                  stream: UserController.to.userCollection
                      .where('token', isNotEqualTo: 'init')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () async {
                              UserController.to.selectedUser.value = document;
                              List ids = [
                                UserController.to.user.id,
                                document.id
                              ];
                              ids.sort((a, b) => a.compareTo(b));
                              String chatId = ids.join('_');
                              final chatDocument =
                                  ChatController.to.chatCollection.doc(chatId);
                              await chatDocument.set({
                                'name': '테스트채팅방??',
                                'created_at': FieldValue.serverTimestamp(),
                                'updated_at': FieldValue.serverTimestamp(),
                              });
                              // await chatDocument.collection('message').add({
                              //   'sender': UserController.to.user['name'],
                              //   'created_at': FieldValue.serverTimestamp(),
                              //   'text': '안녕?',
                              // });

                              Get.toNamed('/chat', arguments: chatDocument);
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(document['name']),
                                subtitle: Text(document['email']),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
