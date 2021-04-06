import 'package:flutter/material.dart';
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

class PhosoApp extends StatelessWidget {
  static ThemeNotifier theme;


  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        PhosoApp.theme = theme;

        return MaterialApp(
          theme: theme.getTheme(),
          home: Home(),
        );
      },
    );
  }
}