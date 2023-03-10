import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_ui.dart';
import 'package:my_firebase/controller/controller_user.dart';
import 'package:my_firebase/main.dart';
import 'package:my_firebase/widget/navigation.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import '../controller/controller_chat.dart';
import '../widget/logout.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(
        controller: controller,
        title: const Text('친구'),
      ),
      body: WillPopScope(
        onWillPop: () => exit(context),
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  ChatController.to.createChatRoom(UserController.to.user);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      UserController.to.auth.currentUser!.photoURL!,
                    ),
                    // backgroundImage: NetworkImage(
                    //     UserController.to.auth.currentUser!.photoURL!),
                  ),
                  title: Text(
                      '${UserController.to.auth.currentUser!.displayName} ✔'),
                  subtitle: Text(UserController.to.auth.currentUser!.email!),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                color: Colors.grey.shade200,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder(
                  stream: UserController.to.userCollection
                      // .where('__name__',
                      //     isNotEqualTo: UserController.to.user.id)
                      .orderBy('name')
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
                          return GestureDetector(
                            onTap: () {
                              ChatController.to.createChatRoom(document);
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  document['photo'],
                                ),
                                // backgroundImage:
                                //     NetworkImage(document['photo']),
                              ),
                              title: Text(document['name']),
                              subtitle: Text(document['email']),
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
