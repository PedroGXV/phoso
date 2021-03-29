import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoso/components/custom_fab.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/models/hex_color.dart';
import 'package:phoso/screens/deleting.dart';
import 'package:phoso/screens/settings.dart';
import '../main.dart';
import 'file:///C:/Users/Usuario/Documents/Programacao/flutter/code/phoso/lib/screens/form_playlist.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/screens/view_phoso.dart';
import '../models/photo_sound.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    return _buildHome();
  }

  Widget _buildHome() {
    return Scaffold(
      backgroundColor: (PhosoApp.darkMode) ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.home_outlined),
        title: Text('Home'),
      ),
      body: _buildListView(),
      bottomNavigationBar: (PhosoApp.editCard)
          ? Container(
              height: 65,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: (PhosoApp.darkMode) ? Colors.black : Colors.white,
                    blurRadius: 15,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: BottomAppBar(
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            if (PhosoApp.editTarget != null) {
                              await Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => Deleting(
                                          idTarget: PhosoApp.editTarget),
                                    ),
                                  )
                                  .then((value) => setState(() {
                                        PhosoApp.editCard = false;
                                        PhosoApp.editTarget = null;
                                      }));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Container(
                              height: double.maxFinite,
                              margin: EdgeInsets.only(right: 8.0),
                              alignment: Alignment.center,
                              child: (PhosoApp.editTarget == null)
                                  ? Text(
                                      'Selecione uma playlist',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 22,
                                      ),
                                    )
                                  : Text(
                                      'Excluir'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              PhosoApp.editCard = false;
                              PhosoApp.editTarget = null;
                            });
                          },
                          child: Container(
                            height: double.maxFinite,
                            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (PhosoApp.editCard) ? null : _buildFab(),
    );
  }

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
            return Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    PhosoApp.editCard = false;
                    PhosoApp.editTarget = null;
                  });
                },
                child: Container(
                  color: (PhosoApp.darkMode) ? Colors.black : Colors.white,
                  height: double.maxFinite,
                  child: (snapshot.data.length == 0)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mood_bad_outlined,
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
                        )
                      : GridView.count(
                          padding: EdgeInsets.all(10),
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          children:
                              List.generate(snapshot.data.length, (index) {
                            return PhosoCard(
                              photoSound: snapshot.data[index],
                              onTap: () {
                                (PhosoApp.editCard)
                                    ? setState(() {
                                        if (PhosoApp.editTarget ==
                                            snapshot.data[index].id) {
                                          PhosoApp.editTarget = null;
                                          PhosoApp.editCard = false;
                                        } else {
                                          PhosoApp.editTarget =
                                              snapshot.data[index].id;
                                        }
                                      })
                                    : Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ViewPhoso(
                                            playlistName: snapshot
                                                .data[index].playlistName,
                                            photoSrc:
                                                snapshot.data[index].photoSrc,
                                            soundSrc:
                                                snapshot.data[index].soundSrc,
                                          ),
                                        ),
                                      );
                              },
                            );
                          }),
                        ),
                ),
              ),
            );
            break;
        }
        return Text('');
      },
    );
  }

  Widget _buildIconButton(IconData icon, Function onPressed) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 30,
      color: Colors.white,
      onPressed: () {
        onPressed();
      },
    );
  }

  bool _fabOpen = false;

  void _toggleFab() {
    setState(() {
      _fabOpen = !_fabOpen;
    });
  }

  Widget _buildFab() {
    return SizedBox.expand(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.none,
          children: [
            CustomFab(
              icon: (_fabOpen) ? Icons.close : Icons.more_vert_rounded,
              color: (_fabOpen) ? Colors.redAccent : null,
              iconColor: (_fabOpen) ? Colors.white : null,
              onPressed: () => _toggleFab(),
            ),
            Visibility(
              visible: _fabOpen,
              child: Container(
                margin: EdgeInsets.only(bottom: 75),
                child: CustomFab(
                  icon: Icons.add,
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PathPick(),
                      ),
                    );

                    setState(() {});
                  },
                ),
              ),
            ),
            Visibility(
              visible: _fabOpen,
              child: Container(
                margin: EdgeInsets.only(bottom: 150),
                child: CustomFab(
                  icon: Icons.edit_outlined,
                  onPressed: () async {
                    setState(() {
                      PhosoApp.editCard = true;
                    });
                  },
                ),
              ),
            ),
            Visibility(
              visible: _fabOpen,
              child: Container(
                margin: EdgeInsets.only(bottom: 225),
                child: CustomFab(
                  icon: Icons.settings,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Settings()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PhosoCard(
      {@required Function onTap, @required PhotoSound photoSound}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
            color: HexColor.fromHex("#FF1A0926"),
            width: 3,
          ),
        ),
        // height: double.maxFinite,
        child: Material(
          color: (PhosoApp.editTarget == photoSound.id)
              ? Colors.white
              : Theme.of(context).primaryColor,
          child: InkWell(
            onTap: () {
              onTap();
            },
            onLongPress: () {
              setState(() {
                PhosoApp.editCard = true;
                PhosoApp.editTarget = photoSound.id;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 90,
                      ),
                    ],
                  ),
                  child: Image.file(
                    File(photoSound.photoSrc),
                    height: 125,
                  ),
                ),
                Text(
                  photoSound.playlistName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: (PhosoApp.editTarget == photoSound.id)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
