import 'package:flutter/material.dart';
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
    _getCurrentTheme().then((value) {
      _theme = value;
      print(_theme);
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
            icon: (_theme == 'light') ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
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
            onTap: () {},
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

  Future<String> _getCurrentTheme() async {
    return await PhosoApp.theme.currentTheme();
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
            color: (listColor == null)
                ? Colors.transparent
                : listColor,
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
