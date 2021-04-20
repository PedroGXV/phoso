import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

class ResponseDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final Function buttonFunction;
  final IconData icon;
  final Color colorIcon;

  ResponseDialog({
    this.title = "",
    this.message = "",
    this.icon,
    this.buttonText = 'Ok',
    this.buttonFunction,
    this.colorIcon = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.withOpacity(0.3),
        ),
        AlertDialog(
          title: Visibility(
            child: Text(title),
            visible: title.isNotEmpty,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Icon(
                    icon,
                    size: 64,
                    color: colorIcon,
                  ),
                ),
                visible: icon != null,
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ),
                visible: message.isNotEmpty,
              )
            ],
          ),
          actions: [
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                if (this.buttonFunction != null) {
                  this.buttonFunction();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Function buttonFunction;

  SuccessDialog(
    this.message, {
    this.title = 'Success',
    this.icon = Icons.done,
    this.buttonFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ResponseDialog(
      title: title,
      message: message,
      icon: icon,
      colorIcon: Colors.green,
      buttonFunction: this.buttonFunction,
    );
  }
}

class FailureDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  FailureDialog(
    this.message, {
    this.title = 'Failure',
    this.icon = Icons.warning,
  });

  @override
  Widget build(BuildContext context) {
    return ResponseDialog(
      title: title,
      message: message,
      icon: icon,
      colorIcon: Colors.red,
    );
  }
}

class LoadingDialog extends StatelessWidget {
  final String loadingMessage;

  const LoadingDialog({this.loadingMessage = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Loading(
      msg: loadingMessage,
    );
  }
}
