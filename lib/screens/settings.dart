import 'package:flutter/material.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/components/response_dialogs.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/main.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/deleting.dart';

class Settings extends StatefulWidget {
  final String version;
  final BuildContext globalContext;

  Settings({
    @required this.globalContext,
    @required this.version,
  });

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: PhosoApp.themeNotifier.currentTheme(),
      initialData: null,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
          ),
          body: _buildBody(snapshot.data),
        );
      }
    );
  }

  Widget _buildBody(dynamic theme) {
    return ListView(
      children: [
        _buildField(
          icon: (theme == 'light') ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
          listTitle: 'Tema',
          listSubtitle: (theme == 'light') ? 'Claro' : 'Escuro',
          onTap: () {
            setState(() {
              if (theme == 'light') {
                PhosoApp.themeNotifier.setDarkMode();
              } else {
                PhosoApp.themeNotifier.setLightMode();
              }
            });
          },
        ),
        _buildField(
          listTitle: 'Reset'.toUpperCase(),
          listSubtitle: 'Reset all playlists',
          icon: Icons.delete_forever,
          listColor: Colors.redAccent,
          onTap: () {
            final List<int> resetList = [1];

            PhotoSound.phoso.forEach((element) {
              resetList.add(element.id);
            });

            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Deleting(idTarget: resetList)),
            );
          },
        ),
        _buildField(
          icon: Icons.info_outline_rounded,
          listTitle: 'Version',
          listSubtitle: widget.version,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildField({
    @required String listTitle,
    String listSubtitle,
    @required Function onTap,
    IconData icon,
    Color listColor,
  }) {
    return Material(
      color: (listColor == null) ? Colors.transparent : listColor,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
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
