import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_user.dart';

import '../controller/controller_push.dart';
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
    // CollectionReference aaa = FirebaseFirestore.instance.collection('user');
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
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                '수신한 푸시 메시지 내용',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                final message = PushController.to.myMessage.value.notification;
                String text = '수신된 메시지가 없습니다.';
                if (message != null) {
                  text = message.body ?? '수신된 메시지가 없습니다';
                }
                return Text(text);
              }),
              const SizedBox(height: 50),
              const Text(
                '등록된 유저 리스트',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 200,
                child: StreamBuilder(
                  stream: UserController.to.userCollection.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(document['name']),
                              subtitle: Text(document['email']),
                            ),
                          );
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              const Text(
                '보낼 푸시 메시지 내용',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: textController,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  PushController.to.sendFcmMessage(textController.text);
                  textController.text = '';
                },
                child: const Text('푸시 전송'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
