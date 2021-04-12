import 'package:flutter/material.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/components/phoso_card.dart';
import 'package:phoso/main.dart';
import 'package:phoso/screens/settings.dart';
import 'form_playlist.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/screens/view_phoso.dart';
import '../models/photo_sound.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHomeOptions(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [_buildListView()],
          ),
        ),
      ],
    );
  }

  String _newPlaylist = 'Nova Playlist';
  String _configs = 'Configurações';

  Widget _buildHomeOptions() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      child: Column(
        children: [
          _optionButton(
            _newPlaylist,
            Icons.add,
            () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FormPlaylist())),
            iconColor: Colors.blueAccent,
            fontColor: Colors.blueAccent,
          ),
          _optionButton(
            _configs,
            Icons.settings,
            () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Settings(version: PhosoApp.version))),
          ),
        ],
      ),
    );
  }

  Widget _optionButton(String txt, IconData icon, Function onTap,
      {Color fontColor, Color iconColor}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Icon(
              icon,
              color: (iconColor != null)
                  ? iconColor
                  : Theme.of(context).iconTheme.color,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                txt,
                style: TextStyle(
                  color: (fontColor != null)
                      ? fontColor
                      : Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  bool _playlistListOpen = true;

  Widget _buildListView() {
    return FutureBuilder<List<PhotoSound>>(
      initialData: [],
      future: AppDatabase.findAll(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            // TODO: Handle this case.
            break;
          case ConnectionState.waiting:
            Loading();
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
          case ConnectionState.done:
            if (snapshot.data.length == 0) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 45,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Text(
                          'Nenhuma playlist criada.',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Expanded(
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _playlistListOpen = !_playlistListOpen;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              'Playlists'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 17,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Icon(
                              (_playlistListOpen)
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _playlistListOpen,
                    child: Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return PhosoCard(
                              globalContext: _scaffoldKey.currentContext,
                              photoSound: snapshot.data[index],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewPhoso(
                                      photoSound: snapshot.data[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            break;
          default:
            return Text('Algo deu errado!');
            break;
        }
        return Loading();
      },
    );
  }
}
