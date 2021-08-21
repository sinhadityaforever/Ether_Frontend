import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizButton extends StatefulWidget {
  QuizButton({
    required this.textOfButton,
    required this.isCorrect,
  });

  final String textOfButton;

  final bool isCorrect;

  @override
  _QuizButtonState createState() => _QuizButtonState();
}

class _QuizButtonState extends State<QuizButton> {
  @override
  Widget build(BuildContext context) {
    Color _color = Colors.black;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: _color,
        borderRadius: BorderRadius.circular(30.0.r),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () {
            setState(() {
              if (widget.isCorrect == true) {
                _color = Colors.green;
              } else {
                _color = Colors.red;
              }
            });
          },
          minWidth: 200.w,
          height: 42.0.h,
          child: Text(
            widget.textOfButton,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
