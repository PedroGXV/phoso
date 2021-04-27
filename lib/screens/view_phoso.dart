import 'package:flutter/material.dart';
import 'package:phoso/components/audio_player_opt.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/form_playlist.dart';
import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhoso extends StatefulWidget {
  final PhotoSound photoSound;

  ViewPhoso({@required this.photoSound});

  @override
  _ViewPhosoState createState() => _ViewPhosoState();
}

class _ViewPhosoState extends State<ViewPhoso> with TickerProviderStateMixin {
  double _imageContainerHeight;
  double _imageContainerWidth;
  double _iconDegree = 0;

  bool _rotate = true;
  bool _playerMinimized = false;
  bool _appbarVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _imageContainerHeight = MediaQuery.of(context).size.height - 500;
    _imageContainerWidth = MediaQuery.of(context).size.width - 200;

    return Scaffold(
      appBar: (_appbarVisible)
          ? AppBar(
              title: Text(
                (widget.photoSound.playlistName != null) ? widget.photoSound.playlistName : 'Playlist name',
              ),
              actions: [
                Container(
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _rotate = !_rotate;
                          });
                        },
                        child: Icon(
                          Icons.crop_rotate_outlined,
                          color: (_rotate) ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FormPlaylist(
                                formAction: FormAction.edit,
                                photoSound: widget.photoSound,
                              ),
                            ),
                          );
                        },
                        child: Icon(Icons.edit_outlined),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _appbarVisible = !_appbarVisible;
                  if (_appbarVisible) {
                    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                  } else {
                    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
                  }
                });
              },
              child: PhotoView(
                customSize: Size(
                  _imageContainerWidth,
                  _imageContainerHeight,
                ),
                enableRotation: _rotate,
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                imageProvider: FileImage(
                  File(widget.photoSound.photoSrc),
                ),
                minScale: PhotoViewComputedScale.contained * 2,
                maxScale: PhotoViewComputedScale.contained * 4,
                initialScale: PhotoViewComputedScale.contained,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0),
            child: Column(
              children: [
                Material(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _playerMinimized = !_playerMinimized;
                        _iconDegree = (_playerMinimized) ? Math.pi : 0;
                      });
                    },
                    child: Container(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (_playerMinimized) ? 'Expandir'.toUpperCase() : 'Esconder'.toUpperCase(),
                            ),
                            Transform.rotate(
                              child: Icon(Icons.arrow_drop_down),
                              angle: _iconDegree,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: AudioPlayerOpt(
                    globalContext: context,
                    visibile: !_playerMinimized,
                    photoSound: widget.photoSound,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
