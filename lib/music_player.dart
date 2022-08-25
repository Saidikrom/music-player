import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svg_icon/svg_icon.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secunds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      secunds,
    ].join(":");
  }

  double values = 0;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1527735095040-147bffb4cede?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1965&q=80"),
                  fit: BoxFit.cover),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withOpacity(.25),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        // Icons.skip_previous_rounded,
                        CupertinoIcons.back,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                    SvgIcon(
                      "assets/icons/optimedia_icon.svg",
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: SvgIcon(
                        "assets/icons/music_list_icon.svg",
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 380,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://images.unsplash.com/photo-1527735095040-147bffb4cede?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1965&q=80"),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                Text(
                  "Space station",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 35),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "House",
                  style: TextStyle(
                      color: Colors.white.withOpacity(.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 10,
                        thumbShape: const RoundSliderThumbShape(
                            disabledThumbRadius: 4, enabledThumbRadius: 8),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 8,
                        ),
                        activeTrackColor: Color(0xffC97855),
                        inactiveTrackColor: Colors.white.withOpacity(0.25),
                        thumbColor: Colors.white,
                        overlayColor: Color(0xffC97855),
                      ),
                      child: Slider(
                        divisions: 1000,
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(),
                        onChanged: (value) async {
                          values = value;
                          final position = Duration(seconds: value.toInt());
                          await audioPlayer.seek(position);
                          await audioPlayer.resume();
                          setState(() {});
                        },
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(position),
                        style: TextStyle(color: Colors.white.withOpacity(.5)),
                      ),
                      Text(
                        formatTime(duration),
                        style: TextStyle(color: Colors.white.withOpacity(.5)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: SvgIcon("assets/icons/arrow_left_icon.svg",
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          String url =
                              "https://uzmusichd.net/wp-content/uploads/mp3/zorubej/Open%20Till%20L8%20x%20Faydee%20-%20Don%E2%80%99t%20Hang%20Up.mp3";
                          await audioPlayer.play(UrlSource(url));
                        }
                        setState(() {});
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: isPlaying
                            ? SvgIcon("assets/icons/pause_icon.svg",
                                color: Colors.white)
                            : SvgIcon("assets/icons/play_icon.svg",
                                color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: SvgIcon("assets/icons/arrow_right_icon.svg",
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: SvgIcon("assets/icons/shuffle_arrow_icon.svg",
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: SvgIcon("assets/icons/arrow_cycle_icon.svg",
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
