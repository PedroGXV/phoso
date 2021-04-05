import 'package:flutter/material.dart';
import 'package:phoso/screens/home.dart';
import 'models/hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  @override
  Widget build(BuildContext context) {
    initPrefs();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: HexColor.fromHex("#FF8067D0"),
        primaryColor: Colors.deepPurple,
        backgroundColor: Colors.white,
        buttonColor: HexColor.fromHex("#FF3C0095"),
      ),
      home: Home(),
    );
  }

  void initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('darkMode') != null) {
      darkMode = prefs.getBool('darkMode');
    } else {
      prefs.setBool('darkMode', darkMode);
    }
    
    print(prefs.getBool('darkMode'));
    
  }
}
