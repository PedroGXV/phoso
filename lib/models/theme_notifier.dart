import 'package:flutter/material.dart';
import '../models/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  static String themeName;
  String _light = 'light';

  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    cardColor: const Color(0xFF212121),
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.black54,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.white,
      inactiveTrackColor: Colors.white12,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.deepPurple,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.deepPurple,
        ),
      ),
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
        minimumSize: MaterialStateProperty.all<Size>(Size(
          double.maxFinite,
          50,
        )),
      ),
    ),
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    cardColor:  const Color(0xFFE5E5E5),
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.black,
      inactiveTrackColor: Colors.blueGrey,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.deepPurple,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.deepPurple,
        ),
      ),
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
        minimumSize: MaterialStateProperty.all<Size>(Size(
          double.maxFinite,
          50,
        )),
      ),
    ),
  );

  ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      if (value == null) {
        StorageManager.saveData('themeMode', _light);
        value = _light;
      }
      var themeMode = value ?? _light;
      themeName = value;
      if (themeMode == _light) {
        _themeData = lightTheme;
      } else {
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  dynamic currentTheme() {
    return StorageManager.readData('themeMode').then((value) => value);
  }

  void setDarkMode() async {
    themeName = 'dark';
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    themeName = _light;
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', _light);
    notifyListeners();
  }
}