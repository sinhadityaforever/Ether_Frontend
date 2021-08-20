//As login screen and signup screen are almost same, refer login screen for further comments
import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/popup_screen.dart';
import '../../constants.dart';
import '../../widgets/rounded_button.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePassword extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  String newpassword = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0A0E21),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'images/logo.png',
                    height: 250.h,
                    width: 250.w,
                  ),
                  SizedBox(
                    height: 48.h,
                  ),
                  TextFormField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      newpassword = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText:
                            'Enter new password one that you remember :-)',
                        errorMaxLines: 4),
                    validator: (value) {
                      if (RegExp(passwordRegex).hasMatch(value!)) {
                        return null;
                      } else {
                        return invalidPassword;
                      }
                    },
                  ),
                  SizedBox(
                    height: 8.0.h,
                  ),
                  TextFormField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText:
                            'Re-enter new password. Dont forget this one.'),
                    validator: (value) {
                      if (value == newpassword) {
                        return null;
                      } else {
                        return "Passwords do not match :'-)";
                      }
                    },
                  ),
                  SizedBox(
                    height: 14.0.h,
                  ),
                  RoundedButton(
                      colorOfButton: Color(0xFFEB1555),
                      textOfButton: 'Change Password',
                      onPressedRoundButton: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        Provider.of<Data>(context, listen: false)
                            .changeIndicator();
                        int result =
                            await Provider.of<Data>(context, listen: false)
                                .changePassword(
                                    Provider.of<Data>(context, listen: false)
                                        .signupEmail,
                                    newpassword);

                        if (result != 200) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Popup(
                              popupTitle: "Can't change password",
                              popuptext:
                                  "Recheck if the email you entered is correct. If you're new, signup instead.",
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Popup(
                              modifiedAction: true,
                              popupTitle: "Password changed Successfully",
                              popuptext:
                                  "Your password have been changed. Login with your new password.",
                              onPressedOK: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/welcome',
                                    (Route<dynamic> route) => false);
                              },
                            ),
                          );
                        }
                        Provider.of<Data>(context, listen: false)
                            .changeIndicator();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
