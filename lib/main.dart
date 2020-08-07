import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:scout_tracker/models/user.dart';
import 'package:scout_tracker/screens/authentication/landing.dart';
import 'package:scout_tracker/screens/home/home.dart';
import 'package:scout_tracker/screens/wrapper.dart';
import 'package:scout_tracker/services/auth.dart';
import 'package:scout_tracker/services/storage.dart';
import 'package:scout_tracker/shared.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // Route<dynamic> _generateRoute(RouteSettings settings) {
  //   final args = settings.arguments;

  //   switch (settings.name) {
  //     case '/landing':
  //       return MaterialPageRoute(builder: (context) => Landing());
  //     case '/home':
  //       return MaterialPageRoute(builder: (context) => Home());
  //     case '/':
  //       return MaterialPageRoute(builder: (context) => Wrapper());
  //     default:
  //       return MaterialPageRoute(
  //         builder: (context) => Container(
  //           alignment: Alignment.center,
  //           child: Text('error'),
  //         ),
  //       );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    List badgeNames;
    DefaultAssetBundle.of(context)
        .loadString('data/badge_list.txt')
        .then((text) {
      badgeNames = LineSplitter().convert(text);
      try {
        StorageService()
          ..saveAllBadgesJson(badgeNames)
          ..precacheImages(badgeNames, context);
      } catch (e) {
        print(e.toString());
      }
    });

    return StreamProvider<String>.value(
      initialData: 'loading',
      value: AuthService().user.map((user) => user?.uid),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white12,
            statusBarIconBrightness: Brightness.light),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child: MaterialApp(
            title: 'Scout Tracker',
            debugShowCheckedModeBanner: false,
            //onGenerateRoute: (RouteSettings settings) => _generateRoute(settings),
            theme: ThemeData(
              fontFamily: 'ProductSans',
            ),
            home: Wrapper(),
          ),
        ),
      ),
    );
  }
}
