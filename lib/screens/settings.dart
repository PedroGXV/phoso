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

  _SettingsState({@required this.version});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _buildList(
                icon: Icons.wb_sunny_outlined,
                listTitle: 'Tema',
                listSubtitle: 'Claro',
                onTap: () async {
                  await setState(() async {
                    String currentTheme = await PhosoApp.theme.currentTheme();

                    if (currentTheme == 'light') {
                      PhosoApp.theme.setDarkMode();
                    } else {
                      PhosoApp.theme.setLightMode();
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _buildList(
                icon: Icons.info_outline_rounded,
                listTitle: 'Version',
                listSubtitle: version,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<SharedPreferences> initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Widget _buildList({
    @required String listTitle,
    @required String listSubtitle,
    @required Function onTap,
    IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).accentColor,
            ),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              size: 30,
            ),
            title: Text(
              listTitle,
            ),
            subtitle: Text(
              listSubtitle,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
