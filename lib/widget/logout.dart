import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller_user.dart';
import '../util/util.dart';

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
