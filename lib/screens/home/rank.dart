import 'package:flutter/material.dart';
import 'package:scout_tracker/services/auth.dart';
import 'dart:io';

class Rank extends StatefulWidget {
  Rank({Key key}) : super(key: key);

  @override
  _RankState createState() => _RankState();
}

class _RankState extends State<Rank> {
  @override
  Widget build(BuildContext context) {
    return Center(child: RaisedButton(onPressed: () => AuthService().logout()));
  }
}
