import 'package:flutter/material.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/deleting.dart';

class DialogOption extends StatelessWidget {
  Map<String, Function> onTap;
  PhotoSound photoSound;

  DialogOption({
    @required this.photoSound,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 50,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: Text(
                    photoSound.playlistName,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  content: Container(
                    color: Colors.redAccent,
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            'Excluir'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                  builder: (context) =>
                                      Deleting(idTarget: photoSound.id),
                                ))
                                .then((value) =>
                                    Navigator.pop(dialogContext, true));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Icon(
            Icons.settings,
          ),
        ),
      ),
    );
  }
}
