import 'dart:developer';

import 'package:boycott_pro/const.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdInterstitialWid {
  static AdInterstitialWid instance = _init;
  static final AdInterstitialWid _init = AdInterstitialWid();

  static late InterstitialAd _interstitialAd;
  static bool _isRAdReady = false;

  void loadAdInterstitial() {
    InterstitialAd.load(
        adUnitId: Const.interstitialAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isRAdReady = true;
            _showInterstitialAd();
          },
          onAdFailedToLoad: (error) {
            // onCompletedAd;
            log('ad is failed to load: ${error.message}');
          },
        ));
  }

  _showInterstitialAd() {
    if (_isRAdReady) {
      _interstitialAd.show();
      _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          log('%ad onAdShowedFullScreenContent.');
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          log('$ad onAdDismissedFullScreenContent.');
          _interstitialAd.dispose();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
        },
        onAdImpression: (InterstitialAd ad) => log('$ad impression occurred.'),
      );
    }
  }
}
