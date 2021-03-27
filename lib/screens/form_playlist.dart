import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:audio_picker/audio_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoso/components/audio_player_opt.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/main.dart';
import 'package:phoso/models/photo_sound.dart';

class PathPick extends StatefulWidget {
  @override
  _PathPickState createState() => _PathPickState();
}

class _PathPickState extends State<PathPick> {
  AudioPicker audioPlayer;
  String _audioAbsolutePath;

  TextEditingController _playlistName = new TextEditingController();

  PickedFile _pickedImage;
  ImagePicker _picker;
  String _imagePath;

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
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          title: Text('Adicionar Playlist'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: (PhosoApp.darkMode) ? Colors.black : Colors.white,
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
                      color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.deepPurple,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                      ),
                      hintStyle: TextStyle(
                        color:
                            (PhosoApp.darkMode) ? Colors.white : Colors.black,
                      ),
                      labelStyle: TextStyle(
                        color:
                            (PhosoApp.darkMode) ? Colors.white60 : Colors.black,
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
                      color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
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
                      color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
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
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).buttonColor),
                      minimumSize: MaterialStateProperty.all<Size>(Size(
                        double.maxFinite,
                        50,
                      )),
                    ),
                    onPressed: () async {
                      bool phosoAdded = await _addPhoso()
                          .then((value) {
                            Navigator.of(context).pop();
                          })
                          .timeout(
                            Duration(seconds: 5),
                          )
                          .catchError(() {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext dialogContex) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  child: AlertDialog(
                                    title: Text('Algo deu errado.'),
                                    content: SingleChildScrollView(
                                      child: Text(
                                          'Certifique-se que preencheu todos os campos, e que o nome da playlist não tenha mais de 20 caracteres.'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(dialogContex).pop(),
                                        child: Text('Ok'),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          });
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
    if (this._audioAbsolutePath != null && this._audioAbsolutePath.isNotEmpty) {
      if (this._imagePath != null && this._imagePath.isNotEmpty) {
        if (_playlistName.text != null &&
            _playlistName.text.isNotEmpty &&
            _playlistName.text.length <= 20) {
          print(">>> [ ADDING ] <<<");

          await AppDatabase.save(PhotoSound(
            playlistName: this._playlistName.text,
            soundSrc: this._audioAbsolutePath,
            photoSrc: this._imagePath,
          )).then((value) => print(">>> [ ADDED ] <<<")).catchError((error) {
            print(">>> [ ADD FAILED ] <<< ${error.toString()}");
          });

          return true;
        }
      }
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
                color: (PhosoApp.darkMode) ? Colors.black : Colors.white,
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
                    color: (PhosoApp.darkMode) ? Colors.black : Colors.white,
                    child: Material(
                      color: Colors.transparent,
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
        color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
      ),
      SizedBox(height: 20),
      Text(
        text,
        style: TextStyle(
          color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
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

  Future<void> _showImagePickOptDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: (PhosoApp.darkMode)
                ? Colors.white.withOpacity(0.3)
                : Colors.black.withOpacity(0.3),
            child: AlertDialog(
              elevation: 20,
              backgroundColor:
                  (PhosoApp.darkMode) ? Colors.black : Colors.white,
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        'From Gallery',
                        style: TextStyle(
                          color:
                              (PhosoApp.darkMode) ? Colors.white : Colors.black,
                        ),
                      ),
                      onTap: () {
                        _loadImagePicker(ImageSource.gallery);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'From Camera',
                        style: TextStyle(
                          color:
                              (PhosoApp.darkMode) ? Colors.white : Colors.black,
                        ),
                      ),
                      onTap: () {
                        _loadImagePicker(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
