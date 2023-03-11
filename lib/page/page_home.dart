import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_ui.dart';
import 'package:my_firebase/controller/controller_user.dart';
import 'package:my_firebase/main.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:scroll_bottom_navigation_bar/scroll_bottom_navigation_bar.dart';

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
        await UserController.to.userCollection
            .doc(UserController.to.user.id)
            .update({
          'token': 'logout',
        });
        await UserController.to.signOutGoogle();
        Get.offAllNamed('/auth');
      },
    );
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(
        controller: controller,
        title:
            Text('${UserController.to.auth.currentUser!.displayName}님의 친구 목록'),
      ),
      body: WillPopScope(
        onWillPop: () {
          return exit(context);
        },
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  UserController.to.selectedUser = UserController.to.user;
                  ChatController.to.createChatRoom();
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
                      // .where('name',
                      //     isNotEqualTo: UserController.to.user['name'])
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
                            onTap: () async {
                              UserController.to.selectedUser = document;
                              ChatController.to.createChatRoom();
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
        () => ScrollBottomNavigationBar(
          controller: controller,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bubble_chart),
              label: 'chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.social_distance),
              label: 'social',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'setting',
            ),
          ],
          currentIndex: UiController.to.index.value,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey.shade200,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            UiController.to.index.value = index;
            logger.i('선택 탭 : $index');
          },
        ),
      ),
    );
  }

  Widget buildBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return HomePage();
      case 1:
        return HomePage();
      case 2:
        return HomePage();
      default:
        return Container();
    }
  }
}
