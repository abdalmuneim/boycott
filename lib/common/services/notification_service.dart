import 'dart:convert';
import 'package:boycott_pro/common/constant/const.dart';
import 'package:boycott_pro/features/scan/presentations/scan_page.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationService {
  requestPermission();
  Future<String?>? getFCMToken();
  initInfo();
  Future<void> pushNotification({
    required List<String> deviceTokens,
    required String body,
    required String title,
    required Map<String, dynamic> data,
  });
}

class NotificationServiceImpl implements NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  NotificationServiceImpl() {
    requestPermission();
    initInfo();
  }

  @override
  requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      carPlay: false,
      badge: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }

  @override
  Future<String?>? getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  @override
  initInfo() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initializationSettings =
        const InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        try {
          if (details.payload != null) {
          } else {
            Get.offAll(const ScanPage());
          }
        } catch (e) {
          Get.offAll(const ScanPage());
        }
        return;
      },
    );

    /// firebase massaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        contentTitle: message.notification!.title,
        htmlFormatContentTitle: true,
        htmlFormatBigText: true,
        summaryText: message.notification!.body,
        htmlFormatSummaryText: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'notification',
        'notification',
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification'),
        fullScreenIntent: true,
        enableLights: true,
        audioAttributesUsage: AudioAttributesUsage.voiceCommunication,
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: message.data["data"],
      );
    });
  }

  @override
  Future<void> pushNotification({
    required List<String> deviceTokens,
    required String body,
    required String title,
    required Map<String, dynamic> data,
  }) async {
    final List<Future<void>> futures = [];

    for (String token in deviceTokens) {
      futures.add(_sendNotification(token, title, body, data));
    }

    await Future.wait(futures);
  }

  Future<void> _sendNotification(String token, String title, String body,
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${Const.serverFCMKey}',
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
            'data': data,
          },
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'android_channel_id': 'notification',
            'ios_channel_id': 'notification',
          },
          'to': token,
        },
      ),
    );

    if (response.statusCode == 200) {
    } else {}
  }
}
