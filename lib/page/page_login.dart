import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_user.dart';

import '../main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login page'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text('환영합니다!'),
            const SizedBox(height: 20),
            const Text('구글로 로그인해주세요'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                final user = await UserController.to.signInWithGoogle();
                if (user != null) {
                  log.w(
                      'user name : ${user.displayName}, user email : ${user.email}');
                }
                Get.offAllNamed('/auth');
              },
              child: const Text('구글 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
