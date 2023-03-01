import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/controller_notification.dart';
import 'firebase_options.dart';
import 'page/page_home.dart';

// flutter pub add get
// flutter pub add firebase_core
// flutter pub add firebase_auth
// flutter pub add firebase_database
// flutter pub add firebase_messaging
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(NotificationController());
      }),
      home: const HomePage(),
    );
  }
}
