import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:phoso/components/custom_fab.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/components/phoso_card.dart';
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
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    return _buildHome();
  }

  Widget _buildHome() {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                onTap: () {},
                child: Container(
                  color: Theme.of(context).backgroundColor,
                  height: double.maxFinite,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PathPick(),
                                    ),
                                  );

                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).dividerColor,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        'Adicionar Playlist',
                                        style: TextStyle(
                                          fontSize: 21,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                                          photoSrc:
                                              snapshot.data[index].photoSrc,
                                          soundSrc:
                                              snapshot.data[index].soundSrc,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ],
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
                  icon: Icons.settings,
                  onPressed: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    String version = packageInfo.version;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => Settings(
                                version: version,
                              )),
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
