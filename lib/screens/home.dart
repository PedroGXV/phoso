import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoso/components/custom_fab.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/components/phoso_card.dart';
import 'package:phoso/models/hex_color.dart';
import 'package:phoso/screens/deleting.dart';
import 'package:phoso/screens/settings.dart';
import '../main.dart';
import 'form_playlist.dart';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFab(),
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
                      : ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return PhosoCard(
                              photoSound: snapshot.data[index],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewPhoso(
                                      playlistName:
                                          snapshot.data[index].playlistName,
                                      photoSrc: snapshot.data[index].photoSrc,
                                      soundSrc: snapshot.data[index].soundSrc,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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

  void setHomeState(Function onState) {
    setState(() {
      onState();
    });
  }
}
