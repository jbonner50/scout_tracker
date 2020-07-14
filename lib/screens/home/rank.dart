import 'package:flutter/material.dart';
import 'package:scout_tracker/services/auth.dart';

class Rank extends StatefulWidget {
  @override
  _RankState createState() => _RankState();
}

class _RankState extends State<Rank> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('sign out'),
        onPressed: () => AuthService().logout(),
      ),
    );
  }
}
