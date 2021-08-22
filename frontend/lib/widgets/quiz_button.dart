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
  Color _color = Color(0xFF0A0E21);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        color: _color,
        minWidth: 200.w,
        onPressed: () {
          setState(() {
            if (widget.isCorrect == true) {
              _color = Colors.green;
            } else {
              _color = Colors.red;
            }
          });
        },
        onLongPress: () {
          setState(() {
            _color = Color(0xFF0A0E21);
          });
        },
        child: Text(
          widget.textOfButton,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
