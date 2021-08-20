import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String passwordRegex = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$";
String emailRegex =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
String invalidPassword =

    'At least 8 characters, one uppercase, one lowercase, one number, and no special characters. Simplest thing in the world, right?';

var kTextFieldDecoration = InputDecoration(
  hintText: 'Enter your email',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0.r)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFEB1555), width: 1.0.w),
    borderRadius: BorderRadius.all(Radius.circular(32.0.r)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFEB1555), width: 2.0.w),
    borderRadius: BorderRadius.all(Radius.circular(32.0.r)),
  ),
);
