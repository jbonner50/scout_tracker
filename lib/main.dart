import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/models/user.dart';
import 'package:scout_tracker/screens/wrapper.dart';
import 'package:scout_tracker/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      initialData: User(uid: 'loading'),
      value: AuthService().signInStream,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromRGBO(254, 44, 43, 1),
          fontFamily: 'ProductSans',
        ),
        home: Wrapper(),
      ),
    );
  }
}
