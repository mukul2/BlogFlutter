import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'listViewData.dart';

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}
double iconSize = 40;
var pageOne = Scaffold(
    body: Stack(
  children: <Widget>[
    Positioned(
      bottom: 00.0,
      child: AdmobBanner(
        adUnitId: getBannerAdUnitId(),
        adSize: AdmobBannerSize.FULL_BANNER,
      ),
    ),
    Positioned(
      top: 00.0,
      left: 10.0,
      right: 10.0,
      bottom: 60.0,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("This is sample text for page one"),
            Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Nazrul.jpg/220px-Nazrul.jpg",
                width: 120,
                height: 120,
                fit: BoxFit.fill),
            Text("This is an image of kazi nazrul islam"),
          ],
        ),
      ),
    )
  ],
));
var pageTwo = Scaffold(
    body: Stack(
      children: <Widget>[
        Positioned(
          bottom: 00.0,
          child: AdmobBanner(
            adUnitId: getBannerAdUnitId(),
            adSize: AdmobBannerSize.FULL_BANNER,
          ),
        ),
        Positioned(
          top: 00.0,
          left: 10.0,
          right: 10.0,
          bottom: 60.0,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("This is sample text for page two"),
                Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Nazrul.jpg/220px-Nazrul.jpg",
                    width: 120,
                    height: 120,
                    fit: BoxFit.fill),
               Padding(
                 padding: EdgeInsets.all(15),
                 child:  Table(
                   border: TableBorder.all(),
                   columnWidths: {0: FractionColumnWidth(.4), 1: FractionColumnWidth(.2), 2: FractionColumnWidth(.4)},
                   children: [
                     TableRow( children: [
                       Column(children:[
                         Icon(Icons.account_box, size: iconSize,),
                         Text('My Account')
                       ]),
                       Column(children:[
                         Icon(Icons.settings, size: iconSize,),
                         Text('Settings')
                       ]),
                       Column(children:[
                         Icon(Icons.lightbulb_outline, size: iconSize,),
                         Text('Ideas')
                       ]),
                     ]),
                     TableRow( children: [
                       Icon(Icons.cake, size: iconSize,),
                       Icon(Icons.voice_chat, size: iconSize,),
                       Icon(Icons.add_location, size: iconSize,),
                     ]),
                   ],

                 ),
               ),

                Text("This is an image of kazi nazrul islam"),
              ],
            ),
          ),
        )
      ],
    ));

