import 'package:flutter/material.dart';
import 'package:scout_tracker/services/auth.dart';

class Badges extends StatefulWidget {
  final Key key;
  Badges(this.key);

  @override
  _BadgesState createState() => _BadgesState();
}

class _BadgesState extends State<Badges> {
  @override
  Widget build(BuildContext context) {
    return Center(
      key: widget.key,
      child: RaisedButton(
        child: Text('sign out'),
        onPressed: () => AuthService().logout(),
      ),
    );
  }
}
