import 'package:flutter/material.dart';
import 'package:phoso/main.dart';

class Loading extends StatelessWidget {
  final String msg;

  Loading({this.msg = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 8,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            msg,
            style: TextStyle(
              fontSize: 25,
              color: (PhosoApp.darkMode)
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
