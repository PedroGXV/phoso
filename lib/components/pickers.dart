import 'package:audio_picker/audio_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'custom_dialog.dart';

class Pickers extends StatefulWidget {
  @override
  _PickersState createState() => _PickersState();
}

class _PickersState extends State<Pickers> {
  ImagePicker _picker;
  String _imagePath;
  String _audioPath;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<String> openAudioPicker() async {
    // showLoading();
    _audioPath = await AudioPicker.pickAudio();
    // dismissLoading();

    return _audioPath;
  }

  Future<String> loadImagePicker(ImageSource source) async {
    PickedFile picked = await ImagePicker().getImage(source: source);

    print(picked.path);
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
