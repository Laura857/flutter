import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iim/model/Morceau.dart';

class musicDetails extends StatefulWidget {
  Morceau morceau;

  musicDetails(Morceau this.morceau);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return musicDetailsState();
  }
}

class musicDetailsState extends State<musicDetails> {
  statut lecture = statut.stopped;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration position = Duration(seconds: 0);
  StreamSubscription? positionStream;
  StreamSubscription? stateStream;
  double volumeSound = 0.5;
  Duration duree = Duration(seconds: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configurationPlayer();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.morceau.title),
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: NetworkImage(widget.morceau.image_music!),
                    fit: BoxFit.fill)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.morceau.title),
        Text(widget.morceau.author),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.fast_rewind),
              onPressed: () {
                lecture = statut.playing;
                rewind();
              },
            ),
            (lecture == statut.stopped)
                ? IconButton(
                    icon: Icon(Icons.play_arrow, size: 40),
                    onPressed: () {
                      lecture = statut.paused;
                      play();
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.pause,
                      size: 40,
                    ),
                    onPressed: () {
                      //musique en pause
                      setState(() {
                        lecture = statut.stopped;
                        pause();
                      });
                    },
                  ),
            IconButton(
              icon: Icon(Icons.fast_forward),
              onPressed: () {
                //musique en en avance
                lecture = statut.playing;
                forward();
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(position.toString().substring(2, 7)),
            Text(duree.toString().substring(2, 7))
          ],
        ),
        Slider(
            max: (duree == null) ? 0.0 : duree.inSeconds.toDouble(),
            min: 0.0,
            value: position.inSeconds.toDouble(),
            activeColor: Colors.green,
            inactiveColor: Colors.red,
            onChanged: (va) {
              setState(() {
                Duration time = Duration(seconds: va.toInt());
                position = time;
                audioPlayer.play(widget.morceau.song_path,
                    position: position, volume: volumeSound);
              });
            }),
      ],
    );
  }

  Future play() async {
    if (position > Duration(seconds: 0)) {
      await audioPlayer.play(widget.morceau.song_path,
          position: position, volume: volumeSound);
    } else {
      await audioPlayer.play(widget.morceau.song_path,
          position: position, volume: volumeSound);
    }

    //configurationPlayer();
  }

  Future pause() async {
    await audioPlayer.pause();
  }

  rewind() {
    audioPlayer.pause();
    audioPlayer.seek(Duration(seconds: 0));
    position = new Duration(seconds: 0);
    audioPlayer.play(widget.morceau.song_path, position: position);
  }

  forward() {
    position = new Duration(seconds: position.inSeconds + 10);
    audioPlayer.pause();
    audioPlayer.play(widget.morceau.song_path, position: position);
  }

  configurationPlayer() {
    audioPlayer.setUrl(widget.morceau.song_path);
    positionStream = audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duree = event;
      });
    });
    stateStream = audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == statut.playing) {
        setState(() async {
          duree = audioPlayer.getDuration() as Duration;
        });
      } else if (event == statut.stopped) {
        setState(() {
          lecture = statut.stopped;
        });
      }
    }, onError: (message) {
      print("erreur : $message");
      setState(() {
        lecture = statut.stopped;
        position = Duration(seconds: 0);
        duree = Duration(seconds: 0);
      });
    });
  }
}

enum statut { playing, stopped, paused, rewind, forward }
