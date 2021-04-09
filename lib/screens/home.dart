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
  @override
  Widget build(BuildContext context) {
    return _buildHome();
  }

  Widget _buildHome() {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: Icon(Icons.home_outlined),
        title: Text(
          'Home',
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 4,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: Column(
              children: [
                _optionButton(
                  'Nova Playlist',
                  Icons.add,
                  () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FormPlaylist())),
                ),
                _optionButton(
                  'Configurações',
                  Icons.settings,
                  () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Settings(version: PhosoApp.version))),
                ),
              ],
            ),
          ),
          _buildListView(),
        ],
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
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  (snapshot.data.length == 0)
                      ? Center(
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
                        )
                      : Expanded(
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
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(10),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return PhosoCard(
                                        photoSound: snapshot.data[index],
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ViewPhoso(
                                                playlistName: snapshot
                                                    .data[index].playlistName,
                                                photoSrc: snapshot
                                                    .data[index].photoSrc,
                                                soundSrc: snapshot
                                                    .data[index].soundSrc,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
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

  Widget _optionButton(
    String txt,
    IconData icon,
    Function onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
        ),
        onPressed: () {
          onTap();
        },
        child: Row(children: [
          Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              txt,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void setHomeState(Function onState) {
    setState(() {
      onState();
    });
  }
}
