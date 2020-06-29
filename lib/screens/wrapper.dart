import 'package:scout_tracker/models/user.dart';
import 'package:scout_tracker/screens/new_user/landing.dart';
import 'package:scout_tracker/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //return either home or new user page widget
    if (user == null) {
      print('new user');
      return Landing();
    } else if (user.uid != 'loading') {
      print(user.uid);
      print('signed in');
      return Home();
    } else {
      print('loading');
      return Container();
    }
  }
}
