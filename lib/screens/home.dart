import 'package:flutter/material.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/components/phoso_card.dart';
import 'package:phoso/main.dart';
import 'package:phoso/screens/deleting.dart';
import 'package:phoso/screens/search.dart';
import 'package:phoso/screens/settings.dart';
import 'form_playlist.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/screens/view_phoso.dart';
import '../models/photo_sound.dart';
import 'dart:math' as math;

enum SortBy { none, alphabetAsc, alphabetDesc, recent, older }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool _cardEditable;

  SortBy sortBy;
  String orderBy;

  @override
  void initState() {
    sortBy = SortBy.none;
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);

    if (sortBy == SortBy.none) {
      orderBy = null;
    }
    if (sortBy == SortBy.alphabetAsc) {
      // sqflite uses ASC by default
      orderBy = 'playlistName DESC';
    }
    if (sortBy == SortBy.alphabetDesc) {
      orderBy = 'playlistName';
    }
    if (sortBy == SortBy.recent) {
      orderBy = 'id DESC';
    }
    if (sortBy == SortBy.older) {
      orderBy = 'id';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 8.0, 12.0, 8.0),
            child: Material(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).primaryColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Search(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search_rounded),
                ),
              ),
            ),
          ),
        ],
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
            children: [
              _buildListView(),
            ],
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
            () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => FormPlaylist()),
            ),
            iconColor: Colors.blueAccent,
            fontColor: Colors.blueAccent,
          ),
          _optionButton(
            _configs,
            Icons.settings,
            () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Settings(globalContext: context, version: PhosoApp.version))),
          ),
        ],
      ),
    );
  }

  Widget _optionButton(String txt, IconData icon, Function onTap, {Color fontColor, Color iconColor}) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 10.0, 10.0, 10.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 25,
                color: (iconColor != null) ? iconColor : Theme.of(context).iconTheme.color,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  txt,
                  style: TextStyle(
                    color: (fontColor != null) ? fontColor : Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return FutureBuilder<List<PhotoSound>>(
      initialData: [],
      future: AppDatabase.findAll(orderBy: orderBy),
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
            if (snapshot.data == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
                  child: Text(
                    'Houve um erro no banco de dados. Tente reinstalar o app, ou contacte o suporte.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 6.0, 14.0, 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Playlists',
                          style: TextStyle(
                            fontSize: 17,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Row(
                          children: [
                            PopupMenuButton<SortBy>(
                              shape: Border.all(
                                color: Theme.of(context).accentColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('Organizar por'),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Icon(Icons.sort_outlined),
                                    ),
                                  ],
                                ),
                              ),
                              onSelected: (SortBy value) {
                                setState(() {
                                  sortBy = value;
                                });
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
                                PopupMenuItem<SortBy>(
                                  value: SortBy.recent,
                                  child: _popUpMenuItemChild(
                                    'Recente',
                                    '🗓️',
                                  ),
                                ),
                                PopupMenuItem<SortBy>(
                                  value: SortBy.older,
                                  child: _popUpMenuItemChild(
                                    'Mais velho',
                                    '🗓️',
                                  ),
                                ),
                                PopupMenuItem<SortBy>(
                                  value: SortBy.alphabetAsc,
                                  child: _popUpMenuItemChild(
                                    'Alfabético',
                                    'A-Z',
                                  ),
                                ),
                                PopupMenuItem<SortBy>(
                                  value: SortBy.alphabetDesc,
                                  child: _popUpMenuItemChild(
                                    'Alfabético',
                                    'Z-A',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  (_cardEditable != null)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _playlistListOptions(
                              color: Colors.redAccent.withOpacity(0.5),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Deleting(idTarget: PhosoCard.targets),
                                ),
                              ),
                              title: 'Excluir',
                              icon: Icons.delete_sweep_outlined,
                            ),
                            _playlistListOptions(
                              color: Colors.grey.withOpacity(0.5),
                              onTap: () {
                                setState(() {
                                  PhosoCard.targets.clear();
                                  _cardEditable = null;
                                });
                              },
                              title: 'Cancelar',
                              icon: Icons.cancel,
                            ),
                          ],
                        )
                      : SizedBox(),
                  Expanded(
                    child: Scrollbar(
                      isAlwaysShown: true,
                      radius: Radius.circular(100),
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: PhosoCard(
                              globalContext: context,
                              photoSound: snapshot.data[index],
                              onTap: () {
                                // if editable is not null do not open the ViewPhoso screen
                                // instead, handle the multiple selection PhosoCard
                                (_cardEditable != null)
                                    ? (PhosoCard.targets.contains(snapshot.data[index].id))
                                        ? PhosoCard.targets.remove(snapshot.data[index].id)
                                        : PhosoCard.targets.add(snapshot.data[index].id)
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ViewPhoso(
                                            photoSound: snapshot.data[index],
                                          ),
                                        ),
                                      );
                              },
                              onLongPress: () {
                                setState(() {
                                  _cardEditable = false;
                                  if (!PhosoCard.targets.contains(snapshot.data[index].id)) {
                                    PhosoCard.targets.add(snapshot.data[index].id);
                                  }
                                });
                              },
                              deleteTarget: _cardEditable,
                            ),
                          );
                        },
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

  Widget _popUpMenuItemChild(
    String itemName,
    String itemDesc,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(itemName),
        Text(
          itemDesc,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _playlistListOptions({
    @required Color color,
    @required Function onTap,
    @required String title,
    @required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
