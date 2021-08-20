import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterestButton extends StatelessWidget {
  final String textOfWidget;
  final bool isSelected;
  final onPressedInterestButton;
  final onLongTap;

  InterestButton(
      {this.onPressedInterestButton,
      required this.isSelected,
      required this.textOfWidget,
      required this.onLongTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 250.w, height: 65.h),
        child: GestureDetector(
          onLongPress: onLongTap,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: isSelected ? Color(0xFFEB1555) : Color(0xFF090E11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              side: BorderSide(
                color: Color(0xFFEB1555),
              ),
            ),
            onPressed: onPressedInterestButton,
            child: Text(
              textOfWidget,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
