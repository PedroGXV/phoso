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
  Color iconColor;

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
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (PhosoApp.darkMode)
                ? Colors.white
                : HexColor.fromHex("#FF1A0926"),
            width: 1.5,
          ),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              onTap();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.file(
                        File(photoSound.photoSrc),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
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
                Container(
                  height: 50,
                  width: 75,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.settings,
                          color: iconColor,
                          size: 25,
                        ),
                      ),
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
    _darkModeColors();

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

  void _darkModeColors() {
    iconColor = (PhosoApp.darkMode) ? Colors.white : Colors.black;
  }
}
