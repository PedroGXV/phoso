import 'package:flutter/material.dart';
import 'package:phoso/components/loading.dart';
import 'package:phoso/database/app_database.dart';

class Deleting extends StatefulWidget {
  final List<int> idTarget;

  Deleting({
    @required this.idTarget,
  }) : assert(idTarget != null);

  @override
  _DeletingState createState() => _DeletingState();
}

class _DeletingState extends State<Deleting> {
  List<int> _targets;
  bool _deleting;

  @override
  void initState() {
    _targets = widget.idTarget;
    _deleting = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _setDelete();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          leading: Container(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Text('Excluir playlist'),
            ],
          ),
        ),
        body: (_deleting)
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
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                    ),
                    Text(
                      'id: ${_targets}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _setDelete() async {
    setState(() {
      _deleting = true;
    });

    this.widget.idTarget.forEach((element) async {
      await AppDatabase.delete(
        where: "id = ?",
        whereArgs: [element],
      ).then((value) {
        this.widget.idTarget.remove(element);
        print(this.widget.idTarget.isEmpty);
        if (this.widget.idTarget.isEmpty) {
          setState(() {
            _deleting = false;
          });
        }
      });
    });

    setState(() {
      _deleting = false;
    });
  }
}
