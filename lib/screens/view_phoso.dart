import 'package:flutter/material.dart';
import 'package:phoso/components/audio_player_opt.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';

class ViewPhoso extends StatefulWidget {
  String playlistName;
  String photoSrc;
  String soundSrc;

  ViewPhoso({
    @required this.playlistName,
    @required this.photoSrc,
    @required this.soundSrc,
  });

  @override
  _ViewPhosoState createState() => _ViewPhosoState(
        playlistName: this.playlistName,
        photoSrc: this.photoSrc,
        soundSrc: this.soundSrc,
      );
}

class _ViewPhosoState extends State<ViewPhoso> {
  String playlistName;
  String photoSrc;
  String soundSrc;

  double _imageContainerHeight;
  double _imageContainerWidth;

  bool _rotate = true;
  bool _nightMode = false;

  _ViewPhosoState({
    @required this.playlistName,
    @required this.photoSrc,
    @required this.soundSrc,
  });

  @override
  Widget build(BuildContext context) {
    _imageContainerHeight = MediaQuery.of(context).size.height - 500;
    _imageContainerWidth = MediaQuery.of(context).size.width - 200;

    return Scaffold(
      appBar: AppBar(
        title: Text((playlistName != null) ? playlistName : 'Playlist name'),
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
                  File(photoSrc),
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
                soundSrc: soundSrc,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
