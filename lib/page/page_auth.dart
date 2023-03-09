import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase/controller/controller_user.dart';
import 'package:my_firebase/page/page_home.dart';
import 'package:my_firebase/page/page_login.dart';

import '../main.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return Builder(builder: (context) {
            logger.w(
                'LoginPage - name : ${snapshot.data!.displayName}, email : ${snapshot.data!.email}');
            UserController.to.initId(snapshot.data!.email);
            return const HomePage();
          });
        }
        return const LoginPage();
      },
    );
  }
}
