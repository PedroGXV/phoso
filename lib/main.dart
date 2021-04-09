import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:phoso/models/theme_notifier.dart';
import 'package:phoso/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => new ThemeNotifier(),
      child: PhosoApp(),
    ),
  );
}

class PhosoApp extends StatefulWidget {
  static ThemeData theme;
  static ThemeNotifier themeNotifier = new ThemeNotifier();
  static String version;

  @override
  _PhosoAppState createState() => _PhosoAppState();
}

class _PhosoAppState extends State<PhosoApp> {


  @override
  void initState() {
    PackageInfo.fromPlatform().then((value) {
      PhosoApp.version = value.version;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        PhosoApp.theme = theme.getTheme();
        PhosoApp.themeNotifier = theme;
        // theme = PhosoApp.themeNotifier;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.getTheme(),
          home: Home(),
        );
      },
    );
  }
}