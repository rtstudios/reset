import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './main.dart' as main;

class AudioSetPlayer extends StatefulWidget {
  final StandardSet standardSet;

  AudioSetPlayer(this.standardSet);

  @override
  _AudioSetPlayerState createState() => _AudioSetPlayerState();
}

extension on Duration {
  String format() => "$this".split(".")[0].padLeft(8, "0");
}

class _AudioSetPlayerState extends State<AudioSetPlayer> {
  Icon playIcon = Icon(Icons.play_arrow, color: Colors.white);
  var isPlaying = false;

  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();

  void seekToSecond(int second){
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  @override
  void initState() {
    super.initState();

    audioPlayer.durationHandler = (d) => setState(() {
      duration = d;
    });

    audioPlayer.positionHandler = (p) => setState(() {
      position = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        toolbarHeight: 30,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: NetworkImage(widget.standardSet.imagePath),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), BlendMode.dstATop
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.standardSet.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              activeColor: Colors.white,
              onChanged: (double value) {
                setState(() {
                  seekToSecond(value.toInt());
                  value = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Duration(seconds: position.inSeconds).format(), style: TextStyle(color: Colors.white)),
                  Spacer(),
                  Text(Duration(seconds: duration.inSeconds).format(), style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blueAccent,
                              Colors.blue,
                            ]),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: MaterialButton(
                        minWidth: 80,
                        height: 65,
                        child: Icon(
                          Icons.close, color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var addedTitlesString = widget.standardSet.title + "," ?? "" + widget.standardSet.title + ",";
                          var addedDurationsString = position.inMinutes.toDouble().round().toString() + " MINUTES" + "," ?? "" + position.inMinutes.toDouble().round().toString() + " MINUTES" + ",";

                          await audioPlayer.stop();
                          prefs.setDouble("mindfulnessMinutes", prefs.getDouble("mindfulnessMinutes") + position.inMinutes.toDouble() ?? 0.0 + position.inMinutes.toDouble());
                          prefs.setString("recentTitles", prefs.getString("recentTitles") + addedTitlesString);
                          prefs.setString("recentDurations", prefs.getString("recentDurations") + addedDurationsString);
                          Navigator.of(context).pushReplacementNamed("/home");
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 84, 159, 110),
                              Color.fromARGB(255, 111, 211, 126),
                            ]),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: MaterialButton(
                        minWidth: 110,
                        height: 65,
                        child: playIcon,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () async {
                          if(isPlaying) {
                            setState(() {
                              isPlaying = false;
                              playIcon = Icon(Icons.play_arrow, color: Colors.white);
                            });
                            await audioPlayer.pause();
                          }
                          else {
                            setState(() {
                              isPlaying = true;
                              playIcon = Icon(Icons.pause, color: Colors.white);
                            });
                            await audioPlayer.play(widget.standardSet.audioUrl);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StandardSet extends StatefulWidget {
  final String title;
  final String description;
  final String duration;
  final String imagePath;
  final String audioUrl;

  StandardSet(this.title, this.description, this.duration, this.imagePath, this.audioUrl);

  @override
  _StandardSetState createState() => _StandardSetState();
}

class _StandardSetState extends State<StandardSet> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(widget.imagePath),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.45), BlendMode.dstATop
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: Text(
                    widget.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        widget.duration,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 84, 159, 110),
                                Color.fromARGB(255, 111, 211, 126)
                              ]),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: MaterialButton(
                          minWidth: 100,
                          height: 47,
                          child: Text(
                            "Start",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          onPressed: () {
                            setState(() {
                              main.globalAudioSetPlayer = AudioSetPlayer(StandardSet(widget.title, widget.description, widget.duration, widget.imagePath, widget.audioUrl));
                            });
                            Navigator.of(context).pushReplacementNamed("/player");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryTitle extends StatelessWidget {
  final String title;

  CategoryTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            this.title,
            style: TextStyle(
              fontSize: 33,
              fontFamily: "Avenir",
              fontWeight: FontWeight.w900,
            ),
          ),
          Spacer(),
          Text(
            "SWIPE FOR MORE →",
            style: TextStyle(
              fontSize: 17,
              fontFamily: "Avenir",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalList extends StatefulWidget {
  final List<Widget> items;

  HorizontalList(this.items);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.0,
      child: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: widget.items,
      ),
    );
  }
}
