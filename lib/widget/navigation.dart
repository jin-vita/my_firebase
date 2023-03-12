import 'package:get/get.dart';

import '../controller/controller_ui.dart';

void navigation(int index) {
  UiController.to.index.value = index;
  switch (index) {
    case 0:
      Get.offNamed('/home');
      break;
    case 1:
      Get.offNamed('/room');
      break;
    default:
      Get.offNamed('/home');
      break;
  }
}
