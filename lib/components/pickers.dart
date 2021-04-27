import 'package:audio_picker/audio_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'custom_dialog.dart';

class Pickers extends StatefulWidget {
  @override
  _PickersState createState() => _PickersState();
}

class _PickersState extends State<Pickers> {
  String _imagePath;
  String _audioPath;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget audioPickers({
    @required BuildContext context,
    @required String defaultFieldText,
    Function firstOnTap,
    Function secondOnTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _audioPickersOpt(
            context: context,
            optTitle: 'Editar nome',
            onTap: () {
              firstOnTap();
            },
            icon: Icons.edit,
            optBgColor: Colors.blueGrey.withOpacity(0.7),
          ),
          _audioPickersOpt(
            context: context,
            optTitle: 'Mudar áudio',
            onTap: () {
              secondOnTap();
            },
            icon: Icons.audiotrack_outlined,
            optBgColor: Colors.deepPurpleAccent.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Widget _audioPickersOpt({
    @required BuildContext context,
    @required String optTitle,
    @required Function onTap,
    @required IconData icon,
    @required Color optBgColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: optBgColor,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(icon),
                ),
                Text(optTitle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> openAudioPicker() async {
    // showLoading();
    _audioPath = await AudioPicker.pickAudio();
    // dismissLoading();

    return _audioPath;
  }

  // ignore: missing_return
  Future<String> loadImagePicker(ImageSource source) async {
    PickedFile picked = await ImagePicker().getImage(source: source);

    if (picked != null) {
      return _imagePath = picked.path;
    }
  }

  Future<String> showImagePickOptDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: 'Open from',
        contents: [
          ListTile(
            onTap: () async {
              Navigator.of(dialogContext).pop(
                _imagePath = await loadImagePicker(ImageSource.gallery),
              );
            },
            title: Text('From gallery'),
          ),
          ListTile(
            onTap: () async {
              Navigator.of(dialogContext).pop(
                _imagePath = await loadImagePicker(ImageSource.camera),
              );
            },
            title: Text('From camera'),
          )
        ],
      ),
    );

    return _imagePath;
  }
}
