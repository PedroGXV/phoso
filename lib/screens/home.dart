import 'package:flutter/material.dart';
import 'package:phoso/components/phoso_list.dart';
import 'package:phoso/main.dart';
import 'package:phoso/screens/search.dart';
import 'package:phoso/screens/settings.dart';
import 'form_playlist.dart';
import 'package:phoso/database/app_database.dart';

enum SortBy { none, alphabetAsc, alphabetDesc, recent, older }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AppDatabase db = new AppDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              PhosoList(),
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
            () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Settings(globalContext: context, version: PhosoApp.version))),
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
}
