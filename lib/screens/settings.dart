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
    PhosoApp.themeNotifier.currentTheme().then((value) {
      _theme = value;
      super.setState(fn);
    });
  }

  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    setState(() {});

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Visibility(
            visible: _deleting,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Loading(
                msg: 'Deletando...',
              ),
            ),
          ),
          Visibility(
            visible: !_deleting,
            child: Expanded(
              child: ListView(
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
                    onTap: () async {
                      setState(() {
                        _deleting = true;
                      });

                      await AppDatabase.drop().then((value) {
                        setState(() {
                          _deleting = false;
                        });

                        CustomDialog(
                          context: context,
                          title: 'Deletado!',
                          contents: [
                            Icon(
                              Icons.done_all_outlined,
                              color: Colors.green,
                              size: 75,
                            ),
                          ],
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (_) => false),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('OK'),
                              ),
                            ),
                          ],
                        );
                      }).onError((error, stackTrace) {
                        setState(() {
                          _deleting = false;
                        });

                        CustomDialog(
                          context: context,
                          title: 'Erro!',
                          contents: [
                            Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 25,
                            ),
                            Text(
                                'Algo deu errado na exclusão, tente novamente mais tarde.'),
                          ],
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (_) => false),
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
            ),
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
      color: Theme.of(context).backgroundColor,
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
