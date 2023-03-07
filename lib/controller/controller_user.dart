import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_firebase/controller/controller_push.dart';
import 'package:my_firebase/model/model_user.dart';

import '../main.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

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

    // 로그인이 되었을 때
    if (authResult.user != null) {
      // search user by email from firestore
      final Query userQuery =
          userCollection.where('email', isEqualTo: auth.currentUser!.email);
      final QuerySnapshot userSnap = await userQuery.get();

      if (userSnap.docs.isEmpty) {
        await userCollection.add({
          'email': auth.currentUser!.email,
          'token': PushController.to.fcmToken,
        });
      } else {
        userCollection.doc(userSnap.docs.first.id).update({
          'token': PushController.to.fcmToken,
        });

        // cast to UserModel
        final QuerySnapshot<UserModel> userCastSnap = await userQuery
            .withConverter(
              fromFirestore: UserModel.fromFirestore,
              toFirestore: (UserModel user, _) => user.toFirestore(),
            )
            .get();
        UserModel user = userCastSnap.docs.first.data();
        log.i('userModel email : ${user.email}');
        log.i('userSnap : ${userSnap.docs.first.data()}');
      }
    }

    return authResult.user;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
