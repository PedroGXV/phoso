import 'package:flutter/material.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/database/app_database.dart';
import 'package:phoso/main.dart';

class Deleting extends StatefulWidget {
  int idTarget;

  Deleting({
    @required this.idTarget,
  });

  @override
  _DeletingState createState() => _DeletingState(
        idTarget: this.idTarget,
      );
}

class _DeletingState extends State<Deleting> {
  int idTarget;
  bool _deleting;

  _DeletingState({
    @required this.idTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (PhosoApp.darkMode)
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
        title: Text('Exlcuir playlist'),
      ),
      body: FutureBuilder(
        future: _setDelete(),
        initialData: [],
        builder: (context, snapshot) {
          return (_deleting)
              ? Loading(
                  msg: 'Excluindo...',
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.done_outline_outlined,
                          color: Colors.green,
                          size: 75,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Playlist excluida.',
                          style: TextStyle(
                            fontSize: 30,
                            color: (PhosoApp.darkMode)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        'id: $idTarget',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Future<Widget> _setDelete() async {
    setState(() {
      _deleting = true;
    });

    await AppDatabase.delete(
      where: "id = ?",
      whereArgs: [this.idTarget],
    ).then(
      (value) {
        _deleting = false;
      },
    );
  }
}
