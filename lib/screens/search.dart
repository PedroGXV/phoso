import 'package:flutter/material.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/components/phoso_card.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/models/photo_sound.dart';
import 'package:phoso/screens/view_phoso.dart';

enum DatabaseSearchType { equal, like }

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = new TextEditingController();

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                BackButton(),
                // Using Expanded to delimit the TextField width
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                          width: 2,
                        ),
                      ),
                      enabledBorder: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                          width: 2,
                        ),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                          width: 2,
                        ),
                      ),
                      disabledBorder: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                          width: 2,
                        ),
                      ),
                      hintText: 'Procurar',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (searchField) {
                      setState(() {
                        _searchController.text = searchField;
                        _searchController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: _searchController.text.length));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          _buildListView(),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return FutureBuilder<List<PhotoSound>>(
      future: AppDatabase.getWherePlaylistNameLike(_searchController.text),
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
            if (snapshot.data.length == 0 || _searchController.text.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        child: Icon(
                          Icons.error_outline,
                          size: 40,
                        ),
                        padding: const EdgeInsets.only(bottom: 20.0),
                      ),
                      Text(
                        (snapshot.data.length == 0) ? 'Nada encontrado!' : 'Digite algo para iniciar a pesquisa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: PhosoCard(
                        globalContext: context,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewPhoso(
                                photoSound: snapshot.data[index],
                              ),
                            ),
                          );
                        },
                        photoSound: snapshot.data[index],
                      ),
                    );
                  },
                ),
              ),
            );

            break;
        }

        return SizedBox();
      },
    );
  }
}
