//import 'dart:io';
//
//import 'package:firebase_admob/firebase_admob.dart';
//import 'package:flutter/material.dart';
//
//class Ads {
//  static bool isShown = false;
//  static bool _isGoingToBeShown = false;
//  static BannerAd _bannerAd;
//
//  static void initialize() {
//    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
//  }
//
//  static void setBannerAd() {
//    _bannerAd = BannerAd(
//      adUnitId: getBannerAdUnitId(),
//      size: AdSize.fullBanner,
//      targetingInfo: _getMobileAdTargetingInfo(),
//      listener: (MobileAdEvent event) {
//        if (event == MobileAdEvent.loaded) {
//          isShown = true;
//          _isGoingToBeShown = false;
//        } else if (event == MobileAdEvent.failedToLoad) {
//          isShown = false;
//          _isGoingToBeShown = false;
//        }
//        print("BannerAd event is $event");
//      },
//    );
//  }
//
//  static void showBannerAd([State state]) {
//
//    if (state != null && !state.mounted) return;
//    if (_bannerAd == null) setBannerAd();
//    if (!isShown && !_isGoingToBeShown) {
//      _isGoingToBeShown = true;
//      _bannerAd
//        ..load()
//        ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
//    }
//  }
//
//  static void hideBannerAd() {
//    if (_bannerAd != null && !_isGoingToBeShown) {
//      _bannerAd.dispose().then((disposed) {
//        isShown = !disposed;
//      });
//      _bannerAd = null;
//    }
//  }
//
//  static void showInterstitialAd() {
//    var interstitialAd = InterstitialAd(
//      adUnitId: InterstitialAd.testAdUnitId,
//      targetingInfo: _getMobileAdTargetingInfo(),
//      listener: (MobileAdEvent event) {
//        print("InterstitialAd event is $event");
//      },
//    );
//    interstitialAd
//      ..load()
//      ..show(anchorOffset: 0.0, anchorType: AnchorType.bottom);
//  }
//
//  static void showRewardedVideoAd() {
//    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//      if (event == RewardedVideoAdEvent.loaded) {
//        RewardedVideoAd.instance.show();
//      }
//    };
//   // RewardedVideoAd.instance.load(adUnitId: getRewardAdUnitId(), targetingInfo: _getMobileAdTargetingInfo());
//  }
//
//  static MobileAdTargetingInfo _getMobileAdTargetingInfo() {
//    return MobileAdTargetingInfo(
//      keywords: <String>['flower', 'identify flower', 'plant', 'tree', 'botany', 'identification key'],
//      contentUrl: 'https://whatsthatflower.com/',
//      childDirected: false,
//      testDevices: <String>["E97A43B66C19A6831DFA72A48E922E5B"],
//    );
//  }
//
//
//  static String getBannerAdUnitId() {
//    if (Platform.isIOS) {
//      return 'ca-app-pub-3940256099942544/2934735716';
//    } else if (Platform.isAndroid) {
//      return 'ca-app-pub-3940256099942544/6300978111';
//    }
//    return null;
//  }
//}