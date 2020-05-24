
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAudioPlayer extends StatelessWidget {
  final String text;

  MyAudioPlayer({Key key, @required this.text}) : super(key: key);
  AudioPlayer advancedPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio"),
      ),
      body:Text(text)
    );
  }
}