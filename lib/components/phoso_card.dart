import 'dart:io';
import 'dart:math' as Math;

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:phoso/components/audio_player_opt.dart';
import 'package:phoso/components/custom_dialog.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/deleting.dart';
import 'package:phoso/screens/form_playlist.dart';

class PhosoCard extends StatefulWidget {
  final Function onTap;
  final Function onLongPress;
  final PhotoSound photoSound;
  final BuildContext globalContext;

  // deleteTarget is for multiple PhosoCards delete at the same time
  // if null the card is not in a 'deletable state'
  // if false the card is 'deletable' but it is not a target
  //if true the card is 'deletable' and it is a target
  final bool deleteTarget;

  static List<int> targets = [];

  PhosoCard({
    @required this.onTap,
    @required this.photoSound,
    this.onLongPress,
    this.globalContext,
    this.deleteTarget,
  }) : assert(onTap != null && photoSound != null);

  @override
  _PhosoCardState createState() => _PhosoCardState();
}

class _PhosoCardState extends State<PhosoCard> {
  bool _extendAudio = false;
  bool _isPlaying = false;
  bool favorite;

  AudioPlayer _audioPlayer;

  double _extendAngle = 0;

  Duration position = new Duration(seconds: 0);
  Duration musicLength = new Duration();

  AudioCache cache;

  AppDatabase _db = new AppDatabase();
  PhotoSound _newPhoso;
  Color _favoriteIconColor = Colors.grey;

  @override
  void initState() {
    _initColors();
    favorite = widget.photoSound.favorite;

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
  void setState(fn) {
    super.setState(fn);

    if (_newPhoso != null) {
      _favoriteIconColor = (_newPhoso.favorite) ? Colors.redAccent : Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).accentColor,
        ),
      ),
      child: Column(
        children: [
          Material(
            borderRadius: BorderRadius.circular(6),
            color: (PhosoCard.targets.contains(this.widget.photoSound.id) && this.widget.deleteTarget != null)
                ? Theme.of(context).accentColor
                : Theme.of(context).backgroundColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                setState(() {
                  widget.onTap();
                });
              },
              onLongPress: () {
                try {
                  widget.onLongPress();
                } catch (e) {
                  print(e);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: _favoriteIconColor,
                          borderRadius: BorderRadius.circular(100),
                          onTap: () async {
                            bool newFavoriteValue = (_newPhoso != null) ? !_newPhoso.favorite : !widget.photoSound.favorite;

                            PhotoSound newPhoso = new PhotoSound(
                              id: widget.photoSound.id,
                              playlistName: widget.photoSound.playlistName,
                              photoSrc: widget.photoSound.photoSrc,
                              soundSrc: widget.photoSound.soundSrc,
                              favorite: newFavoriteValue,
                            );

                            await _db
                                .edit(
                              newPhoso,
                            )
                                .catchError((e) {
                              newPhoso = null;
                            });

                            setState(() {
                              if(newPhoso != null) {
                                _newPhoso = newPhoso;
                                favorite = _newPhoso.favorite;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.favorite,
                              size: 30,
                              color: _favoriteIconColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      // this height sets the hole card height
                      height: 50,
                      child: Image.file(
                        File(widget.photoSound.photoSrc),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          widget.photoSound.playlistName,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: (PhosoCard.targets.contains(this.widget.photoSound.id) &&
                                    this.widget.deleteTarget != null)
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).accentColor,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: (this.widget.deleteTarget == null)
                          ? Row(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      setState(() {
                                        _extendAudio = !_extendAudio;
                                        _extendAngle = (_extendAudio) ? Math.pi : 0;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Transform.rotate(
                                        angle: _extendAngle,
                                        child: Icon(
                                          Icons.arrow_drop_down_circle_outlined,
                                          size: 34,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      if (this.widget.deleteTarget == null) {
                                        _openCardDialog(context: context);
                                      } else {
                                        setState(() {
                                          if (PhosoCard.targets.contains(this.widget.photoSound.id)) {
                                            PhosoCard.targets.remove(this.widget.photoSound.id);
                                          } else {
                                            PhosoCard.targets.add(this.widget.photoSound.id);
                                          }
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.more_vert,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (PhosoCard.targets.contains(this.widget.photoSound.id))
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).accentColor,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.done,
                                  color: (PhosoCard.targets.contains(this.widget.photoSound.id))
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _extendAudio,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        (widget.photoSound.soundName.isEmpty)
                            ? AudioPlayerOpt.getNameThroughFilePath(widget.photoSound.soundSrc)
                            : widget.photoSound.soundName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_isPlaying) {
                          await _audioPlayer.pause();
                        } else {
                          await _audioPlayer.play(
                            widget.photoSound.soundSrc,
                            isLocal: true,
                            stayAwake: true,
                            position: position,
                          );
                        }

                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      },
                      child: Icon(
                        (_isPlaying) ? Icons.pause : Icons.play_arrow,
                        color: Theme.of(context).accentColor,
                        size: 45,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_isPlaying) {
                          _audioPlayer.stop();
                        }
                        setState(() {
                          _isPlaying = false;
                          position = Duration(seconds: 0);
                        });
                      },
                      child: Icon(
                        Icons.stop,
                        color: Colors.redAccent.withOpacity(0.6),
                        size: 45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initColors() {
    if (widget.photoSound.favorite) {
      _favoriteIconColor = Colors.redAccent;
    }
  }

  void _openCardDialog({@required BuildContext context}) {
    // using globalContext to avoid the "Looking to ancestor error" (related to dialog context)
    context = (widget.globalContext != null) ? widget.globalContext : context;

    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        dismissible: true,
        title: widget.photoSound.playlistName,
        contents: [
          _cardOptions(
            optName: 'Editar',
            optIcon: Icons.edit_outlined,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FormPlaylist(
                  formAction: FormAction.edit,
                  photoSound: this.widget.photoSound,
                ),
              ),
            ),
          ),
          _cardOptions(
            optName: 'Excluir',
            optIcon: Icons.delete_forever,
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Deleting(idTarget: [widget.photoSound.id]))),
            tileColor: Colors.redAccent,
          )
        ],
      ),
    );
  }

  Widget _cardOptions({
    @required String optName,
    @required IconData optIcon,
    @required Function onTap,
    Color tileColor,
  }) {
    return Material(
      color: (tileColor != null) ? tileColor : Colors.transparent,
      child: ListTile(
        onTap: () {
          onTap();
        },
        title: Row(
          children: [
            Icon(optIcon),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(optName.toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
