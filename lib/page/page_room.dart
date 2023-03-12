import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import '../controller/controller_chat.dart';
import '../controller/controller_ui.dart';
import '../controller/controller_user.dart';
import '../main.dart';
import '../widget/logout.dart';
import '../widget/navigation.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(
        controller: controller,
        title: const Text('대화'),
      ),
      body: WillPopScope(
        onWillPop: () => exit(context),
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder(
                  stream: ChatController.to.chatCollection
                      .where('ids', arrayContains: UserController.to.user.id)
                      // .orderBy('updated_at')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 20,
                        ),
                        controller: controller,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          if (snapshot.data!.docs.isEmpty) {
                            return const Text('대화가 없어요!');
                          }
                          return GestureDetector(
                            onTap: () async {
                              final selected = document['ids'][0] !=
                                          UserController.to.user.id ||
                                      document['ids'][1] !=
                                          UserController.to.user.id
                                  ? await ChatController.to
                                      .setSelected(document.id)
                                  : UserController.to.user;
                              ChatController.to.createChatRoom(selected);
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  document['ids'][0] !=
                                              UserController.to.user.id ||
                                          document['ids'][1] !=
                                              UserController.to.user.id
                                      ? document['photo'].replaceAll(
                                          UserController.to.user['photo'], '')
                                      : UserController.to.user['photo'],
                                ),
                              ),
                              title: Text(document['ids'][0] !=
                                          UserController.to.user.id ||
                                      document['ids'][1] !=
                                          UserController.to.user.id
                                  ? document['name'].replaceAll(
                                      UserController.to.user['name'], '')
                                  : UserController.to.user['name']),
                              subtitle: Text(
                                  '${DateFormat('MM/dd HH:mm').format(document['updated_at'].toDate())}   ${document['message']}'),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          // controller: controller,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '친구',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bubble_chart),
              label: '대화',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.social_distance),
              label: '일상',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '설정',
            ),
          ],
          currentIndex: UiController.to.index.value,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey.shade200,
          unselectedItemColor: Colors.grey,
          onTap: (index) => navigation(index),
        ),
      ),
    );
  }
}
