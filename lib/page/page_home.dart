import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_notification.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('firebase cloud message'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              final message =
                  NotificationController.to.myMessage.value.notification;
              String text = '수신된 메시지가 없습니다.';
              if (message != null) {
                text = message.body ?? '수신된 메시지가 없습니다';
              }
              return Text(text);
            }),
            const SizedBox(height: 30),
            Container(
              width: 200,
              child: TextField(
                textAlign: TextAlign.center,
                controller: textController,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                NotificationController.to.sendFcmMessage(textController.text);
                textController.text = '';
              },
              child: const Text('푸시 전송'),
            ),
          ],
        ),
      ),
    );
  }
}
