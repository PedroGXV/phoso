import 'package:flutter/material.dart';

class CustomDialog {
  BuildContext context;
  String title;
  List<Widget> contents;
  List<Widget> actions;

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
            children: (contents != null) ? this.contents : [],
          ),
          actions: (actions != null) ? this.actions : [],
        );
      },
    );
  }

}
