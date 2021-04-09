import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:audio_picker/audio_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoso/components/audio_player_opt.dart';
import 'package:phoso/components/custom_dialog.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/models/photo_sound.dart';

class FormPlaylist extends StatefulWidget {
  static Map<String, bool> _containerOpen = Map();

  @override
  _FormPlaylistState createState() => _FormPlaylistState();
}

class _FormPlaylistState extends State<FormPlaylist> {
  AudioPicker audioPlayer;
  String _audioAbsolutePath;

  TextEditingController _playlistName = new TextEditingController();

  ImagePicker _picker;
  String _imagePath;

  PickedFile _pickedImage;

  @override
  void initState() {
    audioPlayer = AudioPicker();
    _picker = ImagePicker();
    super.initState();
  }

  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: Material(
            color: Colors.transparent,
            child: InkWell(
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Adicionar Playlist',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
        ),
        body: _buildBody(),
        bottomNavigationBar: Visibility(
          visible: !_adding,
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
              onPressed: () async => await _addPhoso().then((value) {}).timeout(
                    Duration(seconds: 5),
                  ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text(
                  'Adicionar'.toUpperCase(),
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
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Visibility(
            visible: _adding,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(
                child: Loading(
                  msg: 'Adicionando...',
                ),
              ),
            ),
          ),
          Visibility(
            visible: !_adding,
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _playlistName,
                      maxLength: 20,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: Theme.of(context)
                            .inputDecorationTheme
                            .focusedBorder,
                        border: Theme.of(context).inputDecorationTheme.border,
                        enabledBorder: Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder,
                        hintText: 'Adicione o nome da playlist',
                      ),
                    ),
                  ),
                  _buildPickerContainer(
                    containerTitle: 'Imagem',
                    context: context,
                    onTap: () {
                      _showImagePickOptDialog(context);
                    },
                    type: 'image',
                    icon: Icons.image_search,
                    description: 'Clique para adicionar imagem',
                  ),
                  _buildPickerContainer(
                    containerTitle: 'Áudio',
                    context: context,
                    onTap: () {
                      _openAudioPicker();
                    },
                    type: 'sound',
                    icon: Icons.my_library_music_outlined,
                    description: 'Clique para adicionar música',
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _addPhoso() async {
    if (_audioAbsolutePath != null &&
        _audioAbsolutePath.isNotEmpty &&
        _imagePath.isNotEmpty &&
        _imagePath != null &&
        _playlistName.text.isNotEmpty &&
        _playlistName.text.length <= 20) {
      setState(() {
        _adding = true;
      });

      await AppDatabase.save(PhotoSound(
        playlistName: this._playlistName.text,
        soundSrc: this._audioAbsolutePath,
        photoSrc: this._imagePath,
      )).then((value) {
        setState(() {
          _adding = false;
        });

        CustomDialog(
          context: context,
          title: 'Adicionado!',
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
              child: Text('OK!'),
            ),
          ],
        );
      });

      return true;
    }
    CustomDialog(
      context: context,
      title: 'Erro ao adicionar!',
      contents: [
        ListTile(
          title: Text('Certifique-se que preencheu todos os campos!'),
        ),
      ],
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK!'),
        ),
      ],
    );

    return false;
  }

  Widget _buildPickerContainer(
      {@required Function onTap,
      @required String type,
      @required IconData icon,
      @required String description,
      @required BuildContext context,
      @required String containerTitle,
      double height}) {
    if (FormPlaylist._containerOpen[containerTitle] == null) {
      FormPlaylist._containerOpen.addAll({
        containerTitle: true,
      });
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            FormPlaylist._containerOpen[containerTitle] =
                !FormPlaylist._containerOpen[containerTitle];
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 8.0),
              child: Row(children: [
                Text(
                  containerTitle,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
                Icon(
                  (FormPlaylist._containerOpen[containerTitle])
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: Theme.of(context).iconTheme.color,
                ),
              ]),
            ),
            Visibility(
              visible: FormPlaylist._containerOpen[containerTitle],
              child: GestureDetector(
                onTap: () {
                  onTap();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: (_imagePath == null) ? Colors.transparent : null,
                    width: double.maxFinite,
                    height: (height == null) ? 300 : height,
                    // displaying image as decoration
                    decoration: (_imagePath != null && type == 'image')
                        ? BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: FileImage(
                                File(_imagePath),
                              ),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : null,
                    // display add default add layout
                    // or audioPlayerOpt
                    child: (_imagePath != null && type == 'image')
                        ? null
                        : (_audioAbsolutePath != null && type == 'sound')
                            ? AudioPlayerOpt(
                                soundSrc: this._audioAbsolutePath,
                                boxDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            : Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                child: Material(
                                  color: Theme.of(context).backgroundColor,
                                  child: InkWell(
                                    onTap: () {
                                      onTap();
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: _buildCardElement(
                                        type: type,
                                        icon: icon,
                                        text: description,
                                      ),
                                    ),
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
    );
  }

  List<Widget> _buildCardElement({
    @required String type,
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

  _openAudioPicker() async {
    // showLoading();
    var path = await AudioPicker.pickAudio();
    // dismissLoading();
    setState(() {
      print(path);
      _audioAbsolutePath = path;
    });
  }

  _loadImagePicker(ImageSource source) async {
    PickedFile picked = await _picker.getImage(source: source);

    if (picked != null) {
      setState(() {
        print('PICKED:  ${picked.path} \n');
        _imagePath = picked.path;
        _pickedImage = picked;
      });
    }

    Navigator.of(context).pop();
  }

  void _showImagePickOptDialog(BuildContext context) {
    CustomDialog(
      context: context,
      title: 'Open from',
      contents: [
        ListTile(
          onTap: () => _loadImagePicker(ImageSource.gallery),
          title: Text('From gallery'),
        ),
        ListTile(
          onTap: () => _loadImagePicker(ImageSource.camera),
          title: Text('From camera'),
        )
      ],
    );
  }
}
