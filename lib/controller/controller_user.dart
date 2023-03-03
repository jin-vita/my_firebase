import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    // 구글 로그인 인증을 획득합니다.
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount!.authentication;

    // Firebase 인증 자격 증명을 만듭니다.
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Firebase에 자격 증명을 제출하여 인증합니다.
    final UserCredential authResult =
        await auth.signInWithCredential(credential);

    return authResult.user;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
