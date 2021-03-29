import 'package:flutter/material.dart';
import 'package:phoso/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhosoApp.darkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildList(
            icon: (PhosoApp.darkMode)
                ? Icons.nightlight_round
                : Icons.wb_sunny_outlined,
            listTitle: 'Tema',
            listSubtitle: (PhosoApp.darkMode) ? 'Escuro' : 'Claro',
            onTap: () async {
              await setState(() {
                PhosoApp.darkMode = !PhosoApp.darkMode;
              });

              SharedPreferences prefs = await initPrefs();
              prefs.setBool('darkMode', PhosoApp.darkMode);
              print(prefs.getBool('darkMode'));
            },
          ),
          _buildList(
            icon: Icons.info_outline_rounded,
            listTitle: 'Version',
            listSubtitle: '0.3.0',
            onTap: () {},
          ),
        ],
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
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
            ),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
              size: 30,
            ),
            title: Text(
              listTitle,
              style: TextStyle(
                color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              listSubtitle,
              style: TextStyle(
                color: (PhosoApp.darkMode) ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
