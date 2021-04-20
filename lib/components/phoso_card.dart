import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoso/components/custom_dialog.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/deleting.dart';
import 'package:phoso/screens/form_playlist.dart';

class PhosoCard extends StatefulWidget {
  final Function onTap;
  final Function onLongPress;
  final PhotoSound photoSound;
  final BuildContext globalContext;

  // deleteTarget is for multiple PhosoCards delete at the same time
  // if null the card is not in a 'deletable state'
  // if false the card is 'deletable' but it is not a target
  //if true the card is 'deletable' and it is a target
  final bool deleteTarget;

  static List<int> targets = [];

  PhosoCard({
    @required this.onTap,
    @required this.photoSound,
    this.onLongPress,
    this.globalContext,
    this.deleteTarget,
  }) : assert(onTap != null && photoSound != null);

  @override
  _PhosoCardState createState() => _PhosoCardState();
}

class _PhosoCardState extends State<PhosoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).accentColor,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).backgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            setState(() {
              widget.onTap();
            });
          },
          onLongPress: () {
            try {
              widget.onLongPress();
            } catch (e) {
              print(e);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      blurRadius: 5,
                    ),
                  ],
                ),
                width: 50,
                child: Image.file(
                  File(widget.photoSound.photoSrc),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    widget.photoSound.playlistName,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                height: double.maxFinite,
                child: Material(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      if (this.widget.deleteTarget == null) {
                        _openCardDialog(context: context);
                      } else {
                        setState(() {
                          if (PhosoCard.targets.contains(this.widget.photoSound.id)) {
                            PhosoCard.targets.remove(this.widget.photoSound.id);
                          } else  {
                            PhosoCard.targets.add(this.widget.photoSound.id);
                          }
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: (this.widget.deleteTarget == null)
                          ? Icon(Icons.more_vert)
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).accentColor,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 6.0, left: 6.0),
                                child: Icon(
                                  Icons.done,
                                  color: (PhosoCard.targets
                                          .contains(this.widget.photoSound.id))
                                      ? Theme.of(context).iconTheme.color
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCardDialog({@required BuildContext context}) {
    // using globalContext to avoid the "Looking to ancestor error" (related to dialog context)
    context = (widget.globalContext != null) ? widget.globalContext : context;

    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        dismissible: true,
        title: widget.photoSound.playlistName,
        contents: [
          _cardOptions(
            optName: 'Editar',
            optIcon: Icons.edit_outlined,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FormPlaylist(
                  formAction: FormAction.edit,
                  photoSound: this.widget.photoSound,
                ),
              ),
            ),
          ),
          _cardOptions(
            optName: 'Excluir',
            optIcon: Icons.delete_forever,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Deleting(idTarget: [widget.photoSound.id]))),
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
