//As login screen and signup screen are almost same, refer login screen for further comments
import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:frontend/widgets/popup_screen.dart';
import '../../constants.dart';
import '../../widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmAccount extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<ConfirmAccount> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String signuppassword = '';
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
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your first name',
                    ),
                  ),
                  SizedBox(
                    height: 8.0.h,
                  ),
                  TextFormField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      signuppassword = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password, zuke has no access.',
                      errorMaxLines: 4,
                    ),
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
                      hintText: 'Type it again. Think of it as a test. :-)',
                    ),
                    validator: (value) {
                      if (value == signuppassword) {
                        return null;
                      } else {
                        return 'Passwords do not match, they need to right :-|';
                      }
                    },
                  ),
                  SizedBox(
                    height: 14.0.h,
                  ),
                  RoundedButton(
                      colorOfButton: Color(0xFFEB1555),
                      textOfButton: 'Open Sesame!',
                      onPressedRoundButton: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          Provider.of<Data>(context, listen: false)
                              .showIndicator = true;
                        });
                        int result =
                            await Provider.of<Data>(context, listen: false)
                                .signupUser(
                                    Provider.of<Data>(context, listen: false)
                                        .signupEmail,
                                    signuppassword,
                                    username,
                                    context);
                        if (result != 200) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Popup(
                              popupTitle: "Can't Open Sesame",
                              popuptext:
                                  "Either you messed up or we. Let us check.",
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
                      textOfButton: "Already in? Time for password test (^_-)",
                      onPressedRoundButton: () async {
                        setState(() {
                          Navigator.pushNamed(context, '/login');
                        });
                      }),
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
                          if (googleResult == 200) {
                            int result = await Provider.of<Data>(context,
                                    listen: false)
                                .signupUser(
                                    Provider.of<Data>(context, listen: false)
                                        .googleUser
                                        .email!,
                                    Provider.of<Data>(context, listen: false)
                                        .secretPwd,
                                    Provider.of<Data>(context, listen: false)
                                        .googleUser
                                        .displayName!,
                                    context);
                            Provider.of<Data>(context, listen: false)
                                .changeIndicator();

                            if (result != 200) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Popup(
                                  popupTitle: "Can't sign you up",
                                  popuptext: "Either you messed up, or we!",
                                ),
                              );
                            }
                          } else {
                            Provider.of<Data>(context, listen: false)
                                .changeIndicator();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Popup(
                                popupTitle: "Can't sign you up",
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
                                  "Twitter signup is not yet supported. Try other methods.",
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
                                  "Facebook signup is not yet supported. Try other methods.",
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
