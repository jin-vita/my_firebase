import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: StreamBuilder(
                  stream: Get.arguments
                      .collection('message')
                      .orderBy('created_at', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          // DateTime dateTime = document['created_at'].toDate();
                          // String formattedDateTime =
                          //     DateFormat('HH:mm').format(dateTime);
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              color: document['sender'] ==
                                      UserController.to.user['name']
                                  ? Colors.amber.shade50
                                  : Colors.white,
                              margin: document['sender'] ==
                                      UserController.to.user['name']
                                  ? const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 50, right: 5)
                                  : const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 5, right: 50),
                              child: ListTile(
                                title: Text(document['text']),
                                // subtitle: Text(formattedDateTime),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 20,
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: textController,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  await Get.arguments.collection('message').add({
                    'sender': UserController.to.user['name'],
                    'created_at': FieldValue.serverTimestamp(),
                    'text': textController.text,
                  });
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
    );
  }
}
