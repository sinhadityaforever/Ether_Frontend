import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenButton extends StatelessWidget {
  final String textOfWidget;
  final IconData iconOfWidget;
  final bool isSelected;
  final onPressedInterestButton;
  final onLongTap;

  ScreenButton({
    required this.onPressedInterestButton,
    required this.isSelected,
    required this.iconOfWidget,
    required this.textOfWidget,
    required this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 350.w, height: 55.h),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textOfWidget,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Icon(iconOfWidget)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
