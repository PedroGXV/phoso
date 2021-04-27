import 'package:flutter/material.dart';

class PhotoSound {
  static List<PhotoSound> phoso = [];

  int id;
  String playlistName;
  String photoSrc;
  String soundSrc;
  String soundName;
  bool favorite;

  PhotoSound({
    @required this.id,
    @required this.playlistName,
    @required this.photoSrc,
    @required this.soundSrc,
    this.soundName,
    this.favorite = false,
  });
}
