import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:phoso/main.dart';

enum PlayerState { stopped, playing, paused }

class AudioPlayerOpt extends StatefulWidget {
  final String soundSrc;
  final String soundName;

  final BoxDecoration boxDecoration;

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
  // The class wasn't getting the right Theme in some situations
  // so I just picked the theme through the main file
  ThemeData _theme;
  String _themeMode;

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
    await _audioPlayer.play(
      soundSrc,
      isLocal: true,
      stayAwake: true,
    );
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await _audioPlayer.pause();
    setState(() {
      playerState = PlayerState.paused;
    });
  }

  Future stop() async {
    await _audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      _audioPlayer.seek(Duration(seconds: 0));
    });
  }

  Future setUrl(String url) async {
    await _audioPlayer.setUrl(
      url,
      isLocal: true,
      respectSilence: true,
    );
  }

  @override
  void initState() {
    _audioPlayer = new AudioPlayer();
    cache = AudioCache(fixedPlayer: _audioPlayer);

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => musicLength = d);
    });

    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });

    // load the song to make the playing faster
    cache.load(soundSrc);
    super.initState();
  }

  @override
  void setState(fn) {
    _theme = PhosoApp.theme;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    setUrl(soundSrc);
    setState(() {});

    return Material(
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {},
        child: Container(
          color: (boxDecoration == null) ? _theme.backgroundColor : null,
          width: MediaQuery.of(context).size.width,
          decoration: (boxDecoration != null) ? boxDecoration : null,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${(this.soundName != null) ? this.soundName : getNameThroughFilePath()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _theme.textTheme.bodyText1.color,
                ),
              ),
              Container(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    slider(),
                    _buildTimeText(
                        '${position.inMinutes}',
                        '${position.inSeconds.remainder(60)}',
                        '${musicLength.inMinutes}',
                        '${musicLength.inSeconds.remainder(60)}'),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAudioOpt(
                    color: (_theme.primaryColor == Color(0xff000000))
                        ? Colors.black
                        : null,
                    onTap: (isPlaying)
                        ? () async {
                            setState(() {
                              isPlaying = false;
                            });
                            pause();
                          }
                        : () async {
                            setState(() {
                              isPlaying = true;
                            });

                            playLocal();
                          },
                    icon: (isPlaying) ? Icons.pause : Icons.play_arrow,
                  ),
                  _buildAudioOpt(
                    color: Colors.redAccent,
                    icon: Icons.stop,
                    onTap: () async {
                      await stop();
                      setState(() {
                        isPlaying = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getSec() {
    if (musicLength.toString().length >= 3) {
      return musicLength.toString().substring(0, 2);
    }
    return musicLength.toString();
  }

  Widget _buildTimeText(firstTime, secondTime, thirdTime, fourthTime) {
    return Text(
      '$firstTime:$secondTime/$thirdTime:$fourthTime',
      style: TextStyle(
        color: _theme.textTheme.bodyText1.color,
      ),
    );
  }

  Widget _buildAudioOpt({
    @required IconData icon,
    @required Function onTap,
    Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: _theme.primaryColor,
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(12.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              onTap();
            },
            child: Icon(
              icon,
              size: 60,
              color: (color != null) ? color : _theme.iconTheme.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget slider() {
    // the .adaptive display both CupertinoSlider and "Material" Slider
    // depending on the platform
    return Slider.adaptive(
      activeColor: _theme.sliderTheme.activeTrackColor,
      inactiveColor: _theme.sliderTheme.inactiveTrackColor,
      value: position.inSeconds.toDouble(),
      min: 0,
      max: musicLength.inSeconds.toDouble(),
      onChanged: (value) async {
        seekToSec(value.toInt());
      },
    );
  }

  void seekToSec(int sec) {
    Duration newPos = new Duration(seconds: sec);
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
