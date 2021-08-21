import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizButton extends StatefulWidget {
  QuizButton({
    required this.onPressedRoundButton,
    required this.textOfButton,
  });

  final String textOfButton;
  final onPressedRoundButton;

  @override
  _QuizButtonState createState() => _QuizButtonState();
}

class _QuizButtonState extends State<QuizButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: widget.colorOfButton,
        borderRadius: BorderRadius.circular(30.0.r),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: widget.onPressedRoundButton,
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
