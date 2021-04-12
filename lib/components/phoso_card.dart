import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoso/components/custom_dialog.dart';
import 'package:phoso/models/hex_color.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/deleting.dart';
import 'package:phoso/screens/edit_phoso.dart';

class PhosoCard extends StatelessWidget {
  final Function onTap;
  final PhotoSound photoSound;
  final BuildContext globalContext;

  PhosoCard({
    @required this.onTap,
    @required this.photoSound,
    this.globalContext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Theme.of(context).accentColor,
            width: 0.7,
          ),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).backgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              onTap();
            },
            onLongPress: () {
              _openCardDialog(context: context);
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
                        _openCardDialog(context: context);
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

  void _openCardDialog({@required BuildContext context}) {
    // using globalContext to avoid the "Looking to ancestor error" (related to dialog context)
    context = (globalContext != null) ? globalContext : context;

    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        dismissible: true,
        title: photoSound.playlistName,
        contents: [
          _cardOptions(
            optName: 'Editar',
            optIcon: Icons.edit_outlined,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditPhoso(photoSound: photoSound))),
          ),
          _cardOptions(
            optName: 'Excluir',
            optIcon: Icons.delete_forever,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Deleting(idTarget: photoSound.id))),
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
