import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_firebase/controller/controller_push.dart';

import '../main.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<User?> signInWithGoogle() async {
    // 구글 로그인 인증 만들기
    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleSignInAccount!.authentication;

    // Firebase 인증 자격 증명 만들기
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Firebase 에 자격 증명을 제출하여 인증
    final UserCredential authResult =
    await auth.signInWithCredential(credential);

    if (authResult.user != null) {
      final user =
      await users.where('email', isEqualTo: auth.currentUser!.email).get();
      log.d(user.docs);
      // 저장된 값이 없으면
      if (user.docs.isEmpty) {
        await users.add({
          'email': auth.currentUser!.email,
          'token': PushController.to.fcmToken,
        });

        // 저장된 값이 있으면
      } else {

      }
    }

    return authResult.user;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
