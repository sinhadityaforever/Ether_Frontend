import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/popup_screen.dart';
import '../widgets/rounded_button.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); //Used for validation

  String loginemail = '';
  String loginpassword = '';
  bool showSpinner = false;

  //Set show spinner to true in setstate of login button till user gets loggedin
// loginemail and loginpassword will be replaced by ones which are entered by user
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xFF131C21),
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
                    width: 250.w,
                    height: 250.h,
                  ),
                  SizedBox(height: 48.h),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        loginemail = value;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email'),
                    validator: (value) {
                      if (RegExp(emailRegex).hasMatch(value!)) {
                        return null;
                      } else {
                        return "We detected wrong email! Intelligent, right?";
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
                      setState(() {
                        loginpassword = value;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password', errorMaxLines: 4),
                    validator: (value) {
                      if (RegExp(passwordRegex).hasMatch(value!)) {
                        return null;
                      } else {
                        return invalidPassword;
                      }
                    },
                  ),

                  //Below is the Signup/login button. We'll have to add a loading circle animation till the user is registered/logged in before taking to the chat screen route.
                  RoundedButton(
                      colorOfButton: Color(0xFFEB1555),
                      textOfButton: 'Open sesame!',
                      onPressedRoundButton: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          Provider.of<Data>(context, listen: false)
                              .showIndicator = true;
                        });

                        //if the upper statement is true, then there is validation error, so below code will not execute
                        int result =
                            await Provider.of<Data>(context, listen: false)
                                .loginUser(loginemail, loginpassword, context);
                        if (result != 200) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Popup(
                              popupTitle: "Can't open sesame!",
                              popuptext:
                                  "Please check your network and try again. Make sure you used the correct details. If you've signed up with Google, try signing in with Google.",
                            ),
                          );
                          Provider.of<Data>(context, listen: false)
                              .signOutGoogle();
                        }

                        setState(() {
                          Provider.of<Data>(context, listen: false)
                              .showIndicator = false;
                        });
                      }),

                  RoundedButton(
                    colorOfButton: Color(0xFF131C21),
                    textOfButton: "Don't have an account? Sign Up",
                    onPressedRoundButton: () async {
                      setState(() {
                        Navigator.pushNamed(context, '/signupOTP');
                      });
                    },
                  ),

                  RoundedButton(
                    colorOfButton: Color(0xFF131C21),
                    textOfButton: "Forgot password?",
                    onPressedRoundButton: () async {
                      setState(() {
                        Navigator.pushNamed(context, '/forgotPassword');
                      });
                    },
                  ),
                  SizedBox(
                    height: 50.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Color(0xFFEB1555),
                        onPressed: () async {
                          Provider.of<Data>(context, listen: false)
                              .changeIndicator();

                          int googleResult =
                              await Provider.of<Data>(context, listen: false)
                                  .handleWithGoogle();
                          print('handleWithGoogleExit');
                          if (googleResult == 200) {
                            print('google result 200');
                            int result = await Provider.of<Data>(context,
                                    listen: false)
                                .loginUser(
                                    Provider.of<Data>(context, listen: false)
                                        .googleUser
                                        .email!,
                                    Provider.of<Data>(context, listen: false)
                                        .secretPwd,
                                    context);
                            print('user logged in');
                            Provider.of<Data>(context, listen: false)
                                .changeIndicator();

                            if (result != 200) {
                              print('login result =! 200');
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Popup(
                                  popupTitle: "Can't sign you in",
                                  popuptext:
                                      "Please check your network and try again. Make sure you enter the correct details. If you've signed up using email, try signing in with your email.",
                                ),
                              );
                            }
                          } else {
                            Provider.of<Data>(context, listen: false)
                                .changeIndicator();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Popup(
                                popupTitle: "Can't sign you in",
                                popuptext:
                                    "Either you messed up, or we messed up!",
                              ),
                            );
                          }
                        },
                        child: Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Color(0xFF11163B),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Popup(
                              popupTitle: "Coming soon",
                              popuptext:
                                  "Twitter login is not yet supported. Try other methods.",
                            ),
                          );
                        },
                        child: Icon(
                          FontAwesomeIcons.twitter,
                          color: Colors.white,
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Color(0xFF131C21),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Popup(
                              popupTitle: "Coming soon",
                              popuptext:
                                  "Facebook login is not yet supported. Try other methods.",
                            ),
                          );
                        },
                        child: Icon(
                          FontAwesomeIcons.facebookF,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
