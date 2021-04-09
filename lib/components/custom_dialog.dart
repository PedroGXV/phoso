import 'package:flutter/material.dart';

class CustomDialog {
  BuildContext context;
  String title;
  List<Widget> contents;
  List<Widget> actions;
  bool dismissible;

  CustomDialog({
    @required this.context,
    @required this.title,
    this.contents,
    this.actions,
    this.dismissible,
  }) {
    showDialog(
      context: context,
      barrierDismissible: (dismissible) ? dismissible : false,
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
