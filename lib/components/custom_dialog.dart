import 'package:flutter/material.dart';

class CustomDialog {
  BuildContext context;
  String title;
  Map<String, Function> contents;
  Map<String, Function> actions;

  CustomDialog({
    @required this.context,
    @required this.title,
    this.contents,
    this.actions,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: (contents != null) ? _generateContents() : null,
          ),
          actions: (actions != null) ? _generateActions() : null,
        );
      },
    );
  }

  List<ListTile> _generateContents() {
    List<ListTile> listTiles = [];

    contents.forEach((key, value) {
      listTiles.add(
        ListTile(
          title: Text(key),
          onTap: () {
            value();
          },
        ),
      );
    });

    return listTiles;
  }

  List<TextButton> _generateActions() {
    List<TextButton> actionButtons = [];

    this.actions.forEach((key, value) {
      actionButtons.add(
        TextButton(
          onPressed: () {
            value();
          },
          child: Text(key),
        ),
      );
    });

    return actionButtons;
  }
}
