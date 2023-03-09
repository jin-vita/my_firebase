import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_firebase/controller/controller_user.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인 하는 곳'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text('환영합니다! 테스트 앱입니다'),
            const SizedBox(height: 20),
            const Text('구글로 로그인할 수 있습니다'),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () async {
                final user = await UserController.to.signInWithGoogle();
                if (user != null) {
                  Get.toNamed('/auth');
                }
              },
              child: const Text('구글 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
