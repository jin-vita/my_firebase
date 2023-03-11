import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/controller_chat.dart';
import '../controller/controller_push.dart';
import '../controller/controller_user.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PushController.to.isChatPage = true;
    final textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('${Get.arguments[1]}님과의 채팅'),
      ),
      body: WillPopScope(
        onWillPop: () {
          PushController.to.isChatPage = false;
          return Future.value(true);
        },
        child: Column(
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
                    stream: ChatController.to.chatCollection
                        .doc(Get.arguments[0])
                        .collection('message')
                        .orderBy('created_at', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        DefaultCacheManager()
                            .getSingleFile('url', key: Get.arguments[0]);
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
                            DateTime dateTime = document['created_at'] != null
                                ? document['created_at'].toDate()
                                : DateTime.now();
                            String formattedDateTime =
                                DateFormat('HH:mm').format(dateTime);
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
                                        top: 5, bottom: 5, left: 60, right: 5)
                                    : const EdgeInsets.only(
                                        top: 5, bottom: 5, left: 5, right: 60),
                                child: ListTile(
                                  title: Text(
                                      '${document['text']} $formattedDateTime'),
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
                      return const Center(child: CircularProgressIndicator());
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
                  onPressed: () {
                    String text = textController.text;
                    textController.text = '';
                    ChatController.to.createMessage(
                      chatRoomId: Get.arguments[0],
                      text: text,
                    );
                    PushController.to.sendFcmMessage(
                      text: text,
                      chatId: Get.arguments[0],
                      sender: UserController.to.user['name'],
                      userDocumentId: Get.arguments[2],
                    );
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
