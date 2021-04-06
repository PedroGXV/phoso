import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoso/components/dialog_option.dart';
import 'package:phoso/models/hex_color.dart';
import 'package:phoso/models/photo_sound.dart';

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
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: HexColor.fromHex("#FF1A0926"),
            width: 1.5,
          ),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor,
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
                        ),
                      ),
                    ),
                  ],
                ),
                DialogOption(
                  photoSound: this.photoSound,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setColors() {
    bgColor = Colors.black;
    reversedColor = Colors.white;
  }
}
