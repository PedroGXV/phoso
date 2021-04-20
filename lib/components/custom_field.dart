import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  // globalContext is to get the correct theme
  final BuildContext globalContext;
  final String fieldLabel;
  final String fieldTagName;
  final Widget fieldWidget;

  final EdgeInsetsGeometry _allPadding = EdgeInsets.all(12);

  static Map<String, bool> _containerOpen = Map();

  CustomField({
    @required this.globalContext,
    @required this.fieldLabel,
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
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              CustomField._containerOpen[widget.fieldTagName] =
                  !CustomField._containerOpen[widget.fieldTagName];
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: widget._allPadding,
                  child: Row(
                    children: [
                      Text(
                        widget.fieldLabel,
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(widget.globalContext).textTheme.bodyText1.color,
                        ),
                      ),
                      Icon(
                        (CustomField._containerOpen[widget.fieldTagName])
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Theme.of(widget.globalContext).iconTheme.color,
                      ),
                    ],
                  ),
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
