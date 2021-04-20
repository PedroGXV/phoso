import 'package:flutter/material.dart';
import 'package:phoso/components/audio_player_opt.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/form_playlist.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';

class ViewPhoso extends StatefulWidget {
  final PhotoSound photoSound;

  ViewPhoso({@required this.photoSound});

  @override
  _ViewPhosoState createState() => _ViewPhosoState();
}

class _ViewPhosoState extends State<ViewPhoso> {
  double _imageContainerHeight;
  double _imageContainerWidth;

  bool _rotate = true;

  @override
  Widget build(BuildContext context) {
    _imageContainerHeight = MediaQuery.of(context).size.height - 500;
    _imageContainerWidth = MediaQuery.of(context).size.width - 200;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.photoSound.playlistName != null)
              ? widget.photoSound.playlistName
              : 'Playlist name',
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
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 300,
              width: MediaQuery.of(context).size.width,
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
                initialScale: PhotoViewComputedScale.contained * 2,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(5),
              child: AudioPlayerOpt(
                globalContext: context,
                photoSound: widget.photoSound,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
