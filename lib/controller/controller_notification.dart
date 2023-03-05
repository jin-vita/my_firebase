import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:my_firebase/util/util.dart';

import '../main.dart';

class NotificationController extends GetxController {
  // for easy to use
  static NotificationController get to => Get.find();

  // FCM instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // received message
  Rx<RemoteMessage> myMessage = const RemoteMessage().obs;

  // FCM token from FCM instance
  late String fcmToken;

  // FCM project id from google_key.json file
  late String projectId;

  @override
  void onInit() {
    initNotification();
    getToken();
    onMessage();
    setupInteractedMessage();
    super.onInit();
  }

  // check permissions
  Future<void> initNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log.i('User granted permission : ${settings.authorizationStatus}');
  }

  // generate FCM token
  Future<void> getToken() async {
    fcmToken = await messaging.getToken() ?? '토큰 가져오기 실패';
    log.i('token : $fcmToken');
  }

  // check received FCM message
  Future<void> onMessage() async {
    var channel = const AndroidNotificationChannel(
      'flutter_firebase_channel',
      'Flutter Firebase Notifications',
      description: 'This channel is used for flutterFirebase notifications.',
      importance: Importance.high,
    );

    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        log.i('message: ${message.notification?.body}');
        myMessage.value = message;
        // 웹??
        Util.showSnackBar(message: message.notification?.body);
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          'FCM 수신',
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(
              badgeNumber: 1,
              subtitle: 'the subtitle',
              sound: 'slow_spring_board.aiff',
            ),
          ),
        );

        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('firebase');
        const DarwinInitializationSettings initializationSettingsIOS =
            DarwinInitializationSettings();
        const InitializationSettings initializationSettings =
            InitializationSettings(
                android: initializationSettingsAndroid,
                iOS: initializationSettingsIOS);

        flutterLocalNotificationsPlugin.initialize(initializationSettings,
            onDidReceiveNotificationResponse: (NotificationResponse payload) {
          Get.toNamed('/menu', arguments: payload);
        });
      }
    });
  }

  // background FCM message click action
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
    if (initialMessage != null) handleMessage(initialMessage);

    // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  void handleMessage(RemoteMessage message) {
    log.w('background message : ${message.notification?.body}');
    myMessage.value = message;
    // if (message.data['type'] == 'chat') {
    //   Get.toNamed('/chat', arguments: message.data);
    // }
  }

  Future<String> getGoogleOAuth2Token() async {
    final String jsonString =
        await rootBundle.loadString('assets/google_key.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    projectId = json['project_id'];
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(json);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client =
        await clientViaServiceAccount(serviceAccountCredentials, scopes);
    final accessCredentials = client.credentials.accessToken;
    return accessCredentials.data;
  }

  Future<void> sendFcmMessage(String text) async {
    Dio dio = Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getGoogleOAuth2Token()}',
    };

    Map<String, dynamic> message = {
      'message': {
        'token': fcmToken,
        'notification': {
          'body': text,
        },
      },
    };

    final response = await dio.post(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
        data: message);
    log.w('response : ${response.data}');
  }
}
