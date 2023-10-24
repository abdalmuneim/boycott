import 'package:boycott_pro/common/constant/const.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdInterstitialWid {
  static AdInterstitialWid instance = _init;
  static final AdInterstitialWid _init = AdInterstitialWid();

  late InterstitialAd interstitialAd;
  bool isAdReady = false;
  bool isAdShowed = false;

  void loadAdInterstitial() {
    InterstitialAd.load(
        adUnitId: Const.androidInterstitialAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            isAdReady = true;
            _showInterstitialAd();
          },
          onAdFailedToLoad: (error) {
            // onCompletedAd;
          },
        ));
  }

  _showInterstitialAd() {
    if (isAdReady) {
      interstitialAd.show();
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          isAdShowed = true;
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          isAdReady = false;
          isAdShowed = false;
          interstitialAd.dispose();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          isAdReady = false;
          ad.dispose();
        },
        onAdImpression: (InterstitialAd ad) {},
      );
    }
  }
}
