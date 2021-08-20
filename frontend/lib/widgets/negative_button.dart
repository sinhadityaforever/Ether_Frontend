import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class negativeButton extends StatelessWidget {
  final IconData icon;
  final String action;
  final negativeAction;
  negativeButton(
      {required this.icon, required this.action, required this.negativeAction});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: negativeAction,
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.r,
              color: Color(0xFFEB1555),
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              action,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
