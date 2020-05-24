import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:kobita/passData.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async' show Future;
import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:kobita/passData.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:io';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

//import 'dart:html';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kobita/AppAllData.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'AnotherMusicPlayer.dart';
import 'CategoryActivity.dart';
import 'CustomBodyModel.dart';
import 'FullPDFViewerOnline.dart';
import 'MyAudioPlayer.dart';
import 'MyMusicPLayer.dart';
import 'OnlinePDFScreen.dart';
import 'customweb.dart';
import 'myAd.dart';

void main() {
  Admob.initialize(getAppId());
  runApp(MyApp());
}

InterstitialAd _interstitialAd;

int CLICK_COUNTER = 0;
int SHOW_AD_AFTER = 200;
var isLoading = true;
bool doINeedDownload = true;
bool doIHaveDownloadPermission = false;
bool didPassedFirstTest = false;

var isPDFLoading = false;
var isPDFLocal = true;
var selectedSecondayCatID;
var selectedOwnCatID;
String fileData;
AdmobInterstitial interstitialAd;
AppAllData appAllDataCached;
List<Collections> secondLevelContents = new List();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'My Blog Application'),
    );
  }
}

Future<String> _loadAsset() async {
  isLoading = true;
  fileData = await rootBundle.loadString('assets/data.json');
  return fileData;
}

Future<String> _loadAssetFromNet() async {
  isLoading = true;
  var url = 'http://appointmentbd.com/other-project/kobita11.php';

  // Await the http get response, then decode the json-formatted response.

  var response = await http.get(url);
  //showThisToast(response.body.toString());
  fileData = response.body;
  return response.body;
}

Future<AppAllData> loadProjectData() async {
  String jsonString = await _loadAsset();
  final jsonResponse = json.decode(jsonString);
  AppAllData data = new AppAllData.fromJson(jsonResponse);
  appAllDataCached = data;
  return data;
}

Future<List<Categories>> loadCategories() async {
  List<Categories> firstLevelCategory = new List();
  AppAllData appAllData = await loadProjectData();
  isLoading = false;
  for (var i = 0; i < appAllData.categories.length; i++) {
    if (appAllData.categories[i].parentId == 0) {
      firstLevelCategory.add(appAllData.categories[i]);
    }
  }
  return firstLevelCategory;
}

Future<myRetrivedData> loadSecondaryCategories() async {
  isLoading = true;
  List<Categories> secondLevelCategory_ = new List();
  List<Collections> secondLevelContents_ = new List();
  AppAllData appAllData = appAllDataCached;

  for (var i = 0; i < appAllData.categories.length; i++) {
    if (appAllData.categories[i].parentId == selectedSecondayCatID) {
      secondLevelCategory_.add(appAllData.categories[i]);
    }
  }
  if (secondLevelCategory_.length == 0) {
    //   showThisToast("No category, searching for contents");
    for (var i = 0; i < appAllData.collections.length; i++) {
      if (appAllData.collections[i].categoryId == selectedSecondayCatID) {
        secondLevelContents_.add(appAllData.collections[i]);
      }
    }
  }

  bool ty = true;
  if (secondLevelCategory_.length > 0) {
    ty = true;
  } else {
    ty = false;
  }

  myRetrivedData data = new myRetrivedData(
      categories: secondLevelCategory_,
      collections: secondLevelContents_,
      isCategory: ty);
  isLoading = false;
  return data;
}

createPostList(id) async {
  secondLevelContents.clear();
  AppAllData appAllData = await loadProjectData();
  for (var i = 0; i < appAllData.collections.length; i++) {
    if (appAllData.collections[i].categoryId == id) {
      secondLevelContents.add(appAllData.collections[i]);
    }
  }
}

void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    Ads.hideBannerAd();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    Ads.initialize();
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        //handleEvent(event, args, 'Interstitial');
      },
    );

    //  _bannerAd = _createBannerAd();
//    RewardedVideoAd.instance.listener =
//        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//      print("RewardedVideoAd event $event");
//      if (event == RewardedVideoAdEvent.rewarded) {
//        setState(() {});
//      }
//    };
  }

  @override
  Widget build(BuildContext context) {
    //   _bannerAd ??= _createBannerAd();
    //   showBannerAd(context);
    //  Ads.setBannerAd();
    //  Ads.showBannerAd();
    return Scaffold(
      body: new GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainActivity()),
        ),
        child: new Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AdmobBanner(
              adUnitId: getBannerAdUnitId(),
              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: new Card(
                color: Colors.blue,
                child: new Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: ListTile(
                    leading: Icon(
                      Icons.description,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Start Application',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Ads.hideBannerAd();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainActivity()),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

Widget SplashScreen(context) {
  return Center(
    child: RaisedButton(onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainActivity()));
    }),
  );
}

Widget downlaodAndShowPDF(String link, BuildContext context) {
  return FutureBuilder(
    builder: (context, projectSnap) {
      return isPDFLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PDFViewerScaffold(
              appBar: AppBar(
                title: Text("Document"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                ],
              ),
              path: projectSnap.data);
    },
    future: isPDFLocal ? copyAsset(link) : createFileOfPdfUrl(link, context),
  );
}

Widget projectWidget() {
  return FutureBuilder(
    builder: (context, projectSnap) {
      return isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 60,
                    child: GridView.builder(
                      itemCount: projectSnap.data.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        Categories categories = projectSnap.data[index];
                        bool isImageLive = false;
                        String localPath =
                            "assets/android_asset/apps/offline/image.png";
                        if (categories.iconUrl != null) {
                          if (categories.iconUrl.toString().contains("http")) {
                            isImageLive = true;
                          } else {
                            if (categories.iconUrl
                                .toString()
                                .contains("assets:")) {
                              localPath = categories.iconUrl
                                  .toString()
                                  .replaceRange(0, 8, '');
                              localPath = "assets/android_asset" + localPath;
                            }
                          }
                        } else {
                          localPath =
                              "assets/android_asset/apps/offline/image.png";
                        }

                        return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          child: InkResponse(
                              onTap: () {
                                handleInsAddEvent();
                                selectedSecondayCatID = categories.id;
                                selectedOwnCatID = categories.id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SecondActivity(
                                          text: categories.title)),
                                );
                              },
                              child: new Center(
                                child: new Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: isImageLive
                                          ? Image.network(categories.iconUrl,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.fill)
                                          : Image.asset(localPath,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.fill),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 8, 8, 0),
                                        child: Text(categories.title,
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              )),
                        );
                      },
                    )),
                Positioned(
                  bottom: 00.0,
                  child: AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: AdmobBannerSize.FULL_BANNER,
                  ),
                )
              ],
            );
    },
    future: loadCategories(),
  );
}

Widget secondLevelWidget() {
  return FutureBuilder(
    builder: (context, projectSnap) {
      return false
          ? Center(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                      child: new Center(
                          child: Text(
                        "Do you want to download this file?",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink),
                      ))),
                  new Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new FlatButton(
                          onPressed: () {},
                          child: new Text('No'),
                        ),
                        new FlatButton(
                          onPressed: () {},
                          child: new Text('Yes'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          : (projectSnap.data.isCategory
              ? Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      bottom: 60.0,
                      child: GridView.builder(
                        itemCount: projectSnap.data.isCategory
                            ? projectSnap.data.categories.length
                            : projectSnap.data.collections.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          // Categories categories = projectSnap.data.categories[index];
                          // Collections collections = projectSnap.data.collections[index];

                          Categories categories =
                              projectSnap.data.categories[index];
                          bool isImageLive = false;
                          String localPath =
                              "assets/android_asset/apps/offline/image.png";
                          if (categories.iconUrl != null) {
                            if (categories.iconUrl
                                .toString()
                                .contains("http")) {
                              isImageLive = true;
                            } else {
                              if (categories.iconUrl
                                  .toString()
                                  .contains("assets:")) {
                                localPath = categories.iconUrl
                                    .toString()
                                    .replaceRange(0, 8, '');
                                localPath = "assets/android_asset" + localPath;
                              }
                            }
                          } else {
                            localPath =
                                "assets/android_asset/apps/offline/image.png";
                          }

                          return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            child: InkResponse(
                                onTap: () {
                                  handleInsAddEvent();
                                  selectedSecondayCatID =
                                      projectSnap.data.categories[index].id;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SecondActivity(
                                            text: projectSnap
                                                .data.categories[index].title)),
                                  );
                                },
                                child: new Center(
                                  child: new Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: isImageLive
                                            ? Image.network(categories.iconUrl,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.fill)
                                            : Image.asset(localPath,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.fill),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 8, 8, 0),
                                          child: Text(
                                              projectSnap
                                                  .data.categories[index].title,
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 00.0,
                      child: AdmobBanner(
                        adUnitId: getBannerAdUnitId(),
                        adSize: AdmobBannerSize.FULL_BANNER,
                      ),
                    )
                  ],
                )
              : (true
                  ? (projectSnap.data.collections[0].description
                          .toString()
                          .contains("<!DOCTYPE html>")
                      ? (projectSnap.data.collections[0].answer != null
                          ? (new Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 0.0,
                                  left: 15.0,
                                  right: 15.0,
                                  bottom: 100.0,

                                  child: Html(
                                    data: prepareHTMLData(projectSnap
                                        .data.collections[0].description
                                        .toString()),

                                  ),
                                ),
                                Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: new Column(
                                      children: <Widget>[
                                        FutureBuilder(
                                          builder: (context, projectSnap_bool) {
                                            return (!didPassedFirstTest)
                                                ? Center(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10),
                                                  child: Text(
                                                    "Answer file not downloaded",
                                                    style: TextStyle(
                                                        color: Colors.pink,
                                                        fontSize: 17),
                                                  ),
                                                ))
                                                : FutureBuilder(
                                              builder:
                                                  (context, projectSnap_) {
                                                return isDownloading
                                                    ? Center(

                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                        EdgeInsets
                                                            .fromLTRB(
                                                            0,
                                                            0,
                                                            0,
                                                            10),
                                                        child: Text(
                                                          "Please wait while your file downlaods",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .pink,
                                                              fontSize:
                                                              17),
                                                        ),
                                                      ),
                                                      CircularProgressIndicator(
                                                          backgroundColor:
                                                          Colors
                                                              .amber)
                                                    ],
                                                  ), )
                                                    : AudioApp(
                                                    serverIP:
                                                    projectSnap_
                                                        .data
                                                        .toString());
                                              },
                                              future: createFileAnyHow(
                                                  projectSnap
                                                      .data
                                                      .collections[0]
                                                      .answer
                                                      .toString(),
                                                  context),
                                            );
                                          },
                                          future: checkIfFileAvailable(
                                              projectSnap
                                                  .data.collections[0].answer
                                                  .toString(),
                                              context),
                                        ),
                                        AdmobBanner(
                                          adUnitId: getBannerAdUnitId(),
                                          adSize: AdmobBannerSize.FULL_BANNER,
                                        )
                                      ],
                                    )),
                              ],
                            ))
                          : new Scaffold(
          body: new SingleChildScrollView(

            child: Html(
              data: prepareHTMLData(projectSnap
                  .data.collections[0].description
                  .toString()),

            ),
          )))
                      : (projectSnap.data.collections[0].description
                              .toString()
                              .endsWith(".pdf")
                          ? (Stack(
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
                                  child: FutureBuilder(
                                    builder: (context, projectSnap_bool) {
                                      return (!didPassedFirstTest)
                                          ? Center(
                                              child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              child: Text(
                                                "File is not downloaded.Please grant download permission",
                                                style: TextStyle(
                                                    color: Colors.pink,
                                                    fontSize: 17),
                                              ),
                                            ))
                                          : FutureBuilder(
                                              builder: (context, projectSnap_) {
                                                return isDownloading //check is the file needs to to be downloaded
                                                    ? Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          10),
                                                              child: Text(
                                                                "Please wait while your file downlaods",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .pink,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ),
                                                            CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Colors
                                                                        .amber)
                                                          ],
                                                        ),
                                                      )
                                                    : PDFViewerScaffold(
                                                        path:
                                                            projectSnap_.data);
                                              },
                                              future: createFileAnyHow(
                                                  projectSnap
                                                      .data
                                                      .collections[0]
                                                      .description
                                                      .toString(),
                                                  context),
                                            );
                                    },
                                    future: checkIfFileAvailable(
                                        projectSnap
                                            .data.collections[0].description
                                            .toString(),
                                        context),
                                  ),
                                )
                              ],
                            ))
                          : (projectSnap.data.collections[0].description
                                  .toString()
                                  .endsWith(".mp3")
                              ? (Stack(
                                  children: <Widget>[
                                    Positioned(

                                      left: 0.0,
                                      right: 0.0,
                                      bottom: 30.0,
                                      child: FutureBuilder(
                                        builder: (context, projectSnap_bool) {
                                          return (!didPassedFirstTest)
                                              ? Center(
                                                  child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10),
                                                  child: Text(
                                                    "File is not downloaded.Please grant download permission",
                                                    style: TextStyle(
                                                        color: Colors.pink,
                                                        fontSize: 17),
                                                  ),
                                                ))
                                              : FutureBuilder(
                                                  builder:
                                                      (context, projectSnap_) {
                                                    return isDownloading
                                                        ? Center(

                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                            EdgeInsets
                                                                .fromLTRB(
                                                                0,
                                                                0,
                                                                0,
                                                                10),
                                                            child: Text(
                                                              "Please wait while your file downlaods",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .pink,
                                                                  fontSize:
                                                                  17),
                                                            ),
                                                          ),
                                                          CircularProgressIndicator(
                                                              backgroundColor:
                                                              Colors
                                                                  .amber)
                                                        ],
                                                      ), )
                                                        : AudioApp(
                                                            serverIP:
                                                                projectSnap_
                                                                    .data
                                                                    .toString());
                                                  },
                                                  future: createFileAnyHow(
                                                      projectSnap
                                                          .data
                                                          .collections[0]
                                                          .description
                                                          .toString(),
                                                      context),
                                                );
                                        },
                                        future: checkIfFileAvailable(
                                            projectSnap
                                                .data.collections[0].description
                                                .toString(),
                                            context),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: AdmobBanner(
                                        adUnitId: getBannerAdUnitId(),
                                        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                                      ),
                                    )
                                  ],
                                ))
                              : createCustomLayout(projectSnap.data.collections[0].description.toString(),projectSnap.data.collections[0].answer,context))))
                  : Text("File Not available")));
    },
    future: loadSecondaryCategories(),
  );
}

Widget createCustomLayout(String string, answer,BuildContext context) {
  var commentWidgets = List<Widget>();
  //List<Widget> widgetList = [];
  List<CustomBodyModel> allObjecs = [];
  final jsonResponse = json.decode(string);
  for(Map i in jsonResponse){
  if(  CustomBodyModel.fromJson(i).type.contains("Text")){
    commentWidgets.add(new Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Text(CustomBodyModel.fromJson(i).body),
    ));
  }else  if(  CustomBodyModel.fromJson(i).type.contains("img")){
    commentWidgets.add(new Padding(
      padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
      child: Image.network(CustomBodyModel.fromJson(i).body ,fit: BoxFit.fill),
    ));
  }

  }
  if(answer!=null){
    String audioFile = answer.toString();
    Widget audioPlayer = createAnAudioView(audioFile,context);
    commentWidgets.add(audioPlayer);
  }


  SingleChildScrollView s =new SingleChildScrollView(
    child: Column(
      children:commentWidgets,

    ),
  );

  return s;
}

Widget createAnAudioView(String audioFile,BuildContext context) {
  return FutureBuilder(
    builder: (context, projectSnap_bool) {
      return (!didPassedFirstTest)
          ? Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                10, 10, 10, 10),
            child: Text(
              "Answer file not downloaded",
              style: TextStyle(
                  color: Colors.pink,
                  fontSize: 17),
            ),
          ))
          : FutureBuilder(
        builder:
            (context, projectSnap_) {
          return isDownloading
              ? Center(

            child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .center,
              crossAxisAlignment:
              CrossAxisAlignment
                  .center,
              children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets
                      .fromLTRB(
                      0,
                      0,
                      0,
                      10),
                  child: Text(
                    "Please wait while your file downlaods",
                    style: TextStyle(
                        color: Colors
                            .pink,
                        fontSize:
                        17),
                  ),
                ),
                CircularProgressIndicator(
                    backgroundColor:
                    Colors
                        .amber)
              ],
            ), )
              : AudioApp(
              serverIP:
              projectSnap_
                  .data
                  .toString());
        },
        future: createFileAnyHow(
            audioFile,
            context),
      );
    },
    future: checkIfFileAvailable(
        audioFile,
        context),
  );
}

String  prepareHTMLData(String string) {
  return string.replaceAll("\n", "");
}

Future<void> handleInsAddEvent() async {
  CLICK_COUNTER++;

  if (CLICK_COUNTER % SHOW_AD_AFTER == 0) {
    interstitialAd.load();
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    } else {
      //  showThisToast("not loaded");
    }
  } else {}
}

//second page
class FileDownloadActivity extends StatelessWidget {
  final String text;

  FileDownloadActivity({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(text),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                  child: new Center(
                      child: Text(
                    "Do you want to download this file?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ))),
              new Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new FlatButton(
                      onPressed: () {},
                      child: new Text('No'),
                    ),
                    new FlatButton(
                      onPressed: () {},
                      child: new Text('Yes'),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

//second page
class SecondActivity extends StatelessWidget {
  final String text;

  SecondActivity({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    didPassedFirstTest = false;
    // showThisToast("This widget is hited");
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: secondLevelWidget(),
    );
  }
}

Widget openFileInstantly(Collections collection, BuildContext context) {
  String ht = collection.description;
  if (ht.contains("<!DOCTYPE html>")) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HtmlViwer(text: ht)),
    );
  }
}

Widget myDrawer() {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: new Center(
            child: Text(
              'App Name',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.pink,
          ),
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Facebook'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Youtube'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {},
        ),
      ],
    ),
  );
}

class MainActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Ads.hideBannerAd();
    return Scaffold(
      appBar: AppBar(
        title: Text("App Name"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      drawer: myDrawer(),
      body: projectWidget(),
    );
  }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";

  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();
    Future<bool> _onWillPop() async {
      return (_interstitialAd?.show()) ?? false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: downlaodAndShowPDF(pathPDF, context),
    );
  }
}

class myRetrivedData {
  List<Categories> categories;
  List<Collections> collections;
  bool isCategory;

  myRetrivedData({this.categories, this.collections, this.isCategory});
}

Future<String> copyAsset(String path) async {
  isPDFLoading = true;
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  final filename = path.substring(path.lastIndexOf("/") + 1);

  File tempFile = File('$tempPath' + filename);
  ByteData bd = await rootBundle.load("assets" + path);
  await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
  isPDFLoading = false;
  return tempFile.path;
}

String getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544~1458002511';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544~3347511713';
  }
  return null;
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}
//add helpler start

const String testDevice = 'YOUR_DEVICE_ID';

void initialize() {
  FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
}

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  testDevices: testDevice != null ? <String>[testDevice] : null,
  keywords: <String>['foo', 'bar'],
  contentUrl: 'http://foo.com/bar.html',
  childDirected: true,
  nonPersonalizedAds: true,
);

BannerAd _createBannerAd() {
  return BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.fullBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event $event");
    },
  );
}

InterstitialAd createInterstitialAd() {
  return InterstitialAd(
    adUnitId: InterstitialAd.testAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event $event");
    },
  );
}

//add helper ends

//html vier start
class HtmlViwer extends StatelessWidget {
  final String text;

  HtmlViwer({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit an App'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () {
                    _interstitialAd?.show();
                    Navigator.of(context).pop(true);
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Description"),
          ),
          body: SingleChildScrollView(
            child : Text("ok")
//            child: Html(
//              data: text,
//            ),
          ),
        ));
  }
}
//html ends

Future<String> createFileOfPdfUrl(String url_, BuildContext c) async {
  isPDFLoading = true;
  final filename = url_.substring(url_.lastIndexOf("/") + 1);
  final dir = await getApplicationDocumentsDirectory();
  final file = File(dir.path + "/" + filename);
  if (await file.exists()) {
    isPDFLoading = false;
    return dir.path + "/" + filename;
  } else {
    //  showThisToast("True found");
    final url = url_;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    isPDFLoading = false;
    return file.path;
  }
}

void downlaodAndNavigateAudio(String url_, BuildContext c) async {
  isPDFLoading = true;
  final filename = url_.substring(url_.lastIndexOf("/") + 1);
  final dir = await getApplicationDocumentsDirectory();
  final file = File(dir.path + "/" + filename);
  if (await file.exists()) {
    isPDFLoading = false;
    liveMusicLink = dir.path + "/" + filename;
    musicLocalFilePath = dir.path + "/" + filename;
    Navigator.push(
      c,
      MaterialPageRoute(
          // builder: (context) => ExampleApp()),
          builder: (context) => AudioApp()),
    );
  } else {
    //  showThisToast("True found");
    final url = url_;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    isPDFLoading = false;
    liveMusicLink = file.path;
    musicLocalFilePath = file.path;
    Navigator.push(
      c,
      MaterialPageRoute(
          // builder: (context) => ExampleApp()),
          builder: (context) => AudioApp()),
    );
  }
}

Future<bool> askBoolean(context, String url_) async {
  bool status = false;
  status = await showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to download the file?'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text('No'),
        ),
        new FlatButton(
          onPressed: () {
            status = true;
            //  showThisToast("True found 2");
            Navigator.pop(context, true);
          },
          child: new Text('Yes'),
        ),
      ],
    ),
  );
  return status;
}

//music codes
typedef void OnError(Exception exception);

bool isDownloading = true;
String downloadedFilePath;
enum PlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget {
  final String serverIP;

  const AudioApp({Key key, this.serverIP}) : super(key: key);

  @override
  _AudioAppState createState() => _AudioAppState();
}

class _AudioAppState extends State<AudioApp> {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(widget.serverIP);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future _playLocal() async {
    await audioPlayer.play(musicLocalFilePath, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(url);
    } on ClientException {
      rethrow;
    }
    return bytes;
  }

  Future _loadFile() async {
    final bytes = await _loadFileBytes(liveMusicLink,
        onError: (Exception exception) =>
            print('_loadFile => exception $exception'));

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists())
      setState(() {
        musicLocalFilePath = file.path;
      });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(child: _buildPlayer());
  }

  Widget _buildPlayer() => Container(
        child: Column(
          children: [
            if (duration != null)
              Container(
                height: 35,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 00.0,
                      right: 00.0,
                      child: Slider(
                          value: position?.inMilliseconds?.toDouble() ?? 0.0,
                          onChanged: (double value) {
                            return audioPlayer
                                .seek((value / 1000).roundToDouble());
                          },
                          min: 0.0,
                          max: duration.inMilliseconds.toDouble()),
                    )
                  ],
                ),
              ),

            Row(mainAxisSize: MainAxisSize.min, children: [
              if (duration != null)
                Text(
                  position != null
                      ? "${positionText ?? ''}"
                      : duration != null ? durationText : '',
                  style: TextStyle(fontSize: 11.0),
                ),
              IconButton(
                onPressed: isPlaying ? null : () => play(),
                iconSize: 32.0,
                icon: Icon(Icons.play_arrow),
                color: Colors.pink,
              ),
              IconButton(
                onPressed: isPlaying ? () => pause() : null,
                iconSize: 32.0,
                icon: Icon(Icons.pause),
                color: Colors.pink,
              ),
              IconButton(
                onPressed: isPlaying || isPaused ? () => stop() : null,
                iconSize: 32.0,
                icon: Icon(Icons.stop),
                color: Colors.pink,
              ),
              if (duration != null)
                Text(
                  position != null
                      ? "${durationText ?? ''}"
                      : duration != null ? durationText : '',
                  style: TextStyle(fontSize: 11.0),
                ),
            ]),

//            if (position != null) _buildMuteButtons(),
            // if (position != null) _buildProgressView()
          ],
        ),
      );

  Row _buildProgressView() => Row(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: CircularProgressIndicator(
            value: position != null && position.inMilliseconds > 0
                ? (position?.inMilliseconds?.toDouble() ?? 0.0) /
                    (duration?.inMilliseconds?.toDouble() ?? 0.0)
                : 0.0,
            valueColor: AlwaysStoppedAnimation(Colors.cyan),
            backgroundColor: Colors.grey.shade400,
          ),
        ),
        Text(
          position != null
              ? "${positionText ?? ''} / ${durationText ?? ''}"
              : duration != null ? durationText : '',
          style: TextStyle(fontSize: 24.0),
        )
      ]);

  Row _buildMuteButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (!isMuted)
          FlatButton.icon(
            onPressed: () => mute(true),
            icon: Icon(
              Icons.headset_off,
              color: Colors.cyan,
            ),
            label: Text('Mute', style: TextStyle(color: Colors.cyan)),
          ),
        if (isMuted)
          FlatButton.icon(
            onPressed: () => mute(false),
            icon: Icon(Icons.headset, color: Colors.cyan),
            label: Text('Unmute', style: TextStyle(color: Colors.cyan)),
          ),
      ],
    );
  }
}

Future<String> createFileAnyHow(String url_, BuildContext c) async {
  if (url_.contains("file:///")) {
    isDownloading = true;

    url_ = url_.replaceRange(0, 7, '');
    //showThisToast(url_);
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final filename = url_.substring(url_.lastIndexOf("/") + 1);

    File tempFile = File('$tempPath' + filename);
    ByteData bd = await rootBundle.load("assets" + url_);
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    isDownloading = false;
    liveMusicLink = tempFile.path;
    musicLocalFilePath = tempFile.path;
    // showThisToast(tempFile.path);
    // doINeedDownload = false;
    doIHaveDownloadPermission = true;

    return tempFile.path;
  } else {
    isDownloading = true;
    final filename = url_.substring(url_.lastIndexOf("/") + 1);
    final dir = await getApplicationDocumentsDirectory();
    final file = File(dir.path + "/" + filename);

    if (await file.exists()) {
      isDownloading = false;
      // showThisToast("exixts" + "\n" + url_);
      //showThisToast(dir.path + "/" + filename);
      //  doINeedDownload = false;
      doIHaveDownloadPermission = true;
      return dir.path + "/" + filename;
    } else {
      // showThisToast("File Downnload started");
      final url = url_;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      isDownloading = false;
      liveMusicLink = file.path;
      musicLocalFilePath = file.path;
      //showThisToast(file.path);
      //  doINeedDownload = false;
      doIHaveDownloadPermission = true;
      return file.path;
    }
  }
}

bool getBool(String url_) {
  return false;
}

Future<bool> checkIfFileAvailable(String url_, BuildContext c) async {
  if (url_.contains("file:///")) {
    //  showThisToast("File was in local");
    doIHaveDownloadPermission = true;
    doINeedDownload = false;
    didPassedFirstTest = true;
    return true;
  } else {
    final filename = url_.substring(url_.lastIndexOf("/") + 1);
    final dir = await getApplicationDocumentsDirectory();
    final file = File(dir.path + "/" + filename);

    if (await file.exists()) {
      didPassedFirstTest = true;
      // showThisToast("exixts" + "\n" + url_);
      //showThisToast(dir.path + "/" + filename);
      //  showThisToast("File previously downloaded");
      doIHaveDownloadPermission = true;
      doINeedDownload = false;
      return true;
    } else {
      // showThisToast("Need to download");
      //doIHaveDownloadPermission = false;
      doINeedDownload = true;

      didPassedFirstTest = false;

      bool gg = (await showDialog(
            barrierDismissible: false,
            context: c,
            builder: (context) => new AlertDialog(
              title: new Text('Download required'),
              content: new Text('Do you want to Download the file'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    doIHaveDownloadPermission = false;
                    Navigator.of(context).pop(false);
                    Navigator.of(context).pop();
                    didPassedFirstTest = false;
                  },
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () {
                    doIHaveDownloadPermission = true;
                    didPassedFirstTest = true;
                    Navigator.of(context).pop(true);
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
      if (gg) {
        // showThisToast("True found");
      } else {
        //  showThisToast("false found");
      }

      return gg;
    }
  }
}

Future<String> copyAsset_2(String path) async {
  showThisToast("Asset load" + "\n" + path);
  isDownloading = true;
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  final filename = path.substring(path.lastIndexOf("/") + 1);

  File tempFile = File('$tempPath' + filename);
  ByteData bd = await rootBundle.load("assets" + path);
  await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
  isDownloading = false;
  liveMusicLink = tempFile.path;
  musicLocalFilePath = tempFile.path;
  return tempFile.path;
}

Future<String> returnLocalFileName(String path) async {
  isDownloading = false;
  // showThisToast("local return" + "\n" + path);
  return path;
}
