import 'package:flutter/material.dart';
import 'package:phoso/components/custom_dialog.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  String version;

  Settings({@required this.version});

  @override
  _SettingsState createState() => _SettingsState(version: version);
}

class _SettingsState extends State<Settings> {
  String version;
  String _theme;

  _SettingsState({@required this.version});

  @override
  void setState(fn) {
    PhosoApp.theme.currentTheme().then((value) {
      _theme = value;
      super.setState(fn);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildField(
            icon: (_theme == 'light')
                ? Icons.wb_sunny_outlined
                : Icons.nights_stay_outlined,
            listTitle: 'Tema',
            listSubtitle: (_theme == 'light') ? 'Claro' : 'Escuro',
            onTap: () {
              setState(() {
                if (_theme == 'light') {
                  PhosoApp.theme.setDarkMode();
                } else {
                  PhosoApp.theme.setLightMode();
                }
              });
            },
          ),
          _buildField(
            listTitle: 'Reset'.toUpperCase(),
            listSubtitle: 'Reset all playlists',
            icon: Icons.delete_forever,
            listColor: Colors.redAccent,
            onTap: () async {
              CustomDialog(
                context: context,
                title: 'Deletando...',
                contents: [
                  Loading(),
                ],
              );
              await AppDatabase.drop().then((value) {
                CustomDialog(
                  context: context,
                  title: 'Deletado!',
                  contents: [
                    Icon(
                      Icons.done_all_outlined,
                      color: Colors.green,
                      size: 25,
                    ),
                  ],
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
                      child: Text('OK'),
                    ),
                  ],
                );
              }).onError((error, stackTrace) {
                CustomDialog(
                  context: context,
                  title: 'Erro!',
                  contents: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 25,
                    ),
                    Text('Algo deu errado na exclusão, tente novamente mais tarde.'),
                  ],
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
                      child: Text('OK'),
                    ),
                  ],
                );
              });
            },
          ),
          _buildField(
            icon: Icons.info_outline_rounded,
            listTitle: 'Version',
            listSubtitle: version,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildField(
      {@required String listTitle,
      String listSubtitle,
      @required Function onTap,
      IconData icon,
      Color listColor}) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color: (listColor == null) ? Colors.transparent : listColor,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).accentColor,
              ),
              top: BorderSide(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                icon,
                size: 30,
              ),
              title: Text(
                listTitle,
              ),
              subtitle: (listSubtitle == null)
                  ? null
                  : Text(
                      listSubtitle,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
