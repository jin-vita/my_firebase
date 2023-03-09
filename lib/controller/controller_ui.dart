import 'package:get/get.dart';

class UiController extends GetxController {
  static UiController get to => Get.find();

  Rx<int> index = RxInt(0);
}
