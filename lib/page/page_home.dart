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
                '로그인한 계정 이메일',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(UserController.to.auth.currentUser!.email!),
              const SizedBox(height: 50),
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
