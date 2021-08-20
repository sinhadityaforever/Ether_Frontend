//As login screen and signup screen are almost same, refer login screen for further comments
import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/negative_popup.dart';
import 'package:frontend/widgets/popup_screen.dart';
import '../../constants.dart';
import '../../widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailConfirm extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<EmailConfirm> {
  final _formKey = GlobalKey<FormState>();

  String confirmemail = '';

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
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      confirmemail = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email'),
                    validator: (value) {
                      if (RegExp(emailRegex).hasMatch(value!)) {
                        return null;
                      } else {
                        return "Enter a valid email";
                      }
                    },
                  ),
                  SizedBox(
                    height: 8.0.h,
                  ),
                  RoundedButton(
                      colorOfButton: Color(0xFFEB1555),
                      textOfButton: 'Send OTP',
                      onPressedRoundButton: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        Provider.of<Data>(context, listen: false)
                            .changeIndicator();
                        String result =
                            await Provider.of<Data>(context, listen: false)
                                .checkLoginMethod(confirmemail);
                        if (result == 'Google') {
                          Provider.of<Data>(context, listen: false)
                              .changeIndicator();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => NegativePopup(
                              action: 'Login',
                              onPresseedPopup: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              negativeTitle: "Different signup method detected",
                              popuptext:
                                  "Looks like you've signed up using google, try signing in using google",
                            ),
                          );
                        } else {
                          Provider.of<Data>(context, listen: false)
                              .signupEmail = confirmemail;

                          await Provider.of<Data>(context, listen: false)
                              .getOTP(Provider.of<Data>(context, listen: false)
                                  .signupEmail);
                          Provider.of<Data>(context, listen: false)
                              .changeIndicator();
                          Navigator.pushNamed(context, '/otpPassword');
                        }
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
