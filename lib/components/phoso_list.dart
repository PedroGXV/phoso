import 'package:flutter/material.dart';
import 'package:phoso/components/phoso_card.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/deleting.dart';
import 'package:phoso/screens/view_phoso.dart';

import 'loading.dart';

enum SortBy { none, recent, older, favorite }

class PhosoList extends StatefulWidget {
  final bool findAll;
  final String playlistName;

  PhosoList({
    this.findAll = true,
    this.playlistName,
  }) : assert(findAll != null);

  @override
  _PhosoListState createState() => _PhosoListState();
}

class _PhosoListState extends State<PhosoList> {
  AppDatabase db = new AppDatabase();

  bool _cardEditable;

  SortBy sortBy = SortBy.none;
  String orderBy;

  @override
  void setState(fn) {
    print('1 $orderBy');
    super.setState(fn);

    if (sortBy == SortBy.none) {
      orderBy = null;
    }
    if (sortBy == SortBy.recent) {
      orderBy = 'id DESC';
    }
    if (sortBy == SortBy.older) {
      orderBy = 'id';
    }
    if (sortBy == SortBy.favorite) {
      orderBy = 'favorite DESC';
    }
    print(orderBy);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PhotoSound>>(
      initialData: [],
      future: (widget.findAll) ? db.findAll(orderBy: orderBy) : db.getWherePlaylistNameLike(widget.playlistName),
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
            print(widget.playlistName);

            if (widget.playlistName != null) {
              if (widget.playlistName.isEmpty) {
                return _listAlert('Digite algo para iniciar a busca.', Icons.search_off);
              }
            }

            if (snapshot.data == null) {
              return _listAlert(
                  'Database não foi alcançada. Reinicie o app, ou entre em contato com o suporte', Icons.error);
            }

            if (snapshot.data.length == 0) {
              return _listAlert('Nenhuma playlist encontrada.', Icons.cancel);
            }

            print(MediaQuery.of(context).size.width / 2.5 <= 500);

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
                            letterSpacing: 1.1,
                          ),
                        ),
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
                          tooltip: 'Abrir menu',
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
                              value: SortBy.favorite,
                              child: _popUpMenuItemChild(
                                'Favoritos',
                                '❤',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  (_cardEditable != null)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2.5 <= 500
                                    ? MediaQuery.of(context).size.width / 2.5
                                    : 500,
                                child: _playlistListOptions(
                                  color: Colors.redAccent.withOpacity(0.7),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Deleting(idTarget: PhosoCard.targets),
                                    ),
                                  ),
                                  title: 'Excluir',
                                  icon: Icons.delete_sweep_outlined,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.5 <= 500
                                    ? MediaQuery.of(context).size.width / 2.5
                                    : 500,
                                child: _playlistListOptions(
                                  color: Colors.grey.withOpacity(0.7),
                                  onTap: () {
                                    setState(() {
                                      PhosoCard.targets.clear();
                                      _cardEditable = null;
                                    });
                                  },
                                  title: 'Cancelar',
                                  icon: Icons.cancel_outlined,
                                ),
                              ),
                            ],
                          ),
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

  Widget _playlistListOptions({
    @required Color color,
    @required Function onTap,
    @required String title,
    @required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
          alignment: Alignment.center,
          backgroundColor: MaterialStateProperty.all<Color>(color),
          foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title.toUpperCase()),
            Icon(icon),
          ],
        ),
      ),
    );
  }

  Widget _listAlert(String msg, IconData icon) {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25, 150, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
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
}
