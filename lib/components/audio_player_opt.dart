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
  final bool visibile;

  AudioPlayerOpt({
    @required this.globalContext,
    this.photoSound,
    this.soundSrc,
    this.soundName,
    this.boxDecoration,
    this.visibile = true,
  }) : assert(globalContext != null) {
    // setting the soundSrc && soundName if only the photoSound is passed thorough constructor
    if (soundSrc == null) {
      soundSrc = photoSound.soundSrc;
    }
    if (soundName == null) {
      soundName = photoSound.soundName;
    }
    if (photoSound == null && soundName == null && soundSrc == null) {
      throw Exception('You need to pass photoSound or soundSrc && soundName to AudioPlayer constructor');
    }
  }

  static String getNameThroughFilePath(String path) {
    // removing directory strings (data/storage..., etc.)
    List<String> splitName = path.split('/');
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

  @override
  _AudioPlayerOptState createState() => _AudioPlayerOptState();
}

class _AudioPlayerOptState extends State<AudioPlayerOpt> {
  AudioPlayer _audioPlayer = new AudioPlayer();

  Duration position = new Duration();
  Duration musicLength = new Duration();

  String url;

  PlayerState playerState = PlayerState.stopped;

  @override
  void initState() {

    // initializing the music length
    _audioPlayer.play(widget.soundSrc).then((value) => _audioPlayer.stop());

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => musicLength = d);
    });

    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        if (position == musicLength) {
          position = Duration(seconds: 0);
          playerState = PlayerState.paused;
        } else {
          position = p;
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visibile,
      child: _audioPlayerContainer(),
    );
  }

  Widget _audioPlayerContainer() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: EdgeInsets.all(12),
      color: (widget.boxDecoration == null) ? Theme
          .of(widget.globalContext)
          .backgroundColor : null,
      decoration: (widget.boxDecoration != null) ? widget.boxDecoration : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${(widget.soundName.isNotEmpty) ? widget.soundName : AudioPlayerOpt.getNameThroughFilePath(
                widget.soundSrc)}',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme
                  .of(widget.globalContext)
                  .textTheme
                  .bodyText1
                  .color,
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
                _buildTimeText('${position.inMinutes}', '${position.inSeconds.remainder(60)}',
                    '${musicLength.inMinutes}', '${musicLength.inSeconds.remainder(60)}'),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAudioOpt(
                onTap: (playerState == PlayerState.playing)
                    ? () async {
                  await _audioPlayer.pause();
                  setState(() {
                    playerState = PlayerState.paused;
                  });
                }
                    : () async {
                  await _audioPlayer.play(
                    widget.soundSrc,
                    isLocal: true,
                    stayAwake: true,
                    position: position,
                  );
                  setState(() {
                    playerState = PlayerState.playing;
                  });
                },
                icon: (playerState == PlayerState.playing) ? Icons.pause : Icons.play_arrow,
              ),
              _buildAudioOpt(
                color: Colors.redAccent,
                icon: Icons.stop,
                onTap: () async {
                  await _audioPlayer.stop();
                  setState(() {
                    playerState = PlayerState.stopped;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeText(firstTime, secondTime, thirdTime, fourthTime) {
    return Text(
      // Using ternary op for handle the seconds length
      '$firstTime:${(secondTime
          .toString()
          .length == 1) ? '0$secondTime' : secondTime} / $thirdTime:${(fourthTime
          .toString()
          .length == 1) ? '0$fourthTime' : fourthTime}',
      style: TextStyle(
        color: Theme
            .of(widget.globalContext)
            .textTheme
            .bodyText1
            .color,
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
              color: Theme
                  .of(widget.globalContext)
                  .primaryColor,
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
              color: (color != null) ? color : Theme
                  .of(widget.globalContext)
                  .accentColor,
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
      activeColor: Theme
          .of(widget.globalContext)
          .sliderTheme
          .activeTrackColor,
      inactiveColor: Theme
          .of(widget.globalContext)
          .sliderTheme
          .inactiveTrackColor,
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
}
