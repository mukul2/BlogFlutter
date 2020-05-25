//import 'dart:async';
//import 'dart:io';
//
//import 'package:firebase_admob/firebase_admob.dart';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
//import 'package:path_provider/path_provider.dart';
//InterstitialAd _interstitialAd;
//class OnlinePDFScreen extends StatelessWidget {
//  String pathPDF = "";
//  OnlinePDFScreen(this.pathPDF);
//  InterstitialAd createInterstitialAd() {
//    return InterstitialAd(
//      adUnitId: InterstitialAd.testAdUnitId,
//
//      listener: (MobileAdEvent event) {
//        print("InterstitialAd event $event");
//
//      },
//    );
//  }
//  @override
//  Widget build(BuildContext context) {
//    _interstitialAd?.dispose();
//    _interstitialAd = createInterstitialAd()..load();
//    Future<bool> _onWillPop() async {
//      return (await showDialog(
//        context: context,
//        builder: (context) =>
//        new AlertDialog(
//          title: new Text('Are you sure?'),
//          content: new Text('Do you want to exit an App'),
//          actions: <Widget>[
//            new FlatButton(
//              onPressed: () => Navigator.of(context).pop(false),
//              child: new Text('No'),
//            ),
//            new FlatButton(
//              onPressed: () {
//
//                _interstitialAd?.show();
//                Navigator.of(context).pop(true);
//              },
//              child: new Text('Yes'),
//            ),
//          ],
//        ),
//      )) ??
//          false;
//    }
//    return WillPopScope(
//        onWillPop: _onWillPop,
//        child: Scaffold(
//          appBar: AppBar(
//            title: Text("Description"),
//          ),
//          body: PDFViewerScaffold(
//              appBar: AppBar(
//                title: Text("Document"),
//                actions: <Widget>[
//                  IconButton(
//                    icon: Icon(Icons.share),
//                    onPressed: () {},
//                  ),
//                ],
//              ),
//              path: pathPDF)
//        ));
//  }
//}
//
