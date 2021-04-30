import 'package:flutter/material.dart';
import 'package:phoso/components/phoso_list.dart';
import 'package:phoso/database/app_database.dart';

enum DatabaseSearchType { equal, like }

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = new TextEditingController();

  AppDatabase db = new AppDatabase();

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                            TextSelection.fromPosition(TextPosition(offset: _searchController.text.length));
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
          PhosoList(
            findAll: false,
            playlistName: _searchController.text,
          ),
        ],
      ),
    );
  }
}
