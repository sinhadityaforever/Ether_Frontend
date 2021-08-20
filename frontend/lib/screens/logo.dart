import 'package:flutter/material.dart';
import 'package:frontend/api_calls/data.dart';
import 'package:provider/provider.dart';

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<Data>(context, listen: false).verification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Image.asset('images/logo.png')],
    );
  }
}
