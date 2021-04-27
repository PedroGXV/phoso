import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:audio_picker/audio_picker.dart';
import 'package:phoso/components/audio_player_opt.dart';
import 'package:phoso/components/custom_dialog.dart';
import 'package:phoso/components/custom_field.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/components/pickers.dart';
import 'package:phoso/components/response_dialogs.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/models/photo_sound.dart';

enum FormAction { add, edit }
enum FieldType { text, image, audio }

class FormPlaylist extends StatefulWidget {
  final FormAction formAction;
  final PhotoSound photoSound;

  FormPlaylist({
    this.formAction = FormAction.add,
    this.photoSound,
  }) {
    if (formAction == FormAction.edit && photoSound == null) {
      throw Exception('PhotoSound object can´t be null when FormAction is set to \'edit\'');
    }
  }

  @override
  _FormPlaylistState createState() => _FormPlaylistState();
}

class _FormPlaylistState extends State<FormPlaylist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<FieldType, String> _fieldValue = Map();

  // Audio variables
  AudioPicker audioPlayer;
  String _audioName;

  TextEditingController _playlistName = new TextEditingController();

  // state helper variables
  bool _loading = false;
  bool _favorite = false;
  List<FieldType> _fieldsTarget = [];

  dynamic pick = new Pickers().createState();

  @override
  void initState() {
    audioPlayer = AudioPicker();

    // if already exist a audio, image, text value initialize it
    if (widget.formAction == FormAction.edit) {
      _fieldValue.addAll(
        {
          FieldType.audio: widget.photoSound.soundSrc,
          FieldType.image: widget.photoSound.photoSrc,
          FieldType.text: widget.photoSound.playlistName,
        },
      );
      _playlistName.text = _fieldValue[FieldType.text];
      _audioName = widget.photoSound.soundName;
      _favorite = widget.photoSound.favorite;
    } else {
      _fieldValue.addAll(
        {
          FieldType.audio: null,
          FieldType.image: null,
          FieldType.text: null,
        },
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                (widget.formAction == FormAction.add) ? 'Adicionar Playlist' : 'Editar Playlist',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _favorite = !_favorite;
                });
              },
              child: Icon(
                Icons.favorite,
                color: (_favorite) ? Colors.redAccent : Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !_loading,
        child: Container(
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
              await _submitForm().then((value) {}).timeout(
                    Duration(seconds: 5),
                  );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                (widget.formAction == FormAction.add) ? 'Adicionar'.toUpperCase() : 'Editar'.toUpperCase(),
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 20,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Visibility(
              visible: _loading,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(
                  child: Loading(
                    msg: (widget.formAction == FormAction.add) ? 'Adicionando...' : 'Editando...',
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !_loading,
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPickerContainer(
                        type: FieldType.text,
                        containerTitle: 'Nome da playlist',
                        description: 'Digite o nome da playlist'),
                    _buildPickerContainer(
                      containerTitle: 'Imagem',
                      onTap: () async {
                        String imgPath = await pick.showImagePickOptDialog(context);
                        setState(() {
                          // if imgPath is null it means that the user didn't picked a file
                          if (imgPath != null) {
                            _fieldValue[FieldType.image] = imgPath;
                          }
                        });
                      },
                      type: FieldType.image,
                      icon: Icons.image_search,
                      description: 'Toque para adicionar imagem',
                    ),
                    _buildPickerContainer(
                      containerTitle: 'Áudio',
                      onTap: () async {
                        if (_fieldValue[FieldType.audio] == null) {
                          String audioPath = await pick.openAudioPicker();
                          setState(() {
                            if (audioPath != null) {
                              _fieldValue[FieldType.audio] = audioPath;
                            }
                          });
                        }
                      },
                      type: FieldType.audio,
                      icon: Icons.my_library_music_outlined,
                      description: 'Toque para adicionar música',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _submitForm() async {
    // using bool return to optimize the code
    // instead of using if / else, im using two if´s and one return
    // inside the second if
    _fieldValue[FieldType.text] = (_playlistName.text.isEmpty) ? null : _playlistName.text;
    AppDatabase db = new AppDatabase();
    if (!_fieldValue.containsValue(null) && _playlistName.text.length <= 20) {
      if (widget.formAction == FormAction.add) {
        await db
            .save(
          PhotoSound(
            id: null,
            playlistName: this._fieldValue[FieldType.text],
            soundSrc: this._fieldValue[FieldType.audio],
            photoSrc: this._fieldValue[FieldType.image],
            soundName: (_audioName == null || _audioName.isEmpty) ? '' : _audioName,
            favorite: _favorite,
          ),
        )
            .then((value) {
          setState(() {
            _loading = false;
          });

          showDialog(
            context: context,
            builder: (dialogContext) => SuccessDialog(
              'Playlist adicionada.',
              buttonFunction: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          );
        });

        return true;
      } else if (widget.formAction == FormAction.edit) {
        await db
            .edit(
          PhotoSound(
            id: widget.photoSound.id,
            playlistName: this._fieldValue[FieldType.text],
            soundSrc: this._fieldValue[FieldType.audio],
            photoSrc: this._fieldValue[FieldType.image],
            soundName: (_audioName == null || _audioName.isEmpty) ? '' : _audioName,
            favorite: _favorite,
          ),
        )
            .then((value) {
          // Restarting the route to reload all the PhotoSounds data
          // because we are editing, so we need to reload the info
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        });

        return true;
      }
    }
    showDialog(
      context: context,
      builder: (dialogContext) =>
          FailureDialog('Erro ao ${(widget.formAction == FormAction.add) ? 'adicionar' : 'editar'} playlist.'),
    );

    setState(() {
      _fieldValue.forEach((key, value) {
        if (value == null) {
          if (!_fieldsTarget.contains(key)) {
            _fieldsTarget.add(key);
          }
        }
      });
    });

    return false;
  }

  Widget _buildPickerContainer({
    @required FieldType type,
    @required String containerTitle,
    @required String description,
    Function onTap,
    IconData icon = Icons.error_outline,
  }) {
    Widget _child = Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).accentColor,
        ),
      ),
      child: Material(
        color: Theme.of(context).backgroundColor,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildCardElement(
                icon: icon,
                text: description,
              ),
            ),
          ),
        ),
      ),
    );

    // if audio field
    if (_fieldValue[FieldType.audio] != null && type == FieldType.audio) {
      _child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          pick.audioPickers(
            context: context,
            defaultFieldText: 'defaultFieldText',
            firstOnTap: () {
              TextEditingController _audioNameController = new TextEditingController();

              showDialog(
                context: context,
                builder: (dialogContext) {
                  return CustomDialog(
                    title: 'Digite o nome do áudio',
                    contents: [
                      TextField(
                        selectionHeightStyle: BoxHeightStyle.max,
                        controller: _audioNameController,
                        maxLines: 1,
                        maxLength: 100,
                      ),
                    ],
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(
                          'Cancelar'.toUpperCase(),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          setState(() {
                            if (_audioNameController.text != null) {
                              _audioName = _audioNameController.text;
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: Text(
                          'Concluir'.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            secondOnTap: () async {
              String _newAudioPath = await pick.openAudioPicker();
              setState(() {
                if (_newAudioPath != null) {
                  _fieldValue[FieldType.audio] = _newAudioPath;
                }
              });
            },
          ),
          AudioPlayerOpt(
            globalContext: context,
            soundSrc: this._fieldValue[FieldType.audio],
            soundName: (_audioName == null) ? '' : _audioName,
          ),
        ],
      );
    }

    if (_fieldValue[FieldType.image] != null && type == FieldType.image) {
      _child = Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.file(
              File(_fieldValue[FieldType.image]),
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).backgroundColor.withOpacity(0.4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(Icons.edit),
              ),
            ),
          ),
        ],
      );
    }

    if (type == FieldType.text) {
      _child = TextField(
        controller: _playlistName,
        maxLength: 20,
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).textTheme.bodyText1.color,
        ),
        decoration: InputDecoration(
          focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
          border: Theme.of(context).inputDecorationTheme.border,
          enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          hintText: description,
        ),
      );
    }

    return CustomField(
      globalContext: context,
      fieldWidgetLabel: Row(
        children: [
          Text(
            containerTitle,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
      fieldTagName: 'FormPlaylist_${type.toString()}',
      fieldWidget: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    onTap();
                  },
                  child: Container(
                    width: double.maxFinite,
                    // display add layout
                    // or audioPlayerOpt if it has a [audioAbsoluteFilePath]
                    child: _child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardElement({
    @required IconData icon,
    @required String text,
  }) {
    return [
      Icon(
        icon,
        size: 40,
        color: Theme.of(context).iconTheme.color,
      ),
      SizedBox(height: 20),
      Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1.color,
        ),
      ),
    ];
  }
}
