import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scout_tracker/models/user.dart';
import 'package:scout_tracker/screens/authentication/landing_page.dart';
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
      return LandingPage();
    } else if (user.uid != 'loading') {
      print(user.uid);
      print('signed in');
      return Home();
    } else {
      print('loading');
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber[200],
              Colors.redAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SpinKitThreeBounce(
          color: Colors.white,
        ),
      );
    }
  }
}
