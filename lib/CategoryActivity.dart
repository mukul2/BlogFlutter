//`import 'dart:convert';
//import 'dart:async' show Future;
//import 'dart:async';
//import 'dart:async';
//import 'dart:io';
//import 'package:firebase_admob/firebase_admob.dart';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
//import 'package:kobita/passData.dart';
//import 'package:path_provider/path_provider.dart';
//import 'dart:io';
//import 'dart:io';
//import 'dart:io' as io;
//import 'package:path_provider/path_provider.dart';
//import 'package:flutter/services.dart' show ByteData, rootBundle;
//
////import 'dart:html';
//import 'package:flutter/services.dart' show rootBundle;
//import 'package:flutter/material.dart';
//import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
//import 'package:flutter_html/flutter_html.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:kobita/AppAllData.dart';
//
//import 'AnotherMusicPlayer.dart';
//import 'FullPDFViewerOnline.dart';
//import 'MyAudioPlayer.dart';
//import 'MyMusicPLayer.dart';
//import 'OnlinePDFScreen.dart';
//import 'myAd.dart';
//
//void main() {
//  runApp(MyAppBody());
//}
//
//InterstitialAd _interstitialAd;
//
//var isLoading = true;
//var isPDFLoading = false;
//var isPDFLocal = true;
//var selectedSecondayCatID;
//var selectedOwnCatID;
//
//List<Collections> secondLevelContents = new List();
//
//class MyAppBody extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.pink,
//      ),
//      home: MyHomePage(title: 'My Blog Application'),
//    );
//  }
//}
//
//Future<String> _loadAsset() async {
//  isLoading = true;
//  return await rootBundle.loadString('assets/data.json');
//}
//
//Future<AppAllData> loadProjectData() async {
//  String jsonString = await _loadAsset();
//  final jsonResponse = json.decode(jsonString);
//  AppAllData data = new AppAllData.fromJson(jsonResponse);
//  return data;
//}
//
//Future<List<Categories>> loadCategories() async {
//  List<Categories> firstLevelCategory = new List();
//  AppAllData appAllData = await loadProjectData();
//  isLoading = false;
//  for (var i = 0; i < appAllData.categories.length; i++) {
//    if (appAllData.categories[i].parentId == 0) {
//      firstLevelCategory.add(appAllData.categories[i]);
//    }
//  }
//  return firstLevelCategory;
//}
//
//Future<myRetrivedData> loadSecondaryCategories() async {
//  List<Categories> secondLevelCategory_ = new List();
//  List<Collections> secondLevelContents_ = new List();
//  AppAllData appAllData = await loadProjectData();
//
//  for (var i = 0; i < appAllData.categories.length; i++) {
//    if (appAllData.categories[i].parentId == selectedSecondayCatID) {
//      secondLevelCategory_.add(appAllData.categories[i]);
//    }
//  }
//  if (secondLevelCategory_.length == 0) {
//    showThisToast("No category, searching for contents");
//    for (var i = 0; i < appAllData.collections.length; i++) {
//      if (appAllData.collections[i].categoryId == selectedSecondayCatID) {
//        secondLevelContents_.add(appAllData.collections[i]);
//      }
//    }
//  }
//
//  bool ty = true;
//  if (secondLevelCategory_.length > 0) {
//    ty = true;
//  } else {
//    ty = false;
//  }
//
//  myRetrivedData data = new myRetrivedData(
//      categories: secondLevelCategory_,
//      collections: secondLevelContents_,
//      isCategory: ty);
//  isLoading = false;
//  return data;
//}
//
//createPostList(id) async {
//  secondLevelContents.clear();
//  AppAllData appAllData = await loadProjectData();
//  for (var i = 0; i < appAllData.collections.length; i++) {
//    if (appAllData.collections[i].categoryId == id) {
//      secondLevelContents.add(appAllData.collections[i]);
//    }
//  }
//}
//
//void showThisToast(String s) {
//  Fluttertoast.showToast(
//      msg: s,
//      toastLength: Toast.LENGTH_SHORT,
//      gravity: ToastGravity.CENTER,
//      timeInSecForIosWeb: 1,
//      backgroundColor: Colors.red,
//      textColor: Colors.white,
//      fontSize: 16.0);
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  @override
//  void dispose() {
//
//
//    super.dispose();
//  }
//
//  @override
//  void initState() {
//    Ads.hideBannerAd();
//
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("App Name 2"),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.share),
//            onPressed: () {},
//          ),
//        ],
//      ),
//      drawer: myDrawer(),
//      body: projectWidget(),
//    );
//  }
//}
//
//Widget SplashScreen(context) {
//  return Center(
//    child: RaisedButton(onPressed: () {
//      Navigator.push(
//          context, MaterialPageRoute(builder: (context) => MainActivity()));
//    }),
//  );
//}
//
//Widget downlaodAndShowPDF(String link,BuildContext  context) {
//  return FutureBuilder(
//    builder: (context, projectSnap) {
//      return isPDFLoading
//          ? Center(
//        child: CircularProgressIndicator(),
//      )
//          : PDFViewerScaffold(
//          appBar: AppBar(
//            title: Text("Document"),
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.share),
//                onPressed: () {},
//              ),
//            ],
//          ),
//          path: projectSnap.data);
//    },
//    future: isPDFLocal ? copyAsset(link) : createFileOfPdfUrl(link,context),
//  );
//}
//
//Widget projectWidget() {
//  return FutureBuilder(
//    builder: (context, projectSnap) {
//      return isLoading
//          ? Center(
//        child: CircularProgressIndicator(),
//      )
//          : GridView.builder(
//        itemCount: projectSnap.data.length,
//        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//            crossAxisCount: 2),
//        itemBuilder: (context, index) {
//          Categories categories = projectSnap.data[index];
//          return Card(
//            child: InkResponse(
//                onTap: () {
//                  selectedSecondayCatID = categories.id;
//                  selectedOwnCatID = categories.id;
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) =>
//                            SecondActivity(text: categories.title)),
//                  );
//                },
//                child: new Center(
//                  child: new Column(
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.all(8.0),
//                        child: Image.asset('assets/feelings.png',
//                            width: 120, height: 120, fit: BoxFit.fill),
//                      ),
//                      Padding(
//                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
//                          child: Text(categories.title,
//                              style: TextStyle(
//                                  color: Colors.grey[800],
//                                  fontWeight: FontWeight.bold))),
//                    ],
//                  ),
//                )),
//          );
//        },
//      );
//    },
//    future: loadCategories(),
//  );
//}
//
//Widget secondLevelWidget() {
//  return FutureBuilder(
//    builder: (context, projectSnap) {
//      bool isCategory = projectSnap.data.isCategory;
//      int count_ = 0;
//      if (isCategory) {
//        count_ = projectSnap.data.categories.length;
//      } else {
//        count_ = projectSnap.data.collections.length;
//      }
//      return false
//          ? Center(
//        child: CircularProgressIndicator(),
//      )
//          : isCategory
//          ? GridView.builder(
//        itemCount: count_,
//        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//            crossAxisCount: 2),
//        itemBuilder: (context, index) {
//          // Categories categories = projectSnap.data.categories[index];
//          // Collections collections = projectSnap.data.collections[index];
//
//          return Card(
//            child: InkResponse(
//                onTap: () {
//                  selectedSecondayCatID =
//                      projectSnap.data.categories[index].id;
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => SecondActivity(
//                            text: projectSnap
//                                .data.categories[index].title)),
//                  );
//                },
//                child: new Center(
//                  child: new Column(
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.all(8.0),
//                        child: Image.asset('assets/feelings.png',
//                            width: 120,
//                            height: 120,
//                            fit: BoxFit.fill),
//                      ),
//                      Padding(
//                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
//                          child: Text(
//                              projectSnap
//                                  .data.categories[index].title,
//                              style: TextStyle(
//                                  color: Colors.grey[800],
//                                  fontWeight: FontWeight.bold))),
//                    ],
//                  ),
//                )),
//          );
//        },
//      )
//          : ListView.builder(
//          itemCount: count_,
//          itemBuilder: (BuildContext ctxt, int Index) {
//            return ListTile(
//              leading: Icon(Icons.description),
//              title: Text('Click to Open'),
//              trailing: Icon(Icons.keyboard_arrow_right),
//              onTap: () async {
//                String ht =
//                    projectSnap.data.collections[Index].description;
//                bool isHtml = false;
//                bool isLocalFile = false;
//                String TYPE_MP3 = ".mp3";
//                String TYPE_PDF = ".pdf";
//                String FILE_TYPE;
//
//                //check if the attachment is local html
//                if (ht.contains("<!DOCTYPE html>")) {
//                  isHtml = true;
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => HtmlViwer(text: ht)),
//                  );
//                } //else check if the attachment is local file
//                else if (ht.contains("file:///")) {
//                  isLocalFile = true;
//                  // check if the attachment is local mp3
//                  if (ht.endsWith(TYPE_MP3)) {
//                    showThisToast("local mp3 found at " + "\n" + ht);
//                    String f = await copyAsset(ht.replaceRange(0, 7, ''));
//                    isLinkLive = false;
//                    liveMusicLink = f;
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          //  builder: (context) => ExampleApp()),
//                            builder: (context) => AudioApp())
//                    );
//                  }
//                  // check if the attachment is local pdf
//                  else if (ht.endsWith(TYPE_PDF)) {
//                    FILE_TYPE = TYPE_PDF;
//                    //showThisToast("local pdf found at "+"\n"+ht);
//
//                    isPDFLocal = true;
//
//                    // File f = await copyAsset(ht.replaceRange(0, 7, ''));
//                    // showThisToast(f.path);
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => PDFScreen(ht.replaceRange(0, 7, ''))),
//                    );
//                  }
//                } else if (ht.contains("http")) {
//                  // check if the attachment is online
//                  isLocalFile = false;
//                  if (ht.endsWith(TYPE_MP3)) {
//                    // check if the attachment is online mp3
//                    FILE_TYPE = TYPE_MP3;
//                    showThisToast("live mp3 found");
//                    isLinkLive = true;
//                    final filename = ht.substring(ht.lastIndexOf("/") + 1);
//                    final dir = await getApplicationDocumentsDirectory();
//                    final file = File(dir.path+"/"+filename);
//                    showThisToast(dir.path+filename);
//                    String p = dir.path+"/"+filename;
//                    if (await file.exists()){
//                      liveMusicLink = dir.path+"/"+filename;
//                      showThisToast("mp3 allrady found");
//                    }else {
//                      showThisToast("going to download");
//                      liveMusicLink =await createFileOfPdfUrl(ht,context);
//                      showThisToast(liveMusicLink);
//                    }
//
//
//                    //showThisToast("live mp3 found");
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        // builder: (context) => ExampleApp()),
//                          builder: (context) => AudioApp()),
//                    );
//                  } else if (ht.endsWith(TYPE_PDF)) {
//                    // check if the attachment is online pdf
//                    FILE_TYPE = TYPE_PDF;
//                    showThisToast("live pdf found" + "\n" + ht);
//
//                    isPDFLocal = false;
//
//
//
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => PDFScreen(ht)),
//                    );
//                  }
//                }
//              },
//            );
//          });
//    },
//    future: loadSecondaryCategories(),
//  );
//}
//
////second page
//class SecondActivity extends StatelessWidget {
//  final String text;
//
//  SecondActivity({Key key, @required this.text}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(text),
//      ),
//      body: secondLevelWidget(),
//    );
//  }
//}
//
//Widget myDrawer() {
//  return Drawer(
//    // Add a ListView to the drawer. This ensures the user can scroll
//    // through the options in the drawer if there isn't enough vertical
//    // space to fit everything.
//    child: ListView(
//      // Important: Remove any padding from the ListView.
//      padding: EdgeInsets.zero,
//      children: <Widget>[
//        DrawerHeader(
//          child: Text('Drawer Header'),
//          decoration: BoxDecoration(
//            color: Colors.grey,
//          ),
//        ),
//        ListTile(
//          leading: Icon(Icons.description),
//          title: Text('Facebook'),
//          trailing: Icon(Icons.keyboard_arrow_right),
//          onTap: () {},
//        ),
//        ListTile(
//          leading: Icon(Icons.description),
//          title: Text('Youtube'),
//          trailing: Icon(Icons.keyboard_arrow_right),
//          onTap: () {},
//        ),
//      ],
//    ),
//  );
//}
//
//class MainActivity extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("App Name"),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.share),
//            onPressed: () {},
//          ),
//        ],
//      ),
//      drawer: myDrawer(),
//      body: projectWidget(),
//    );
//  }
//}
//
//class PDFScreen extends StatelessWidget {
//  String pathPDF = "";
//
//  PDFScreen(this.pathPDF);
//
//  @override
//  Widget build(BuildContext context) {
//    _interstitialAd?.dispose();
//    _interstitialAd = createInterstitialAd()..load();
//    Future<bool> _onWillPop() async {
//      return (_interstitialAd?.show()) ?? false;
//    }
//
//    return WillPopScope(
//      onWillPop: _onWillPop,
//      child: downlaodAndShowPDF(pathPDF,context),
//    );
//  }
//}
//
//class myRetrivedData {
//  List<Categories> categories;
//  List<Collections> collections;
//  bool isCategory;
//
//  myRetrivedData({this.categories, this.collections, this.isCategory});
//}
//
//Future<String> copyAsset(String path) async {
//  isPDFLoading = true;
//  Directory tempDir = await getTemporaryDirectory();
//  String tempPath = tempDir.path;
//  final filename = path.substring(path.lastIndexOf("/") + 1);
//
//  File tempFile = File('$tempPath' + filename);
//  ByteData bd = await rootBundle.load("assets" + path);
//  await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
//  isPDFLoading = false;
//  return tempFile.path;
//}
//
//String getAppId() {
//  if (Platform.isIOS) {
//    return 'ca-app-pub-3940256099942544~1458002511';
//  } else if (Platform.isAndroid) {
//    return 'ca-app-pub-3940256099942544~3347511713';
//  }
//  return null;
//}
//
//String getBannerAdUnitId() {
//  if (Platform.isIOS) {
//    return 'ca-app-pub-3940256099942544/2934735716';
//  } else if (Platform.isAndroid) {
//    return 'ca-app-pub-3940256099942544/6300978111';
//  }
//  return null;
//}
////add helpler start
//
//const String testDevice = 'YOUR_DEVICE_ID';
//
//void initialize() {
//  FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
//}
//
//MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//  testDevices: testDevice != null ? <String>[testDevice] : null,
//  keywords: <String>['foo', 'bar'],
//  contentUrl: 'http://foo.com/bar.html',
//  childDirected: true,
//  nonPersonalizedAds: true,
//);
//
//BannerAd _createBannerAd() {
//  return BannerAd(
//    adUnitId: BannerAd.testAdUnitId,
//    size: AdSize.fullBanner,
//    targetingInfo: targetingInfo,
//    listener: (MobileAdEvent event) {
//      print("BannerAd event $event");
//    },
//  );
//}
//
//
//
//InterstitialAd createInterstitialAd() {
//  return InterstitialAd(
//    adUnitId: InterstitialAd.testAdUnitId,
//    targetingInfo: targetingInfo,
//    listener: (MobileAdEvent event) {
//      print("InterstitialAd event $event");
//    },
//  );
//}
//
//
//
////add helper ends
//
////html vier start
//class HtmlViwer extends StatelessWidget {
//  final String text;
//
//  HtmlViwer({Key key, @required this.text}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    _interstitialAd?.dispose();
//    _interstitialAd = createInterstitialAd()..load();
//    Future<bool> _onWillPop() async {
//      return (await showDialog(
//        context: context,
//        builder: (context) => new AlertDialog(
//          title: new Text('Are you sure?'),
//          content: new Text('Do you want to exit an App'),
//          actions: <Widget>[
//            new FlatButton(
//              onPressed: () => Navigator.of(context).pop(false),
//              child: new Text('No'),
//            ),
//            new FlatButton(
//              onPressed: () {
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
//
//    return WillPopScope(
//        onWillPop: _onWillPop,
//        child: Scaffold(
//          appBar: AppBar(
//            title: Text("Description"),
//          ),
//          body: SingleChildScrollView(
//            child: Html(
//              data: text,
//            ),
//          ),
//        ));
//  }
//}
////html ends
//
//Future<String> createFileOfPdfUrl(String url_,BuildContext  c) async {
//  isPDFLoading = true;
//  final filename = url_.substring(url_.lastIndexOf("/") + 1);
//  final dir = await getApplicationDocumentsDirectory();
//  final file = File(dir.path+"/"+filename);
//  if (await file.exists()){
//    isPDFLoading = false;
//    return dir.path+"/"+filename;
//  }else {
//    askBoolean(c);
//
//    final url = url_;
//    final filename = url.substring(url.lastIndexOf("/") + 1);
//    var request = await HttpClient().getUrl(Uri.parse(url));
//    var response = await request.close();
//    var bytes = await consolidateHttpClientResponseBytes(response);
//
//    String dir = (await getApplicationDocumentsDirectory()).path;
//    File file = new File('$dir/$filename');
//    await file.writeAsBytes(bytes);
//    isPDFLoading = false;
//    return file.path;
//  }
//}
//Future<bool> askBoolean(context) async {
//
//  return (await showDialog(
//    context: context,
//    builder: (context) => new AlertDialog(
//      title: new Text('Are you sure?'),
//      content: new Text('Do you want to download the file?'),
//      actions: <Widget>[
//        new FlatButton(
//          onPressed: () => Navigator.of(context).pop(false),
//          child: new Text('No'),
//        ),
//        new FlatButton(
//          onPressed: () {
//
//          },
//          child: new Text('Yes'),
//        ),
//      ],
//    ),
//  )) ??
//      false;
//}`