import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    _initNotification();
    _getToken();
    super.onInit();
  }

  Future<void> _getToken() async {
    final token = _messaging.getToken();
    print('token : $token');
  }

  void _initNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      print('Message data : $event');
    });
  }
}
