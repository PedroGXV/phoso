import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final List<Widget> contents;
  final List<Widget> actions;
  final bool dismissible;

  CustomDialog({
    @required this.title,
    this.contents,
    this.actions,
    this.dismissible,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}
