import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:my_firebase/controller/controller_chat.dart';
import 'package:my_firebase/controller/controller_ui.dart';

import 'controller/controller_push.dart';
import 'controller/controller_user.dart';
import 'firebase_options.dart';
import 'page/page_auth.dart';
import 'page/page_chat.dart';
import 'page/page_home.dart';
import 'page/page_menu.dart';

// flutter pub add get
// flutter pub add dio
// flutter pub add intl
// flutter pub add http
// flutter pub add logger
// flutter pub add firebase_core
// flutter pub add firebase_auth
// flutter pub add scroll_app_bar
// flutter pub add google_sign_in
// flutter pub add googleapis_auth
// flutter pub add cloud_firestore
// flutter pub add firebase_database
// flutter pub add firebase_messaging
// flutter pub add cached_network_image
// flutter pub add flutter_local_notifications
// flutter pub add scroll_bottom_navigation_bar

final logger = Logger();
final controller = ScrollController();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logger.i("background message : ${message.notification?.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(PushController());
        Get.put(UserController());
        Get.put(ChatController());
        Get.put(UiController());
      }),
      initialRoute: '/auth',
      getPages: [
        GetPage(
          name: '/auth',
          page: () => const AuthPage(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
        ),
        GetPage(
          name: '/chat',
          page: () => const ChatPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/menu',
          page: () => const MenuPage(),
        ),
      ],
    );
  }
}
