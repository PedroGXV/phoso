import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoso/components/custom_dialog.dart';
import 'package:phoso/models/hex_color.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/deleting.dart';

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
            onLongPress: () {
              _openCardDialog(context);
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
                Container(
                  height: double.maxFinite,
                  child: Material(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        _openCardDialog(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(Icons.settings),
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

  CustomDialog _openCardDialog(@required BuildContext context) {
    return CustomDialog(
      context: context,
      title: photoSound.playlistName,
      contents: [
        Container(
          color: Colors.redAccent,
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Deleting(idTarget: photoSound.id)),
              );
            },
            title: Text('Excluir'.toUpperCase()),
          ),
        ),
      ],
    );
  }

  void setColors() {
    bgColor = Colors.black;
    reversedColor = Colors.white;
  }
}
