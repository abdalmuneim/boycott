// Just setup Firebase remote config
import 'dart:convert';

import 'package:boycott_pro/common/constant/const.dart';
import 'package:boycott_pro/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/*
  // Rewarded Ads from Firebase Remote Config
  final AppRewardedAd rewardedAd = AppRewardedAd.fromKey(
    configKey: 'rewarded_ad'
  );

 
  // Rewarded Interstitial Ads from Firebase Remote Config
  final AppRewardedInterstitialAd rewardedInterstitialAd = AppRewardedInterstitialAd.fromKey(
    configKey: 'rewarded_interstitial_ad'
  );
*/

Future<void> setupFirebaseRemoteConfig() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 10),
  ));
  await remoteConfig.setDefaults(_defaultAdmobConfig);
}

final Map<String, dynamic> _defaultAdmobConfig = {
  'banner_ad': jsonEncode({
    "enable": true,
    "ad_unit_id_android": Const.androidAdBanner,
    "ad_unit_id_ios": Const.iosAdBanner,
    "position": null,
    "distance": null,
    "width": 300,
    "height": 250
  }),
  'interstitial_ad': jsonEncode({
    "enable": true,
    "ad_unit_id_android": Const.androidInterstitialAd,
    "ad_unit_id_ios": Const.iosInterstitialAd,
    "request_time_to_show": 3,
    "fail_time_to_stop": 3,
    "init_request_time": 0
  }),
  'rewarded_ad': jsonEncode({
    "enable": true,
    "ad_unit_id_android": "ca-app-pub-3940256099942544/5224354917",
    "ad_unit_id_ios": "ca-app-pub-3940256099942544/1712485313",
  }),
  'rewarded_interstitial_ad': jsonEncode({
    "enable": true,
    "ad_unit_id_android": "ca-app-pub-3940256099942544/5354046379",
    "ad_unit_id_ios": "ca-app-pub-3940256099942544/6978759866",
  })
};
