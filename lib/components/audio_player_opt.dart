import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:phoso/main.dart';
import 'package:phoso/models/photo_sound.dart';

enum PlayerState { stopped, playing, paused }

class AudioPlayerOpt extends StatefulWidget {
  String soundSrc;
  String soundName;

  BoxDecoration boxDecoration;

  AudioPlayerOpt({
    @required this.soundSrc,
    this.soundName,
    this.boxDecoration,
  });

  @override
  _AudioPlayerOptState createState() => _AudioPlayerOptState(
        soundSrc: this.soundSrc,
        soundName: this.soundName,
        boxDecoration: this.boxDecoration,
      );
}

class _AudioPlayerOptState extends State<AudioPlayerOpt> {
  bool isPlaying = false;

  AudioPlayer _audioPlayer;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  String soundSrc;
  String soundName;
  String url;

  BoxDecoration boxDecoration;

  PlayerState playerState = PlayerState.stopped;

  _AudioPlayerOptState({
    @required this.soundSrc,
    this.soundName,
    this.boxDecoration,
  });

  Future playLocal() async {
    await _audioPlayer.play(soundSrc, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await _audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await _audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  Future setUrl(String url) async {
    await _audioPlayer.setUrl(
      url,
      isLocal: true,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioPlayer = new AudioPlayer();
    cache = AudioCache(fixedPlayer: _audioPlayer);

    // handling the duration
    _audioPlayer.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };

    // this function allow us to move the slider
    _audioPlayer.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };

    // load the song to make the playing faster
    cache.load(soundSrc);
  }

  @override
  Widget build(BuildContext context) {
    setUrl(soundSrc);
    return Material(
      color: (PhosoApp.darkMode) ? Colors.black : Colors.white,
      child: InkWell(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: (boxDecoration != null) ? boxDecoration : null,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${(this.soundName != null) ? this.soundName : getNameThroughFilePath()}',
                style: TextStyle(
                  color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAudioOpt(
                    icon: (isPlaying)
                        ? Icons.pause_circle_outline_outlined
                        : Icons.play_circle_outline_outlined,
                    onTap: (isPlaying)
                        ? () async {
                            await pause();
                            setState(() {
                              isPlaying = false;
                            });
                          }
                        : () async {
                            await playLocal();
                            setState(() {
                              isPlaying = true;
                            });
                          },
                    color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
                  ),
                  _buildAudioOpt(
                    color: Colors.redAccent,
                    icon: Icons.stop_circle_outlined,
                    onTap: () async {
                      await stop();
                      setState(() {
                        isPlaying = false;
                      });
                    },
                  ),
                ],
              ),
              Container(
                width: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTimeText(
                        position.inMinutes, position.inSeconds.remainder(60)),
                    slider(),
                    _buildTimeText(musicLength.inMinutes, getSec()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getSec() {
    if (musicLength.inSeconds.toString().length >= 3) {
      return musicLength.inSeconds.toString().substring(0, 2);
    }
    return musicLength.inSeconds.toString();
  }

  Widget _buildTimeText(firstTime, secondTime) {
    return Text(
      '$firstTime:$secondTime',
      style: TextStyle(
        color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildAudioOpt({
    @required IconData icon,
    @required Function onTap,
    Color color,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Icon(
        icon,
        color: (color != null) ? color : Colors.black,
        size: 60,
      ),
    );
  }

  Widget slider() {
    return Container(
      width: 250,
      child: Slider.adaptive(
        activeColor: Colors.deepPurple,
        inactiveColor: (PhosoApp.darkMode) ? Colors.white60 : Colors.black26,
        value: position.inSeconds.toDouble(),
        min: 0,
        max: musicLength.inSeconds.toDouble(),
        onChanged: (value) {
          seekToSec(value.toInt());
        },
      ),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = new Duration(seconds: sec);
    setState(() {
      position = new Duration(seconds: sec);
    });
    _audioPlayer.seek(newPos);
  }

  String getNameThroughFilePath() {
    // removing directory strings (data/storage..., etc.)
    List<String> splitName = soundSrc.split('/');
    // removing the extension (.mp4, .mp3, etc.)
    List<String> splitExtension = splitName.last.split('.');

    String finalName = '';

    // removing only the last '.' (point), aka the extension
    splitExtension.forEach((element) {
      if (element != splitExtension.last) {
        finalName += element;
      }
    });

    return (finalName != null) ? finalName : 'Nome padrão';
  }
}
