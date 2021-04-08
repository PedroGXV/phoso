import 'package:flutter/material.dart';

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
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: 'fab${fabCounter.toString()}',
        elevation: 5,
        backgroundColor: (color != null) ? color : Theme.of(context).floatingActionButtonTheme.backgroundColor,
        onPressed: () {
          onPressed();
        },
        child: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
