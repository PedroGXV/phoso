import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  // globalContext is to get the correct theme
  final BuildContext globalContext;
  final Widget fieldWidgetLabel;
  final String fieldTagName;
  final Widget fieldWidget;

  final EdgeInsetsGeometry _allPadding = EdgeInsets.all(12);

  static Map<String, bool> _containerOpen = Map();

  CustomField({
    @required this.globalContext,
    @required this.fieldWidgetLabel,
    @required this.fieldTagName,
    @required this.fieldWidget,
  });

  @override
  _CustomFieldState createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    if (!CustomField._containerOpen.containsKey(widget.fieldTagName)) {
      CustomField._containerOpen.addAll({
        widget.fieldTagName: true,
      });
    }

    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              CustomField._containerOpen[widget.fieldTagName] = !CustomField._containerOpen[widget.fieldTagName];
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: widget._allPadding,
                  child: widget.fieldWidgetLabel,
                ),
                Visibility(
                  visible: CustomField._containerOpen[widget.fieldTagName],
                  child: widget.fieldWidget,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
