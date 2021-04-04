import 'package:flutter/material.dart';

import '../main.dart';

class CustomFab extends StatelessWidget {

  static int fabCounter = 0;

  IconData icon;
  double width;
  Color color;
  Color iconColor;
  Function onPressed;

  CustomFab(
      {@required this.icon,
      this.width,
      this.color,
      this.iconColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    fabCounter++;
    return Container(
      width: (width == null) ? 55 : width,
      height: (width == null) ? 55 : width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            color: (PhosoApp.darkMode) ? Colors.white : Colors.black,
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: 'fab${fabCounter.toString()}',
        backgroundColor: (color == null)
            ? ((PhosoApp.darkMode) ? Colors.black : Colors.white)
            : color,
        elevation: 5,
        onPressed: () {
          onPressed();
        },
        child: Icon(
          icon,
          color: (iconColor == null)
              ? ((PhosoApp.darkMode) ? Colors.white : Colors.black)
              : iconColor,
        ),
      ),
    );
  }
}
