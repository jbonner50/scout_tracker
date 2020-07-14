import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/screens/authentication/landing.dart';
import 'package:scout_tracker/screens/home/home.dart';
import 'package:scout_tracker/shared.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Widget _body;

  @override
  Widget build(BuildContext context) {
    _body = backgroundGradient(context);

    final String uid = Provider.of<String>(context);

    if (uid == null) {
      setState(() => _body = Landing());
    } else if (uid == 'loading') {
      setState(() => _body = backgroundGradient(context));
    } else {
      setState(() => _body = Home());
    }
    //loading = not received; null = no user; full uid = signed in
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      child: _body,
    );
  }
}
