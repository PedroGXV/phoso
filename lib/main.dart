import 'package:flutter/material.dart';
import 'package:phoso/screens/home.dart';
import 'models/hex_color.dart';

void main() {
  runApp(
    PhosoApp(
      title: 'Phoso App',
    ),
  );
}

class PhosoApp extends StatelessWidget {
  PhosoApp({Key key, this.title}) : super(key: key);

  final String title;
  static bool darkMode = false;
  static bool editCard = false;
  static int editTarget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: HexColor.fromHex("#FF8067D0"),
        primaryColor: Colors.deepPurple,
        backgroundColor: Colors.white,
        buttonColor: HexColor.fromHex("#FF3C0095"),
      ),
      home: Home(),
    );
  }
}
