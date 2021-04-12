import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoso/components/audio_player_opt.dart';
import 'package:phoso/components/custom_dialog.dart';
import 'package:phoso/components/custom_field.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/components/pickers.dart';
import 'package:phoso/components/response_dialogs.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/models/photo_sound.dart';

class EditPhoso extends StatefulWidget {
  final PhotoSound photoSound;

  final String newPlaylistName;
  final String newImagePath;
  final String newAudioPath;

  TextEditingController _controller;

  EditPhoso({
    @required this.photoSound,
    this.newPlaylistName,
    this.newImagePath,
    this.newAudioPath,
  });

  @override
  _EditPhosoState createState() => _EditPhosoState();
}

class _EditPhosoState extends State<EditPhoso> {
  String _newImagePath;
  String _newAudioPath;
  String _newPlaylistName;

  final EdgeInsetsGeometry _verticalPadding =
  EdgeInsets.only(top: 12.0, bottom: 12.0);
  final EdgeInsetsGeometry _horizontalPadding =
  EdgeInsets.only(left: 12.0, right: 12.0);
  final EdgeInsetsGeometry _allPadding = EdgeInsets.all(12);

  bool _editing = false;

  @override
  void initState() {
    widget._controller = new TextEditingController(
        text: (widget.newPlaylistName != null)
            ? widget.newPlaylistName
            : widget.photoSound.playlistName);

    super.initState();
  }

  @override
  void setState(fn) {
    _newPlaylistName = widget._controller.text;
    super.setState(fn);

    // Here I'm trying to create a new state of this screen (by replacing it)
    // I did this because AudioPlayerOpt have some state limitations (reason: is a stateful widget)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => EditPhoso(
          photoSound: widget.photoSound,
          newAudioPath: _newAudioPath,
          newImagePath: _newImagePath,
          newPlaylistName: _newPlaylistName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_editing)
          ? null
          : AppBar(
              title: Text('Edit'),
            ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: (_editing)
              ? [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3),
                    child: Loading(
                      msg: 'Editando...',
                    ),
                  )
                ]
              : [
                  CustomField(
                    globalContext: context,
                    fieldLabel: 'Nome da Playlist',
                    fieldTagName: 'editPlaylistName',
                    fieldWidget: _textField(),
                  ),
                  CustomField(
                    globalContext: context,
                    fieldLabel: 'Imagem',
                    fieldTagName: 'editPlaylistImage',
                    fieldWidget: _imageField(),
                  ),
                  CustomField(
                    globalContext: context,
                    fieldLabel: 'Som',
                    fieldTagName: 'editPlaylistSound',
                    fieldWidget: _musicField(),
                  ),
                ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !_editing,
        child: _editButton(),
      ),
    );
  }

  Widget _textField() {
    return Padding(
      padding: _horizontalPadding,
      child: TextField(
        controller: widget._controller,
        maxLength: 20,
      ),
    );
  }

  Widget _imageField() {
    return Padding(
      padding: _horizontalPadding,
      child: Container(
        height: 300,
        // width: MediaQuery.of(context).size.width / 2.3,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).accentColor,
          ),
          image: DecorationImage(
            fit: BoxFit.contain,
            image: FileImage(File(
              (widget.newImagePath != null)
                  ? widget.newImagePath
                  : widget.photoSound.photoSrc,
            )),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final String imagePath =
                  await Pickers().createState().showImagePickOptDialog(context);
              setState(() => _newImagePath = imagePath);
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(Icons.edit_outlined),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _musicField() {
    return Padding(
      padding: _allPadding,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final String audioPath =
                    await Pickers().createState().openAudioPicker();
                setState(() {
                  _newAudioPath = audioPath;
                  print('NEW AUDIO PATH: $_newAudioPath');
                  print(_newAudioPath != null);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Editar Áudio'),
                      Icon(Icons.edit_outlined),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AudioPlayerOpt(
            soundSrc: (widget.newAudioPath != null)
                ? widget.newAudioPath
                : widget.photoSound.soundSrc,
          ),
        ],
      ),
    );
  }

  Widget _editButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style,
        onPressed: () async {
          setState(() {
            _editing = true;
          });
          await AppDatabase.edit(
            PhotoSound(
              id: widget.photoSound.id,
              playlistName: widget._controller.text,
              photoSrc: (widget.newImagePath != null)
                  ? widget.newImagePath
                  : widget.photoSound.photoSrc,
              soundSrc: (widget.newAudioPath != null)
                  ? widget.newAudioPath
                  : widget.photoSound.soundSrc,
            ),
          ).then((value) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            'Editar'.toUpperCase(),
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 20,
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
        ),
      ),
    );
  }
}
