import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  @override
  void onInit() {
    _initNotification();
    super.onInit();
  }

  void _initNotification() {}
}
