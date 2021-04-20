import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:phoso/models/photo_sound.dart';

enum PlayerState { stopped, playing, paused }

// ignore: must_be_immutable
class AudioPlayerOpt extends StatefulWidget {
  final BuildContext globalContext;

  // IMPORTANT: you need to pass photoSound or soundSrc && soundName
  final PhotoSound photoSound;
  String soundSrc;
  String soundName;
  final BoxDecoration boxDecoration;

  AudioPlayerOpt({
    @required this.globalContext,
    this.photoSound,
    this.soundSrc,
    this.soundName,
    this.boxDecoration,
  }) :assert(globalContext != null) {
    // setting the soundSrc && soundName if only the photoSound is passed thorough constructor
    if (soundSrc == null) {
      soundSrc = photoSound.soundSrc;
    }
    if (soundName == null) {
      soundName = photoSound.soundName;
    }
    if (photoSound == null && soundName == null && soundSrc == null) {
      throw Exception(
          'You need to pass photoSound or soundSrc && soundName to AudioPlayer constructor');
    }
  }

  @override
  _AudioPlayerOptState createState() => _AudioPlayerOptState();
}

class _AudioPlayerOptState extends State<AudioPlayerOpt> {
  bool isPlaying = false;

  AudioPlayer _audioPlayer;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  String url;

  PlayerState playerState = PlayerState.stopped;

  Future playLocal() async {
    await _audioPlayer.play(
      widget.soundSrc,
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

    cache = AudioCache(fixedPlayer: _audioPlayer, prefix: '');

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => musicLength = d);
    });

    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setUrl(widget.soundSrc);

    return _audioPlayerContainer();
  }

  Widget _audioPlayerContainer() {
    return FutureBuilder(
      future: cache.load(widget.soundSrc),
      builder: (context, snapshot) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(12),
          color: (widget.boxDecoration == null)
              ? Theme.of(widget.globalContext).backgroundColor
              : null,
          decoration:
              (widget.boxDecoration != null) ? widget.boxDecoration : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${(widget.soundName.isNotEmpty) ? widget.soundName : getNameThroughFilePath()}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(widget.globalContext).textTheme.bodyText1.color,
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

  Widget _buildTimeText(firstTime, secondTime, thirdTime, fourthTime) {
    return Text(
      // Using ternary op for handle the seconds length
      '$firstTime:${(secondTime.toString().length == 1) ? '0$secondTime' : secondTime} / $thirdTime:${(fourthTime.toString().length == 1) ? '0$fourthTime' : fourthTime}',
      style: TextStyle(
        color: Theme.of(widget.globalContext).textTheme.bodyText1.color,
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
              color: Theme.of(widget.globalContext).primaryColor,
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
              color: (color != null)
                  ? color
                  : Theme.of(widget.globalContext).accentColor,
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
      activeColor: Theme.of(widget.globalContext).sliderTheme.activeTrackColor,
      inactiveColor:
          Theme.of(widget.globalContext).sliderTheme.inactiveTrackColor,
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
    List<String> splitName = widget.soundSrc.split('/');
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
