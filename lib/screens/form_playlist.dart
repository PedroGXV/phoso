import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:audio_picker/audio_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoso/components/audio_player_opt.dart';
import 'package:phoso/components/custom_dialog.dart';
import 'package:phoso/database/app_database.dart';
import 'home.dart';
import 'package:phoso/models/photo_sound.dart';

class PathPick extends StatefulWidget {
  @override
  _PathPickState createState() => _PathPickState();
}

class _PathPickState extends State<PathPick> {
  AudioPicker audioPlayer;
  String _audioAbsolutePath;

  TextEditingController _playlistName = new TextEditingController();

  ImagePicker _picker;
  String _imagePath;

  PickedFile _pickedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _picker = ImagePicker();
    audioPlayer = AudioPicker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
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
          title: Text(
            'Adicionar Playlist',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _space(15),
                  TextField(
                    controller: _playlistName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                    decoration: InputDecoration(
                      focusedBorder:
                          Theme.of(context).inputDecorationTheme.focusedBorder,
                      border: Theme.of(context).inputDecorationTheme.border,
                      enabledBorder:
                          Theme.of(context).inputDecorationTheme.enabledBorder,
                      labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      labelText: 'Nome da Playlist',
                      hintText: 'Adicione o nome da playlist',
                    ),
                  ),
                  _space(15),
                  Text(
                    'Imagem',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  _space(15),
                  _buildPickerContainer(
                    onTap: () {
                      _showImagePickOptDialog(context);
                    },
                    type: 'image',
                    icon: Icons.image_search,
                    description: 'Clique para adicionar imagem',
                  ),
                  _space(15),
                  Text(
                    'Áudio',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  _space(15),
                  _buildPickerContainer(
                    onTap: () {
                      _openAudioPicker();
                    },
                    type: 'sound',
                    icon: Icons.my_library_music_outlined,
                    description: 'Clique para adicionar música',
                    height: 200,
                  ),
                  _space(25),
                  ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () async {
                      bool phosoAdded =
                          await _addPhoso().then((value) {}).timeout(
                                Duration(seconds: 5),
                              );
                    },
                    child: Text(
                      'Adicionar'.toUpperCase(),
                      style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  _space(20),
                ],
              ),
            ),
          ),
        ),
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
      await AppDatabase.save(PhotoSound(
        playlistName: this._playlistName.text,
        soundSrc: this._audioAbsolutePath,
        photoSrc: this._imagePath,
      )).then(
        (value) => CustomDialog(
          context: context,
          title: 'Adicionado!',
          actions: {
            'Ok': () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          },
        ),
      );

      return true;
    } else {
      CustomDialog(
        context: context,
        title: 'Erro ao adicionar!',
        contents: {
          'Certifique-se que preencheu todos os campos, e o nome tenha menos de 20 caracteres':
              () {},
        },
        actions: {
          'OK': () {
            Navigator.of(context).pop();
          },
        },
      );
    }

    return false;
  }

  Widget _space(double spaceSize) {
    return SizedBox(
      height: spaceSize,
    );
  }

  Widget _buildPickerContainer(
      {@required Function onTap,
      @required String type,
      @required IconData icon,
      @required String description,
      double height}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: (_imagePath == null) ? Theme.of(context).backgroundColor : null,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
      contents: {
        'Gallery': () {
          _loadImagePicker(ImageSource.gallery);
        },
        'Camera': () {
          _loadImagePicker(ImageSource.camera);
        },
      },
    );
  }
}
