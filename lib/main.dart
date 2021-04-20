import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:phoso/components/loading.dart';
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
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        initialData: null,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return MaterialApp(
                home: Scaffold(
                  body: Text('Erro ao inicializar. Contate o suporte.'),
                ),
              );
              break;
            case ConnectionState.waiting:
              return MaterialApp(
                home: Scaffold(
                  body: Loading(),
                ),
              );
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              if (snapshot.data != null) {
                PhosoApp.version = snapshot.data.version;
                return Consumer<ThemeNotifier>(
                  builder: (context, theme, child) {
                    PhosoApp.theme = theme.getTheme();
                    PhosoApp.themeNotifier = theme;

                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: theme.getTheme(),
                      home: Home(),
                    );
                  },
                );
              }
              break;
          }
          return MaterialApp(
            home: Scaffold(
              body: SizedBox(),
            ),
          );
        });
  }
}
