import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  final String popuptext;
  final String popupTitle;
  bool modifiedAction;
  final onPressedOK;

  Popup(
      {required this.popuptext,
      required this.popupTitle,
      this.modifiedAction = false,
      this.onPressedOK});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(popupTitle),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(popuptext),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: modifiedAction
              ? onPressedOK
              : () {
                  Navigator.of(context).pop();
                },
          textColor: Theme.of(context).accentColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
