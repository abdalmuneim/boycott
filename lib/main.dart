import 'package:boycott_pro/common/services/ad_mod_service.dart';
import 'package:boycott_pro/features/scan/presentations/scan_page.dart';
import 'package:boycott_pro/generated/l10n.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Message id: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebaseRemoteConfig();
  await MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (
      BuildContext context,
      Orientation orientation,
      DeviceType deviceType,
    ) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: Get.locale?.languageCode != 'ar' ? 'BOYCOTT PRO' : 'قاطع',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: Get.deviceLocale,
        home: const ScanPage(),
      );
    });
  }
}
