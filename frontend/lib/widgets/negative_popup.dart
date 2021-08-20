import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NegativePopup extends StatelessWidget {
  final String popuptext;
  final String negativeTitle;
  final onPresseedPopup;
  final String action;
  NegativePopup({
    required this.popuptext,
    required this.onPresseedPopup,
    required this.negativeTitle,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(negativeTitle),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(popuptext),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).accentColor,
          child: const Text('Close'),
        ),
        SizedBox(
          width: 70.w,
        ),
        new FlatButton(
          onPressed: onPresseedPopup,
          textColor: Theme.of(context).accentColor,
          child: Text(action),
        ),
      ],
    );
  }
}
