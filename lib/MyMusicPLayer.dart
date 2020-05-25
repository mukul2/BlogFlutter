//import 'dart:async';
//import 'dart:io';
//
//import 'package:audioplayers/audio_cache.dart';
//import 'package:audioplayers/audioplayers.dart';
//import 'package:firebase_admob/firebase_admob.dart';
//import 'package:flutter/material.dart';
//import 'package:http/http.dart';
//import 'package:kobita/passData.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:provider/provider.dart';
//import 'package:flutter/src/foundation/constants.dart';
//
//import 'player_widget.dart';
//
//typedef void OnError(Exception exception);
//
//InterstitialAd _interstitialAd;
//void main() {
//  runApp(MaterialApp(home: ExampleApp()));
//}
//
//class ExampleApp extends StatefulWidget {
//
//  @override
//  _ExampleAppState createState() => _ExampleAppState();
//}
//
//class _ExampleAppState extends State<ExampleApp> {
//  AudioCache audioCache = AudioCache();
//  AudioPlayer advancedPlayer = AudioPlayer();
//  String localFilePath;
//
//  @override
//  void dispose() {
//    audioCache.clearCache();
//    advancedPlayer.setReleaseMode(ReleaseMode.STOP);
//    advancedPlayer.stop();
//    advancedPlayer.dispose();
//    super.dispose();
//  }
//
//  @override
//  void initState() {
//    super.initState();
//
//    if (kIsWeb) {
//      // Calls to Platform.isIOS fails on web
//      return;
//    }
//    if (Platform.isIOS) {
//      if (audioCache.fixedPlayer != null) {
//        audioCache.fixedPlayer.startHeadlessService();
//      }
//      advancedPlayer.startHeadlessService();
//    }
//  }
//
//  Future _loadFile() async {
//    final bytes = await readBytes(liveMusicLink);
//    final dir = await getApplicationDocumentsDirectory();
//    final file = File('${dir.path}/audio.mp3');
//
//    await file.writeAsBytes(bytes);
//    if (await file.exists()) {
//      setState(() {
//        localFilePath = liveMusicLink;
//      });
//    }
//  }
//
//  Widget remoteUrl() {
//    return SingleChildScrollView(
//      child: _Tab(children: [
//        Text(
//          'Sample 1 ($liveMusicLink)',
//          key: Key('url1'),
//          style: TextStyle(fontWeight: FontWeight.bold),
//        ),
//        PlayerWidget(url: liveMusicLink),
//
//
//      ]),
//    );
//  }
//
//  Widget localFile() {
//    return PlayerWidget(
//      url: liveMusicLink,
//    );
//  }
//
//  Widget localAsset() {
//    return SingleChildScrollView(
//      child: _Tab(children: [
//        Text('Play Local Asset \'1audio.mp3\':'),
//        _Btn(txt: 'Play',
//            onPressed: () =>
//                audioCache.play(
//                    'android_asset/apps/quran/mishaari_raashid_al_3afaasee/001.mp3')),
//
//        _Btn(txt: 'Stop', onPressed: () => audioCache.clearCache()),
//
//        getLocalFileDuration(),
//      ]),
//    );
//  }
//
//  Future<int> _getDuration() async {
//    File audiofile = await audioCache.load('audio2.mp3');
//    await advancedPlayer.setUrl(
//      audiofile.path,
//    );
//    int duration = await Future.delayed(
//        Duration(seconds: 2), () => advancedPlayer.getDuration());
//    return duration;
//  }
//
//  getLocalFileDuration() {
//    return FutureBuilder<int>(
//      future: _getDuration(),
//      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
//        switch (snapshot.connectionState) {
//          case ConnectionState.none:
//            return Text('No Connection...');
//          case ConnectionState.active:
//          case ConnectionState.waiting:
//            return Text('Awaiting result...');
//          case ConnectionState.done:
//            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//            return Text(
//                'audio2.mp3 duration is: ${Duration(
//                    milliseconds: snapshot.data)}');
//        }
//        return null; // unreachable
//      },
//    );
//  }
//
//  Widget notification() {
//    return _Tab(children: [
//      Text('Play notification sound: \'messenger.mp3\':'),
//      _Btn(
//          txt: 'Play',
//          onPressed: () =>
//              audioCache.play('messenger.mp3', isNotification: true)),
//    ]);
//  }
//
//  Future<bool> _onWillPop() async {
//    return (await showDialog(
//      context: context,
//      builder: (context) =>
//      new AlertDialog(
//        title: new Text('Are you sure?'),
//        content: new Text('Do you want to exit an App'),
//        actions: <Widget>[
//          new FlatButton(
//            onPressed: () => Navigator.of(context).pop(false),
//            child: new Text('No'),
//          ),
//          new FlatButton(
//            onPressed: () {
//              _interstitialAd?.show();
//              Navigator.of(context).pop(true);
//            },
//            child: new Text('Yes'),
//
//          ),
//        ],
//      ),
//    )) ?? false;
//  }
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
//
//  @override
//  Widget build(BuildContext context) {
//    _interstitialAd?.dispose();
//    _interstitialAd = createInterstitialAd()..load();
//    return MultiProvider(
//        providers: [
//          StreamProvider<Duration>.value(
//              initialData: Duration(),
//              value: advancedPlayer.onAudioPositionChanged),
//        ],
//        child: WillPopScope(
//          onWillPop: _onWillPop,
//
//          child: Scaffold(
//            appBar: AppBar(
//
//              title: Text('audioplayers Example'),
//            ),
//            body: isLinkLive ? remoteUrl() : localFile(),
//          ),
//
//        )
//    );
//  }
//}
//
//class Advanced extends StatefulWidget {
//  final AudioPlayer advancedPlayer;
//
//  const Advanced({Key key, this.advancedPlayer}) : super(key: key);
//  @override
//  void dispose() {
//
//    advancedPlayer.stop();
//    advancedPlayer.dispose();
//
//  }
//  @override
//  _AdvancedState createState() => _AdvancedState();
//}
//
//class _AdvancedState extends State<Advanced> {
//  bool seekDone;
//
//  @override
//  void initState() {
//    widget.advancedPlayer.seekCompleteHandler =
//        (finished) => setState(() => seekDone = finished);
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final audioPosition = Provider.of<Duration>(context);
//    return SingleChildScrollView(
//      child: _Tab(
//        children: [
//          Column(children: [
//            Text('Source Url'),
//            Row(children: [
//              _Btn(
//                  txt: 'Audio 1',
//                  onPressed: () =>
//                      widget.advancedPlayer.setUrl(
//                          "http://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/001.mp3")),
//
//            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
//          ]),
//          Column(children: [
//            Text('Release Mode'),
//            Row(children: [
//              _Btn(
//                  txt: 'STOP',
//                  onPressed: () =>
//                      widget.advancedPlayer.setReleaseMode(ReleaseMode.STOP)),
//              _Btn(
//                  txt: 'LOOP',
//                  onPressed: () =>
//                      widget.advancedPlayer.setReleaseMode(ReleaseMode.LOOP)),
//              _Btn(
//                  txt: 'RELEASE',
//                  onPressed: () =>
//                      widget.advancedPlayer
//                          .setReleaseMode(ReleaseMode.RELEASE)),
//            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
//          ]),
//          Column(children: [
//            Text('Volume'),
//            Row(children: [
//              _Btn(
//                  txt: '0.0',
//                  onPressed: () => widget.advancedPlayer.setVolume(0.0)),
//              _Btn(
//                  txt: '0.5',
//                  onPressed: () => widget.advancedPlayer.setVolume(0.5)),
//              _Btn(
//                  txt: '1.0',
//                  onPressed: () => widget.advancedPlayer.setVolume(1.0)),
//              _Btn(
//                  txt: '2.0',
//                  onPressed: () => widget.advancedPlayer.setVolume(2.0)),
//            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
//          ]),
//          Column(children: [
//            Text('Control'),
//            Row(children: [
//              _Btn(
//                  txt: 'resume',
//                  onPressed: () => widget.advancedPlayer.resume()),
//              _Btn(
//                  txt: 'pause', onPressed: () => widget.advancedPlayer.pause()),
//              _Btn(txt: 'stop', onPressed: () => widget.advancedPlayer.stop()),
//              _Btn(
//                  txt: 'release',
//                  onPressed: () => widget.advancedPlayer.release()),
//            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
//          ]),
//          Column(children: [
//            Text('Seek in milliseconds'),
//            Row(children: [
//              _Btn(
//                  txt: '100ms',
//                  onPressed: () {
//                    widget.advancedPlayer.seek(Duration(
//                        milliseconds: audioPosition.inMilliseconds + 100));
//                    setState(() => seekDone = false);
//                  }),
//              _Btn(
//                  txt: '500ms',
//                  onPressed: () {
//                    widget.advancedPlayer.seek(Duration(
//                        milliseconds: audioPosition.inMilliseconds + 500));
//                    setState(() => seekDone = false);
//                  }),
//              _Btn(
//                  txt: '1s',
//                  onPressed: () {
//                    widget.advancedPlayer
//                        .seek(Duration(seconds: audioPosition.inSeconds + 1));
//                    setState(() => seekDone = false);
//                  }),
//              _Btn(
//                  txt: '1.5s',
//                  onPressed: () {
//                    widget.advancedPlayer.seek(Duration(
//                        milliseconds: audioPosition.inMilliseconds + 1500));
//                    setState(() => seekDone = false);
//                  }),
//            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
//          ]),
//          Column(children: [
//            Text('Rate'),
//            Row(children: [
//              _Btn(
//                  txt: '0.5',
//                  onPressed: () =>
//                      widget.advancedPlayer.setPlaybackRate(playbackRate: 0.5)),
//              _Btn(
//                  txt: '1.0',
//                  onPressed: () =>
//                      widget.advancedPlayer.setPlaybackRate(playbackRate: 1.0)),
//              _Btn(
//                  txt: '1.5',
//                  onPressed: () =>
//                      widget.advancedPlayer.setPlaybackRate(playbackRate: 1.5)),
//              _Btn(
//                  txt: '2.0',
//                  onPressed: () =>
//                      widget.advancedPlayer.setPlaybackRate(playbackRate: 2.0)),
//            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
//          ]),
//          Text('Audio Position: ${audioPosition}'),
//          seekDone == null
//              ? SizedBox(
//            width: 0,
//            height: 0,
//          )
//              : Text(seekDone ? "Seek Done" : "Seeking..."),
//        ],
//      ),
//    );
//  }
//}
//
//class _Tab extends StatelessWidget {
//  final List<Widget> children;
//
//  const _Tab({Key key, this.children}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: Container(
//        alignment: Alignment.topCenter,
//        padding: EdgeInsets.all(16.0),
//        child: SingleChildScrollView(
//          child: Column(
//            children: children
//                .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
//                .toList(),
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class _Btn extends StatelessWidget {
//  final String txt;
//  final VoidCallback onPressed;
//
//  const _Btn({Key key, this.txt, this.onPressed}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return ButtonTheme(
//        minWidth: 48.0,
//        child: RaisedButton(child: Text(txt), onPressed: onPressed));
//  }
//}
