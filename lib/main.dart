import 'package:boycott_pro/common/services/ad_mod_service.dart';
import 'package:boycott_pro/firebase_options.dart';
import 'package:boycott_pro/features/scan/presentations/scan_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Message id: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebaseRemoteConfig();
  await MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Get.locale?.languageCode != 'ar' ? 'BOYCOTT PRO' : 'مقاطعة',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      locale: Get.deviceLocale,
      home: const ScanPage(),
    );
  }
}
