import 'package:flutter/material.dart';
// import 'package:music_player/home_page.dart';
import 'package:music_player/music_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "music player",
      home: MusicPlayer(),
    );
  }
}
