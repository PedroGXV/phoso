import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoso/models/hex_color.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/home.dart';

import '../main.dart';

class PhosoCard extends StatelessWidget {
  Function onTap;
  PhotoSound photoSound;

  Color bgColor;
  Color reversedColor;

  PhosoCard({
    @required this.onTap,
    @required this.photoSound,
  });

  @override
  Widget build(BuildContext context) {
    setColors();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: (PhosoApp.darkMode) ? Colors.white : HexColor.fromHex("#FF1A0926"),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: bgColor,
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 90,
                      ),
                    ],
                  ),
                  child: Image.file(
                    File(photoSound.photoSrc),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    photoSound.playlistName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: reversedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setColors() {
    if (PhosoApp.editTarget == photoSound.id) {
      if (PhosoApp.darkMode) {
        bgColor = Colors.white;
        reversedColor = Colors.black;
      } else {
        bgColor = Colors.black;
        reversedColor = Colors.white;
      }
    } else {
      if (PhosoApp.darkMode) {
        bgColor = Colors.black;
        reversedColor = Colors.white;
      } else {
        bgColor = Colors.white;
        reversedColor = Colors.black;
      }
    }
  }
}
