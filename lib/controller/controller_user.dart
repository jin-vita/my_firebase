import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_firebase/controller/controller_push.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  // selected user
  final selectedUser = Rx<DocumentSnapshot?>(null);

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
      final Query query =
          userCollection.where('email', isEqualTo: auth.currentUser!.email);
      final QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        await userCollection.add({
          'name': auth.currentUser!.displayName,
          'email': auth.currentUser!.email,
          'token': PushController.to.myToken,
        });
      } else {
        userCollection.doc(snapshot.docs.first.id).update({
          'name': auth.currentUser!.displayName,
          'token': PushController.to.myToken,
        });

        // cast to UserModel
        // final QuerySnapshot<UserModel> userCastSnap = await query
        //     .withConverter(
        //       fromFirestore: UserModel.fromFirestore,
        //       toFirestore: (UserModel user, _) => user.toFirestore(),
        //     )
        //     .get();
        // UserModel user = userCastSnap.docs.first.data();
        // logger.i('userModel name : ${user.name}');
      }
    }

    return authResult.user;
  }

  Future<void> signOutGoogle() async {
    selectedUser.value = null;
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
