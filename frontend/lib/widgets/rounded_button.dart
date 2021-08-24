import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:provider/provider.dart';

class RoundedButton extends StatefulWidget {
  RoundedButton({
    required this.colorOfButton,
    required this.onPressedRoundButton,
    required this.textOfButton,
  });

  final Color colorOfButton;
  final String textOfButton;
  final onPressedRoundButton;

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
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
          child: Provider.of<Data>(context).showIndicator
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  widget.textOfButton,
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
