import 'dart:developer';

import 'package:boycott_pro/const.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({Key? key}) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  bool _isLoad = false;
  late BannerAd _bannerAd;
  final AdSize _adSize = AdSize.banner;

  @override
  void initState() {
    super.initState();
    _createBanner();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  void _createBanner() {
    _bannerAd = BannerAd(
      size: _adSize,
      adUnitId: Const.adBanner,
      listener: BannerAdListener(
          onAdLoaded: (ad) => setState(
                () {
                  _isLoad = true;
                },
              ),
          onAdFailedToLoad: (ad, error) {
            log('ad load failed --> ${error.message}');
          }),
      request: const AdRequest(),
    );
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoad) {
      return Container(
        width: _adSize.width.toDouble(),
        height: _adSize.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd),
      );
    } else {
      return Container();
    }
  }
}
